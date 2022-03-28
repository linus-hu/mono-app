import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/data/slots/slot.dart';

class BookedSlotsDao {
  final Box _box = GetIt.I();
  final String _boxKeyBookedSlots = "bookedSlots";

  BookedSlotsDao() {
    cleanupPastSlots();
  }

  List<Slot> fetchBookedSlots() {
    final List<dynamic> slots = _box.get(_boxKeyBookedSlots, defaultValue: List<Slot>.empty());
    return slots.cast<Slot>();
  }

  Future cleanupPastSlots() {
    final bookedSlots = fetchBookedSlots().toList()
      ..removeWhere((slot) => slot.getStartDate().isBefore(DateTime.now()));
    return _box.put(_boxKeyBookedSlots, bookedSlots);
  }

  Future addBookedSlot(Slot bookedSlot) {
    final bookedSlots = fetchBookedSlots().toList()
        ..add(bookedSlot);
    return _box.put(_boxKeyBookedSlots, bookedSlots);
  }

  Future removeSlotById(String slotId) {
    final bookedSlots = fetchBookedSlots().toList()
        ..removeWhere((slot) => slot.getSlotId() == slotId);
    return _box.put(_boxKeyBookedSlots, bookedSlots);
  }
}
