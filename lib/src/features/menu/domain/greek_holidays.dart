import 'package:flutter/foundation.dart';

class GreekHolidays {
  /// Checks if a given date is a Greek public holiday.
  static bool isHoliday(DateTime date) {
    return getHolidayName(date) != null;
  }

  /// Returns the name of the holiday if the date is a holiday, otherwise null.
  static String? getHolidayName(DateTime date) {
    // 1. Fixed Holidays
    if (date.month == 1 && date.day == 1) return 'New Year\'s Day';
    if (date.month == 1 && date.day == 6) return 'Epiphany';
    if (date.month == 3 && date.day == 25) return 'Independence Day';
    if (date.month == 5 && date.day == 1) return 'Protomagia';
    if (date.month == 8 && date.day == 15) return 'Dormition of the Virgin Mary';
    if (date.month == 10 && date.day == 28) return 'Ochi Day';
    if (date.month == 12 && date.day == 25) return 'Christmas Day';
    if (date.month == 12 && date.day == 26) return 'Synaxis of the Mother of God';

    // 2. Movable Holidays (Dependent on Orthodox Easter)
    final easter = _getOrthodoxEaster(date.year);
    
    // Clean Monday (48 days before Easter)
    final cleanMonday = easter.subtract(const Duration(days: 48));
    if (_isSameDay(date, cleanMonday)) return 'Clean Monday';

    // Good Friday (2 days before Easter)
    final goodFriday = easter.subtract(const Duration(days: 2));
    if (_isSameDay(date, goodFriday)) return 'Good Friday';

    // Easter Sunday
    //if (_isSameDay(date, easter)) return 'Easter Sunday';

    // Easter Monday (1 day after Easter)
    final easterMonday = easter.add(const Duration(days: 1));
    if (_isSameDay(date, easterMonday)) return 'Easter Monday';

    // Holy Spirit (Whit Monday) - 50 days (7 weeks + 1 day) after Easter
    // Actually Pentecost is +49, Holy Spirit is +50
    final holySpirit = easter.add(const Duration(days: 50)); 
    if (_isSameDay(date, holySpirit)) return 'Holy Spirit Monday';

    return null;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Calculates the date of Orthodox Easter for a given year in the Gregorian calendar.
  /// Reliability: Uses the standard Meeus/Jones/Butcher algorithm for Julian Easter
  /// and applies the 13-day offset valid for the 20th and 21st centuries.
  static DateTime _getOrthodoxEaster(int year) {
    final int a = year % 4;
    final int b = year % 7;
    final int c = year % 19;
    final int d = (19 * c + 15) % 30;
    final int e = (2 * a + 4 * b - d + 34) % 7;
    final int month = ((d + e + 114) / 31).floor();
    final int day = ((d + e + 114) % 31) + 1;
    
    // Result is in Julian Calendar. Add 13 days for Gregorian (1900-2099).
    // Use UTC to avoid Daylight Savings Time offsets shifting the time to previous day (23:00)
    // when subtracting days (like for Clean Monday).
    return DateTime.utc(year, month, day).add(const Duration(days: 13));
  }
}
