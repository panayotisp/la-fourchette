import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/outlook_header.dart'; // Corrected path

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          const OutlookHeader(
            title: 'Profile',
            icon: CupertinoIcons.person,
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.person),
                        title: const Text('Account'),
                        trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 16),
                      ListTile(
                        leading: const Icon(CupertinoIcons.settings),
                        title: const Text('Settings'),
                        trailing: const Icon(CupertinoIcons.chevron_right, size: 16),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
