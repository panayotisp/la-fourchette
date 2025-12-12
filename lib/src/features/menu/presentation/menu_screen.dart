import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/weekly_menu.dart';
import '../data/mock_menu_repository.dart';
import '../../../common/widgets/outlook_header.dart'; // Corrected path
import 'daily_menu_list.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  DayOfWeek _selectedDay = DayOfWeek.values[DateTime.now().weekday - 1 >= 5 ? 0 : DateTime.now().weekday - 1]; // Default to today or Monday if weekend

  @override
  Widget build(BuildContext context) {
    // 1. Fetch Menu
    final menuAsync = ref.watch(mockMenuRepositoryProvider).getCurrentWeekMenu();


    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          // Custom Header (Outlook Style)
          OutlookHeader(
            title: 'Weekly Menu',
            icon: CupertinoIcons.book, // Menu icon
            bottomWidget: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF005A9E), // Darker Blue for background
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(2),
              child: Row(
                children: DayOfWeek.values.map((day) {
                  final isSelected = _selectedDay == day;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDay = day),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          _getShortDayName(day),
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF0078D4) : Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // 3. Content
          Expanded(
            child: FutureBuilder<WeeklyMenu>(
               future: menuAsync,
               builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(child: CupertinoActivityIndicator());
                 }
                 if (snapshot.hasError) {
                   return Center(child: Text('Error: ${snapshot.error}'));
                 }
                 if (!snapshot.hasData) {
                   return const Center(child: Text('No menu data.'));
                 }

                 final menu = snapshot.data!;
                 final dailyItems = menu.getMenuForDay(_selectedDay);

                 return DailyMenuList(items: dailyItems);
               }
            ),
          ),
        ],
      ),
    );
  }

  String _getShortDayName(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday: return 'Mon';
      case DayOfWeek.tuesday: return 'Tue';
      case DayOfWeek.wednesday: return 'Wed';
      case DayOfWeek.thursday: return 'Thu';
      case DayOfWeek.friday: return 'Fri';
    }
  }
}
