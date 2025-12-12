import 'package:equatable/equatable.dart';
import 'food_item.dart';

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday;

  String get displayName {
    switch (this) {
      case DayOfWeek.monday: return 'Monday';
      case DayOfWeek.tuesday: return 'Tuesday';
      case DayOfWeek.wednesday: return 'Wednesday';
      case DayOfWeek.thursday: return 'Thursday';
      case DayOfWeek.friday: return 'Friday';
    }
  }
}

class WeeklyMenu extends Equatable {
  final Map<DayOfWeek, List<FoodItem>> menuByDay;
  final DateTime weekStartDate;

  const WeeklyMenu({
    required this.menuByDay,
    required this.weekStartDate,
  });

  List<FoodItem> getMenuForDay(DayOfWeek day) {
    return menuByDay[day] ?? [];
  }

  @override
  List<Object?> get props => [menuByDay, weekStartDate];
}
