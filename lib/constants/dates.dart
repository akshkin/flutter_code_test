import 'package:intl/intl.dart';

class DateConstants {
  static DateTime _latestDate = DateTime.now();

  static set latestDate(DateTime newDate) {
    _latestDate = newDate;
  }

  // Getter for the formatted latest date (yyyy-MM-dd)
  static String get formattedLatestDate {
    return DateFormat('yyyy-MM-dd').format(_latestDate);
  }
}
