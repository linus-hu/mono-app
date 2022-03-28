import 'package:hive/hive.dart';

part 'account_data.g.dart';

@HiveType(typeId: 1)
class AccountData {
  @HiveField(0)
  String? firstName;
  @HiveField(1)
  String? lastName;
  @HiveField(2)
  String? streetAndHousenumber;
  @HiveField(3)
  String? postalCode;
  @HiveField(4)
  String? city;
  @HiveField(5)
  String? mail;
  @HiveField(6)
  String? phoneNumber;
  @HiveField(7)
  String? dateOfBirth;

  AccountData({
    this.firstName,
    this.lastName,
    this.streetAndHousenumber,
    this.postalCode,
    this.city,
    this.mail,
    this.phoneNumber,
    this.dateOfBirth,
  });

  bool hasAnyData() {
    return firstName != null ||
        lastName != null ||
        streetAndHousenumber != null ||
        postalCode != null ||
        city != null ||
        mail != null ||
        phoneNumber != null ||
        dateOfBirth != null;
  }

  bool hasAllData() {
    return firstName != null &&
        lastName != null &&
        streetAndHousenumber != null &&
        postalCode != null &&
        city != null &&
        mail != null &&
        phoneNumber != null &&
        dateOfBirth != null;
  }
}
