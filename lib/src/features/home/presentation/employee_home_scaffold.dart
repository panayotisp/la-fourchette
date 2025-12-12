import 'package:flutter/cupertino.dart';

import '../../menu/presentation/menu_screen.dart';

class EmployeeHomeScaffold extends StatefulWidget {
  const EmployeeHomeScaffold({super.key});

  @override
  State<EmployeeHomeScaffold> createState() => _EmployeeHomeScaffoldState();
}

class _EmployeeHomeScaffoldState extends State<EmployeeHomeScaffold> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const MenuScreen(),
    const Center(child: Text('Cart Placeholder')), 
    const Center(child: Text('Profile Placeholder')),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _tabs[index];
          },
        );
      },
    );
  }
}
