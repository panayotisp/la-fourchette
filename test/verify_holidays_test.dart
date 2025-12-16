import 'package:flutter_test/flutter_test.dart';
import 'package:la_fourchette/src/features/menu/domain/greek_holidays.dart';

void main() {
  test('Print Greek Holidays for 2026', () {
    final year = 2026;
    print('\n--- ALL PUBLIC HOLIDAYS FOR $year ---');
    
    // Check every single day of the year
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));
      final holiday = GreekHolidays.getHolidayName(date);
      
      if (holiday != null) {
        // Format: DayName DD/MM - HolidayName
        final dayStr = date.day.toString().padLeft(2, '0');
        final monthStr = date.month.toString().padLeft(2, '0');
        print('$dayStr/$monthStr: $holiday');
      }
    }
    print('-----------------------------------\n');
  });
}
