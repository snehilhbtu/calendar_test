import 'package:intl/intl.dart';

class dateFormat {
  static String toUtcString(String dateTime) {
    return DateTime.parse(dateTime).toUtc().toString();
  }

  static String toISOString(String dateTime) {
    return DateTime.parse(dateTime).toIso8601String().toString();
  }

  static DateTime toLocalDateTime(String dateTime) {
    return DateTime.parse(toLocalString(dateTime));
  }

  static String toLocalString(String dateTime) {
    return DateTime.parse(dateTime).toLocal().toString();
  }

  static String toDate(String dateTime) {
    return DateFormat('dd-MMM-yyyy')
        .format(DateTime.parse(toLocalString(dateTime)));
  }

  static String to12hTime(String dateTime) {
    return DateFormat('h:mm a').format(DateTime.parse(toLocalString(dateTime)));
  }

  static String fullDateTime(String dateTime) {
    return '${toDate(dateTime)} ${to12hTime(dateTime)}';
  }
}
