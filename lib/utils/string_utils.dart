import 'package:sprintf/sprintf.dart';
import 'package:intl/intl.dart';

extension StringUtils on String {
  String format(var args) => sprintf(this, args);

  Uri toUri() => Uri.parse(this);

  /// Parse [String] with format 'dd.MM.yyyy' to [DateTime]
  DateTime toDateTime() => DateFormat('dd.MM.yyyy').parse(this);
}