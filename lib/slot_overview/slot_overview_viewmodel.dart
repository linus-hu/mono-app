import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:mono/data/slots/booked_slots_dao.dart';
import 'package:mono/data/slots/slots_repository.dart';
import 'package:mono/data/slots/slot.dart';
import 'package:mono/data/account/account_dao.dart';
import 'package:collection/collection.dart';
import 'package:mono/data/slots/slot_loading_state.dart';
import 'package:mono/utils/date_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SlotOverviewViewModel {
  late final Stream<SlotOverviewStateData> stateStream = _repository
      .getSlotLoadingStream()
      .map((event) => SlotOverviewStateData.fromSlotLoadingState(event));

  final SlotsRepository _repository = GetIt.I();
  final AccountDao _accountRepository = GetIt.I();

  bool get hasActiveFilter => _repository.hasActiveSlotFilter();

  bool get hasCompleteAccountData =>
      _accountRepository.fetchAccountData().hasAllData();

  fetchData() async {
    _repository.fetchSlots();
  }
}

class SlotOverviewStateData {
  bool hasError;
  bool isLoading;
  SlotOverviewData? overviewData;

  bool get hasData => overviewData != null;

  SlotOverviewStateData({
    required this.hasError,
    required this.isLoading,
    this.overviewData,
  });

  factory SlotOverviewStateData.fromSlotLoadingState(
      SlotLoadingState loadingState) {
    SlotOverviewData? data;
    if (loadingState.slots != null) {
      data = SlotOverviewData.fromSlots(loadingState.slots!);
    }
    return SlotOverviewStateData(
      hasError: loadingState.hasError,
      isLoading: loadingState.isLoading,
      overviewData: data,
    );
  }
}

class SlotOverviewData {
  List<SlotOverviewMonth> months;

  SlotOverviewData(this.months);

  factory SlotOverviewData.fromSlots(List<Slot> slots) {
    final bookedSlots = GetIt.I.get<BookedSlotsDao>().fetchBookedSlots();

    var groupedByMonth = groupBy(slots, (Slot slot) {
      var slotStartDateTime =
          DateTime.fromMillisecondsSinceEpoch(slot.getStartTimestamp());
      var slotDate = DateTime(slotStartDateTime.year, slotStartDateTime.month);
      return slotDate;
    });

    var months = List<SlotOverviewMonth>.empty(growable: true);
    groupedByMonth.forEach((key, slots) {
      months
          .add(SlotOverviewMonth.fromSlots(slots, bookedSlots, months.isEmpty));
    });

    return SlotOverviewData(months);
  }
}

class SlotOverviewMonth {
  String title;
  bool isFirstMonth;
  List<SlotOverviewDay> days;

  SlotOverviewMonth(this.title, this.isFirstMonth, this.days);

  factory SlotOverviewMonth.fromSlots(
      List<Slot> slotsPerMonth, List<Slot> bookedSlots, bool isFirstMonth) {
    var groupedByDay = groupBy(slotsPerMonth, (Slot slot) {
      var slotStartDateTime =
          DateTime.fromMillisecondsSinceEpoch(slot.getStartTimestamp());
      var slotDate = DateTime(slotStartDateTime.year, slotStartDateTime.month,
          slotStartDateTime.day);
      return slotDate;
    });

    var days = List<SlotOverviewDay>.empty(growable: true);
    groupedByDay.forEach((_, slot) {
      days.add(SlotOverviewDay.fromSlots(slot, bookedSlots));
    });

    return SlotOverviewMonth(
        slotsPerMonth.first.getStartDate().formatMonth(), isFirstMonth, days);
  }
}

class SlotOverviewDay {
  String title;
  List<SlotOverviewItem> items;

  SlotOverviewDay(this.title, this.items);

  factory SlotOverviewDay.fromSlots(List<Slot> slotsPerDay, List<Slot> bookedSlots) {
    return SlotOverviewDay(slotsPerDay.first.getStartDate().formatDay(),
        slotsPerDay.map((e) => SlotOverviewItem.fromSlot(e, bookedSlots)).toList());
  }
}

class SlotOverviewItem {
  String slotId;
  String duration;
  String bookableSlots;
  BookableState bookableState;

  SlotOverviewItem(
      this.bookableState, this.slotId, this.duration, this.bookableSlots);

  factory SlotOverviewItem.fromSlot(Slot slot, List<Slot> bookedSlots) {
    final localizations = GetIt.I.get<AppLocalizations>();
    final isBooked = bookedSlots.any((bookedSlot) => bookedSlot.getSlotId() == slot.getSlotId());
    return SlotOverviewItem(
      isBooked ? BookableState.booked : slot.state,
      slot.getSlotId(),
      localizations.slotItemDuration(slot.getStartDate(), slot.getEndDate()),
      localizations.slotItemFreeSlots(max(0,
          slot.maxCourseParticipantCount - slot.currentCourseParticipantCount)),
    );
  }
}
