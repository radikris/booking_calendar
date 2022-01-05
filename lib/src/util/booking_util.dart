import 'package:intl/intl.dart';

class BookingUtil {
  BookingUtil._();

  static bool isOverLapping(DateTime firstStart, DateTime firstEnd, DateTime secondStart, DateTime secondEnd) {
    return getLatestDateTime(firstStart, secondStart).isBefore(getEarliestDateTime(firstEnd, secondEnd));
  }

  static DateTime getLatestDateTime(DateTime first, DateTime second) {
    return first.isAfterOrEq(second) ? first : second;
  }

  static DateTime getEarliestDateTime(DateTime first, DateTime second) {
    return first.isBeforeOrEq(second) ? first : second;
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }
}

extension DateTimeExt on DateTime {
  bool isBeforeOrEq(DateTime second) {
    return isBefore(second) || isAtSameMomentAs(second);
  }

  bool isAfterOrEq(DateTime second) {
    return isAfter(second) || isAtSameMomentAs(second);
  }

  DateTime get startOfDay => DateTime(year, month, day, 0, 0);
  DateTime get endOfDay => DateTime(year, month, day + 1, 0, 0);
}
