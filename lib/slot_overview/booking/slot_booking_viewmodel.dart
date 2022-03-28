import 'package:get_it/get_it.dart';
import 'package:mono/data/slots/booking.dart';
import 'package:mono/data/slots/slots_repository.dart';
import 'package:mono/data/slots/slot.dart';
import 'package:mono/utils/date_utils.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SlotBookingViewModel {
  final SlotsRepository _repository = GetIt.I();
  late Slot slot;

  SlotBookingViewModel(String slotId) {
    slot = _repository.getCachedSlotById(slotId)!;
  }

  String getDateString() {
    return slot.getStartDate().formatDayShort() +
        " " +
        slot.getStartDate().formatTime() +
        " - " +
        slot.getEndDate().formatTime();
  }

  Future<BookingResponse> onExecuteBookingClicked() {
    return _repository.requestBooking(slot);
  }

  onAddToCalendarClicked() {
    final local = GetIt.I.get<AppLocalizations>();

    final event = Event(
      title: local.slotBookingCalendarTitle,
      location: local.slotBookingCalendarLocation,
      startDate: slot.getStartDate(),
      endDate: slot.getEndDate()
    );

    Add2Calendar.addEvent2Cal(event);
  }
}
