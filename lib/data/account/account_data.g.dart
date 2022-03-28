// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountDataAdapter extends TypeAdapter<AccountData> {
  @override
  final int typeId = 1;

  @override
  AccountData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountData(
      firstName: fields[0] as String?,
      lastName: fields[1] as String?,
      streetAndHousenumber: fields[2] as String?,
      postalCode: fields[3] as String?,
      city: fields[4] as String?,
      mail: fields[5] as String?,
      phoneNumber: fields[6] as String?,
      dateOfBirth: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.streetAndHousenumber)
      ..writeByte(3)
      ..write(obj.postalCode)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.mail)
      ..writeByte(6)
      ..write(obj.phoneNumber)
      ..writeByte(7)
      ..write(obj.dateOfBirth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
