// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlotAdapter extends TypeAdapter<Slot> {
  @override
  final int typeId = 2;

  @override
  Slot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Slot(
      fields[0] as int,
      fields[4] as BookableState,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      (fields[6] as List).cast<DateItem>(),
      (fields[5] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Slot obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.bookableFrom)
      ..writeByte(1)
      ..write(obj.minCourseParticipantCount)
      ..writeByte(2)
      ..write(obj.maxCourseParticipantCount)
      ..writeByte(3)
      ..write(obj.currentCourseParticipantCount)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.selector)
      ..writeByte(6)
      ..write(obj.dateList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateItemAdapter extends TypeAdapter<DateItem> {
  @override
  final int typeId = 3;

  @override
  DateItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DateItem(
      fields[0] as int,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DateItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookableStateAdapter extends TypeAdapter<BookableState> {
  @override
  final int typeId = 4;

  @override
  BookableState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookableState.booked;
      case 1:
        return BookableState.bookable;
      case 2:
        return BookableState.fullyBooked;
      case 3:
        return BookableState.notYetBookable;
      case 4:
        return BookableState.notBookableAnymore;
      default:
        return BookableState.booked;
    }
  }

  @override
  void write(BinaryWriter writer, BookableState obj) {
    switch (obj) {
      case BookableState.booked:
        writer.writeByte(0);
        break;
      case BookableState.bookable:
        writer.writeByte(1);
        break;
      case BookableState.fullyBooked:
        writer.writeByte(2);
        break;
      case BookableState.notYetBookable:
        writer.writeByte(3);
        break;
      case BookableState.notBookableAnymore:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookableStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slot _$SlotFromJson(Map<String, dynamic> json) => Slot(
      json['bookableFrom'] as int,
      $enumDecode(_$BookableStateEnumMap, json['state']),
      json['minCourseParticipantCount'] as int,
      json['maxCourseParticipantCount'] as int,
      json['currentCourseParticipantCount'] as int,
      (json['dateList'] as List<dynamic>)
          .map((e) => DateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['selector'] as List<dynamic>,
    );

const _$BookableStateEnumMap = {
  BookableState.booked: 'BOOKED',
  BookableState.bookable: 'BOOKABLE',
  BookableState.fullyBooked: 'FULLY_BOOKED',
  BookableState.notYetBookable: 'NOT_YET_BOOKABLE',
  BookableState.notBookableAnymore: 'NOT_BOOKABLE_ANYMORE',
};

DateItem _$DateItemFromJson(Map<String, dynamic> json) => DateItem(
      json['start'] as int,
      json['end'] as int,
    );
