import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/weekly_menu.dart';
import '../data/mock_menu_repository.dart';
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

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Weekly Menu'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 2. Day Selector
            _buildDaySelector(),
            Container(height: 1, color: CupertinoColors.separator),
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
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 60,
      color: CupertinoColors.systemBackground,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: DayOfWeek.values.length,
        itemBuilder: (context, index) {
            final day = DayOfWeek.values[index];
            final isSelected = _selectedDay == day;
            return GestureDetector(
              onTap: () => setState(() => _selectedDay = day),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  day.displayName,
                  style: TextStyle(
                    color: isSelected ? CupertinoColors.white : CupertinoColors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
