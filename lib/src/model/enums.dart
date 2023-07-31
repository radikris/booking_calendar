import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek, CalendarFormat;

enum CalendarFormat {
  month,
  twoWeeks,
  week,
}

extension CalendarFormatX on CalendarFormat {
  tc.CalendarFormat toTC() {
    switch (this) {
      case CalendarFormat.month:
        return tc.CalendarFormat.month;
      case CalendarFormat.twoWeeks:
        return tc.CalendarFormat.twoWeeks;
      case CalendarFormat.week:
        return tc.CalendarFormat.week;
    }
  }
}

enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension StartingDayOfWeekX on StartingDayOfWeek {
  tc.StartingDayOfWeek toTC() {
    switch (this) {
      case StartingDayOfWeek.monday:
        return tc.StartingDayOfWeek.monday;

      case StartingDayOfWeek.tuesday:
        return tc.StartingDayOfWeek.tuesday;

      case StartingDayOfWeek.wednesday:
        return tc.StartingDayOfWeek.wednesday;

      case StartingDayOfWeek.thursday:
        return tc.StartingDayOfWeek.thursday;

      case StartingDayOfWeek.friday:
        return tc.StartingDayOfWeek.friday;

      case StartingDayOfWeek.saturday:
        return tc.StartingDayOfWeek.saturday;

      case StartingDayOfWeek.sunday:
        return tc.StartingDayOfWeek.sunday;
    }
  }
}
