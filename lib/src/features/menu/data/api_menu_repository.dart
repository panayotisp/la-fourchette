import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/weekly_menu.dart';
import '../domain/food_item.dart';
import '../../../config/api_config.dart';

part 'api_menu_repository.g.dart';

@Riverpod(keepAlive: true)
ApiMenuRepository apiMenuRepository(Ref ref) {
  return ApiMenuRepository();
}

@Riverpod(keepAlive: true)
Future<WeeklyMenu> currentWeekMenuApi(Ref ref) {
  return ref.watch(apiMenuRepositoryProvider).getCurrentWeekMenu();
}

class ApiMenuRepository {
  Future<WeeklyMenu> getCurrentWeekMenu() async {
    try {
      final now = DateTime.now();
      
      // If weekend (Saturday=6, Sunday=7), fetch NEXT week's menu
      final effectiveDate = (now.weekday >= 6) 
          ? now.add(const Duration(days: 7)) 
          : now;
      
      final monday = effectiveDate.subtract(Duration(days: effectiveDate.weekday - 1));
      final dateStr = '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
      
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.menuEndpoint}?date=$dateStr');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseWeeklyMenu(data);
      } else {
        throw Exception('Failed to load menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu: $e');
    }
  }

  WeeklyMenu _parseWeeklyMenu(Map<String, dynamic> json) {
    final weekStart = DateTime.parse(json['week_start']);
    final days = json['days'] as List<dynamic>;
    
    final Map<DayOfWeek, List<FoodItem>> menuByDay = {};
    
    for (final day in days) {
      final date = DateTime.parse(day['date']);
      final dayOfWeek = _getDayOfWeek(date.weekday);
      
      final List<FoodItem> items = (day['items'] as List<dynamic>).map((item) {
        final foodItem = item['food_item'];
        
        String imageUrl = foodItem['image_url'] ?? '';
        if (imageUrl.startsWith('/')) {
          imageUrl = '${ApiConfig.baseUrl}$imageUrl';
        }

        return FoodItem(
          id: item['schedule_id'],
          name: foodItem['name'],
          description: foodItem['name_en'] ?? '',
          imageUrl: imageUrl,
          price: (item['price'] as num).toDouble(),
          stock: item['stock_quantity'],
        );
      }).toList();
      
      menuByDay[dayOfWeek] = items;
    }
    
    return WeeklyMenu(
      menuByDay: menuByDay,
      weekStartDate: weekStart,
    );
  }

  DayOfWeek _getDayOfWeek(int weekday) {
    // weekday: 1=Monday, 2=Tuesday, etc.
    return DayOfWeek.values[weekday - 1];
  }
}
