import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'slot.g.dart';

@JsonSerializable(createToJson: false)
@HiveType(typeId: 2)
class Slot {
  @HiveField(0)
  int bookableFrom;
  @HiveField(1)
  int minCourseParticipantCount;
  @HiveField(2)
  int maxCourseParticipantCount;
  @HiveField(3)
  int currentCourseParticipantCount;
  @HiveField(4)
  BookableState state;
  @HiveField(5)
  List<dynamic> selector;
  @HiveField(6)
  List<DateItem> dateList;

  Slot(
    this.bookableFrom,
    this.state,
    this.minCourseParticipantCount,
    this.maxCourseParticipantCount,
    this.currentCourseParticipantCount,
    this.dateList,
    this.selector,
  );

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

  String getSlotId() {
    return selector.last.toString();
  }

  int getStartTimestamp() {
    return dateList.first.start;
  }

  int getEndTimestamp() {
    return dateList.first.end;
  }

  DateTime getStartDate() {
    return DateTime.fromMillisecondsSinceEpoch(getStartTimestamp());
  }

  DateTime getEndDate() {
    return DateTime.fromMillisecondsSinceEpoch(getEndTimestamp());
  }
}

@JsonSerializable(createToJson: false)
@HiveType(typeId: 3)
class DateItem {
  @HiveField(0)
  int start;
  @HiveField(1)
  int end;

  DateItem(this.start, this.end);

  factory DateItem.fromJson(Map<String, dynamic> json) =>
      _$DateItemFromJson(json);
}

@HiveType(typeId: 4)
enum BookableState {
  @JsonValue("BOOKED")
  @HiveField(0)
  booked,
  @JsonValue("BOOKABLE")
  @HiveField(1)
  bookable,
  @JsonValue("FULLY_BOOKED")
  @HiveField(2)
  fullyBooked,
  @JsonValue("NOT_YET_BOOKABLE")
  @HiveField(3)
  notYetBookable,
  @JsonValue("NOT_BOOKABLE_ANYMORE")
  @HiveField(4)
  notBookableAnymore
}

