import 'package:email_validator/email_validator.dart';

abstract class StringValidator {
  const StringValidator();

  bool validate(String? value);
}

class NotEmptyValidator extends StringValidator {
  const NotEmptyValidator();

  @override
  bool validate(String? value) {
    return value != null && value.isNotEmpty;
  }
}

class MailValidator extends StringValidator {
  const MailValidator();

  @override
  bool validate(String? value) {
    return value != null && EmailValidator.validate(value);
  }
}

class DateOfBirthValidator extends StringValidator {
  @override
  bool validate(String? value) {
    final dateOfBirthRegExp = RegExp(r"^(3[01]|[12]\d|0[1-9])\.(1[012]|0[1-9])\.(19\d{2}|200\d)$");
    return value != null && dateOfBirthRegExp.hasMatch(value);
  }
}