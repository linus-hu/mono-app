import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mono/data/slots/booked_slots_dao.dart';
import 'package:mono/data/slots/booking.dart';
import 'package:mono/data/slots/slot_filter/slot_filter.dart';
import 'package:mono/data/slots/booking_event.dart';
import 'package:mono/data/slots/slot_loading_state.dart';
import 'package:mono/data/account/account_data.dart';
import 'package:mono/data/account/account_dao.dart';
import 'package:mono/utils/string_utils.dart';
import 'slot.dart';

class SlotsRepository {
  static const routeSlots =
      "https://backend.dr-plano.com/courses_dates?id=108202181&advanceToFirstMonthWithDates&start=%s&end=%s";
  static const routeBookingRequest = "https://backend.dr-plano.com/bookable";

  late final Dio _dio = _getDio();
  late final List<SlotFilter> _slotFilter;
  late final BookedSlotsDao _bookedSlotsDao = GetIt.I();
  late final StreamController<SlotLoadingState> _slotLoadingStreamController;

  SlotLoadingState _lastSlotLoadingState = SlotLoadingState.loading(true);

  SlotsRepository() {
    _slotLoadingStreamController = StreamController<SlotLoadingState>.broadcast(
      onListen: () async {
        _slotLoadingStreamController.add(_lastSlotLoadingState);
      },
    );

    _slotLoadingStreamController.stream.listen(
      (event) {
        _lastSlotLoadingState = event;
      },
    );

    _initFilter();
  }

  fetchSlots() async {
    _slotLoadingStreamController
        .add(_lastSlotLoadingState.copyWith(isLoading: true));
    var start = DateTime.now();
    var end = start.add(const Duration(days: 7));
    final response = await _dio.get(
      routeSlots
          .format([start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]),
      options: Options(responseType: ResponseType.plain),
    );

    if (response.statusCode == 200) {
      var slots = (jsonDecode(response.data) as List)
          .map((e) => Slot.fromJson(e))
          .where(
        (slot) {
          final activeFilter = _slotFilter.where((filter) => filter.isActive());
          final andFilter = activeFilter.whereType<SlotAndFilter>();
          final orFilter = activeFilter.whereType<SlotOrFilter>();

          return activeFilter.isEmpty ||
              (orFilter.isEmpty ||
                      orFilter.any((filter) => filter.applyFilter(slot))) &&
                  (andFilter.isEmpty ||
                      andFilter.every((filter) => filter.applyFilter(slot)));
        },
      ).toList();
      slots.sort(
          (a, b) => a.getStartTimestamp().compareTo(b.getStartTimestamp()));
      _slotLoadingStreamController.add(SlotLoadingState.withData(slots));
    } else {
      _slotLoadingStreamController.add(SlotLoadingState.withError(true));
      throw Exception('Failed to load slots');
    }
  }

  Future<BookingResponse> requestBooking(Slot slot) async {
    final AccountData accountData = GetIt.I<AccountDao>().fetchAccountData();
    if (!accountData.hasAllData()) {
      throw Exception("Incomplete account data");
    }

    /// DEBUG OPTION
    // await Future.delayed(const Duration(milliseconds: 1000));
    // final response = BookingResponse(200);
    // _bookedSlotsDao.addBookedSlot(slot);
    // fetchSlots();
    // return response;


    final response = await _dio.post(
      routeBookingRequest,
      data: BookingRequest.build(slot, accountData).toJson(),
      options: Options(responseType: ResponseType.plain),
    );

    if (response.statusCode == 200) {
      final bookingResponse =
          BookingResponse.fromJson(jsonDecode(response.data));
      if (bookingResponse.isSuccessful()) {
        _bookedSlotsDao.addBookedSlot(slot);
      }
      fetchSlots();
      return bookingResponse;
    } else {
      fetchSlots();
      throw Exception('Slot booking failed');
    }
  }

  Slot? getCachedSlotById(String slotId) {
    return _lastSlotLoadingState.slots
        ?.firstWhere((element) => element.getSlotId() == slotId);
  }

  Stream<SlotLoadingState> getSlotLoadingStream() =>
      _slotLoadingStreamController.stream;

  List<SlotFilter> getSlotFilter() => List.unmodifiable(_slotFilter);

  bool hasActiveSlotFilter() => _slotFilter.any((filter) => filter.isActive());

  setWeekdayFilterActive(int weekday, bool active) {
    _slotFilter
        .whereType<WeekdayFilter>()
        .firstWhere((item) => item.weekday == weekday)
        .setActive(active);
  }

  setMinStartTimeFilter(TimeOfDay minStartTime) {
    _slotFilter.whereType<TimeFilter>().first.setMinTime(minStartTime);
  }

  setMaxStartTimeFilter(TimeOfDay maxStartTime) {
    _slotFilter.whereType<TimeFilter>().first.setMaxTime(maxStartTime);
  }

  setHideFullSlotsFilter(bool selected) {
    _slotFilter.whereType<HideFullSlotsFilter>().first.setActive(selected);
  }

  resetFilter() {
    for (var filter in _slotFilter) {
      filter.reset();
    }
  }

  Dio _getDio() {
    final dio = Dio();

    /**
     * Optional for usage of proxy
     */
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) => "PROXY 192.168.188.74:8888";
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    // };
    return dio;
  }

  _initFilter() {
    _slotFilter = List<SlotFilter>.of([
      WeekdayFilter.monday(),
      WeekdayFilter.tuesday(),
      WeekdayFilter.wednesday(),
      WeekdayFilter.thursday(),
      WeekdayFilter.friday(),
      WeekdayFilter.saturday(),
      WeekdayFilter.sunday(),
      TimeFilter(),
      HideFullSlotsFilter()
    ]);
  }
}
