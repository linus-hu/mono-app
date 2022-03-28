import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DateTimeExt on DateTime {
  /// Format [DateTime] object to String like '15:30'
  String formatTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format [DateTime] object to String like 'Monday, 01.12'
  String formatDay() {
    return DateFormat('EEEE, dd.MM', GetIt.I.get<AppLocalizations>().localeName).format(this);
  }

  /// Format [DateTime] object to String like 'Mo, 01.12'
  String formatDayShort() {
    return DateFormat('EE, dd.MM', GetIt.I.get<AppLocalizations>().localeName).format(this);
  }

  /// Format [DateTime] object to String like 'February'
  String formatMonth() {
    return DateFormat('MMMM', GetIt.I.get<AppLocalizations>().localeName).format(this);
  }

  /// Format [DateTime] object to String like '1993-08-27'
  String formatApiDateOfBirth() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  DateTime applyTimeOfDay(TimeOfDay time) => DateTime(year, month, day, time.hour, time.minute);
}

extension TimeOfDayExt on TimeOfDay {

  double toDouble() => hour + minute/60.0;

  bool beforeOrEqual(TimeOfDay other) => toDouble() <= other.toDouble();
  bool afterOrEqual(TimeOfDay other) => toDouble() >= other.toDouble();

  String formatTime() {
    return DateTime.now().applyTimeOfDay(this).formatTime();
  }
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length >= newValue.text.length) {
      if (oldValue.text.endsWith(".")) {
        var dateText = newValue.text.substring(0, newValue.text.characters.length - 1);
        return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
      }
      return newValue;
    }

    var dateText = _addSeparators(newValue.text, '.');
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeparators(String value, String separator) {
    value = value.replaceAll('.', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += separator;
      }
      if (i == 3) {
        newString += separator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }

}