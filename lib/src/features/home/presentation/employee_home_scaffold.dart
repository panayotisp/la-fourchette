import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../menu/presentation/menu_screen.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../cart/data/api_reservation_repository.dart';
import '../../cart/domain/reservation.dart';

class EmployeeHomeScaffold extends ConsumerStatefulWidget {
  const EmployeeHomeScaffold({super.key});

  @override
  ConsumerState<EmployeeHomeScaffold> createState() => _EmployeeHomeScaffoldState();
}

class _EmployeeHomeScaffoldState extends ConsumerState<EmployeeHomeScaffold> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const MenuScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch cart count
    final cartAsync = ref.watch(apiReservationRepositoryProvider);
    final int cartCount = cartAsync.when(
      data: (reservations) => reservations
          .where((item) => item.status == ReservationStatus.cart)
          .fold(0, (sum, item) => sum + item.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: CupertinoTabBar(
          backgroundColor: Colors.transparent, // Let Container color show
          border: null, // Remove default border
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          activeColor: const Color(0xFF0078D4), // Match Outlook Blue
          inactiveColor: CupertinoColors.systemGrey,
          items: [
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 6.0), // ADJUST THIS VALUE to move icon up/down
                child: Icon(CupertinoIcons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6.0), // ADJUST THIS VALUE to move icon up/down
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cart),
                    if (cartCount > 0)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: CupertinoColors.systemRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 6.0), // ADJUST THIS VALUE to move icon up/down
                child: Icon(CupertinoIcons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
