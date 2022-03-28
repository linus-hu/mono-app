import 'package:mono/data/slots/booking.dart';
import 'package:mono/data/slots/slot.dart';

class BookingEvent {
  final Slot slot;
  final BookingResponse bookingResponse;

  BookingEvent(this.slot, this.bookingResponse);
}