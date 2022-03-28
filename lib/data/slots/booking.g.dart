// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$BookingRequestToJson(BookingRequest instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'type': instance.type,
      'shiftModelId': instance.shiftModelId,
      'city': instance.city,
      'email': instance.email,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'postalCode': instance.postalCode,
      'phoneMobile': instance.phoneMobile,
      'dateOfBirth': instance.dateOfBirth,
      'dateOfBirthString': instance.dateOfBirthString,
      'streetAndHouseNumber': instance.streetAndHouseNumber,
      'shiftSelector': instance.shiftSelector,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
    };

Map<String, dynamic> _$BookingParticipantToJson(BookingParticipant instance) =>
    <String, dynamic>{
      'tariffId': instance.tariffId,
      'isBookingPerson': instance.isBookingPerson,
      'email': instance.email,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'dateOfBirth': instance.dateOfBirth,
      'dateOfBirthString': instance.dateOfBirthString,
    };

BookingResponse _$BookingResponseFromJson(Map<String, dynamic> json) =>
    BookingResponse(
      json['code'] as int,
    );
