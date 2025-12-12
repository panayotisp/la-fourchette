import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/food_item.dart';
import '../domain/weekly_menu.dart';

part 'mock_menu_repository.g.dart';

@riverpod
MockMenuRepository mockMenuRepository(Ref ref) {
  return MockMenuRepository();
}

class MockMenuRepository {
  final _uuid = const Uuid();

  Future<WeeklyMenu> getCurrentWeekMenu() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate mock data consistent with "5 different foods per weekday"
    return WeeklyMenu(
      weekStartDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      menuByDay: {
        for (var day in DayOfWeek.values) day: _generateDailyFoods(day),
      },
    );
  }

  List<FoodItem> _generateDailyFoods(DayOfWeek day) {
    // In a real app, this would come from a backend or file update every Friday.
    // Here we generate localized Greek-ish food examples.
    return List.generate(5, (index) {
      return FoodItem(
        id: _uuid.v4(),
        name: _getGreekDishName(day, index),
        description: 'Delicious authentic Greek dish.',
        imageUrl: index % 2 == 0 ? 'assets/images/moussaka.png' : 'assets/images/souvlaki.png',
        price: 8.5 + index,
        stock: 50,
      );
    });
  }

  String _getGreekDishName(DayOfWeek day, int index) {
    const dishes = [
      'Moussaka', 'Souvlaki', 'Spanakopita', 'Gemista', 'Pastitsio',
      'Gyros', 'Fasolada', 'Greek Salad', 'Tzatziki & Pita', 'Loukoumades'
    ];
    return '${dishes[(index + day.index) % dishes.length]} (${day.displayName})';
  }
}
