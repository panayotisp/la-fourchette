import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../menu/presentation/menu_screen.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class EmployeeHomeScaffold extends StatefulWidget {
  const EmployeeHomeScaffold({super.key});

  @override
  State<EmployeeHomeScaffold> createState() => _EmployeeHomeScaffoldState();
}

class _EmployeeHomeScaffoldState extends State<EmployeeHomeScaffold> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const MenuScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
