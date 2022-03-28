import 'package:json_annotation/json_annotation.dart';
import 'package:mono/data/slots/slot.dart';
import 'package:mono/data/account/account_data.dart';
import 'package:mono/utils/date_utils.dart';
import 'package:mono/utils/string_utils.dart';

part 'booking.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class BookingRequest {
  final int clientId = 97610596;
  final String type = "booking";
  final String shiftModelId = "108202181";

  final String city;
  final String email;
  final String lastName;
  final String firstName;
  final String postalCode;
  final String phoneMobile;
  final String dateOfBirth;
  final String dateOfBirthString;
  final String streetAndHouseNumber;
  final List<dynamic> shiftSelector;
  final List<BookingParticipant> participants;

  BookingRequest({
    required this.city,
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.postalCode,
    required this.phoneMobile,
    required this.dateOfBirth,
    required this.participants,
    required this.shiftSelector,
    required this.dateOfBirthString,
    required this.streetAndHouseNumber,
  });

  factory BookingRequest.build(Slot slot, AccountData accountData) {
    return BookingRequest(
      shiftSelector: slot.selector,
      city: accountData.city!,
      email: accountData.mail!,
      lastName: accountData.lastName!,
      firstName: accountData.firstName!,
      postalCode: accountData.postalCode!,
      phoneMobile: accountData.phoneNumber!,
      dateOfBirth: accountData.dateOfBirth!.toDateTime().formatApiDateOfBirth(),
      dateOfBirthString:
          accountData.dateOfBirth!.toDateTime().formatApiDateOfBirth(),
      streetAndHouseNumber: accountData.streetAndHousenumber!,
      participants: [BookingParticipant.fromAccountData(accountData)],
    );
  }

  Map<String, dynamic> toJson() => _$BookingRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class BookingParticipant {
  final int tariffId = 108202164;
  final bool isBookingPerson = true;

  final String email;
  final String lastName;
  final String firstName;
  final String dateOfBirth;
  final String dateOfBirthString;

  BookingParticipant({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.dateOfBirth,
    required this.dateOfBirthString,
  });

  factory BookingParticipant.fromAccountData(AccountData accountData) {
    return BookingParticipant(
      email: accountData.mail!,
      lastName: accountData.lastName!,
      firstName: accountData.firstName!,
      dateOfBirth: accountData.dateOfBirth!.toDateTime().formatApiDateOfBirth(),
      dateOfBirthString:
          accountData.dateOfBirth!.toDateTime().formatApiDateOfBirth(),
    );
  }

  Map<String, dynamic> toJson() => _$BookingParticipantToJson(this);
}

@JsonSerializable(createToJson: false)
class BookingResponse {
  int code;

  BookingResponse(this.code);

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);

  bool isSuccessful() => code == 200;
}
