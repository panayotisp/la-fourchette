import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/weekly_menu.dart';
import '../data/api_menu_repository.dart'; // Changed from mock to API
import '../../../common/widgets/outlook_header.dart'; // Corrected path
import 'daily_menu_list.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  late DayOfWeek _selectedDay;

  @override
  void initState() {
    super.initState();
    // Set initial day based on current date
    final now = DateTime.now();
    final weekday = now.weekday; // 1=Monday, 7=Sunday
    
    if (weekday >= 1 && weekday <= 5) {
      // Monday-Friday: show current day
      _selectedDay = DayOfWeek.values[weekday - 1];
    } else {
      // Saturday-Sunday: default to Monday
      _selectedDay = DayOfWeek.monday;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch Menu from API (Cached)
    final menuAsync = ref.watch(currentWeekMenuApiProvider);


    // Responsive Width Check
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    // Calculate Date
    final now = DateTime.now();
    
    // If weekend, calculate for NEXT week
    final effectiveDate = (now.weekday >= 6) 
        ? now.add(const Duration(days: 7)) 
        : now;
    
    final monday = effectiveDate.subtract(Duration(days: effectiveDate.weekday - 1));
    final selectedDate = monday.add(Duration(days: _selectedDay.index));
    
    // Header Date String
    final dayName = isWide ? _selectedDay.displayName : _getShortDayName(_selectedDay);
    final monthName = isWide ? _getFullMonth(selectedDate.month) : _getShortMonth(selectedDate.month);
    final dateStr = '$dayName, ${selectedDate.day} $monthName';

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          // Custom Header (Outlook Style)
          OutlookHeader(
            title: 'Menu',
            icon: CupertinoIcons.book, // Menu icon
            trailing: Text(
              dateStr,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                          isWide ? day.displayName : _getShortDayName(day),
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
            child: menuAsync.when(
              data: (menu) {
                final dailyItems = menu.getMenuForDay(_selectedDay);
                return DailyMenuList(items: dailyItems);
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
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

  String _getShortMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getFullMonth(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}
