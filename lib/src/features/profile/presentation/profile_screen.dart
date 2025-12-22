import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/theme/app_theme.dart';
import '../../../common/widgets/app_header.dart';
import 'purchase_history_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          const AppHeader(
            title: 'Profile',
            icon: CupertinoIcons.person,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 20),
                // 1. Profile Header
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: CupertinoColors.systemGrey5,
                        // Placeholder image or icon
                        child: Icon(CupertinoIcons.person_solid, size: 50, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),

                // 2. Menu Options (Grouped List)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: AppTheme.cardRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuRow(
                        icon: CupertinoIcons.time,
                        title: 'Purchase History',
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(builder: (context) => const PurchaseHistoryScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 56), // 16 + 24 + 16 (padding + icon + padding)
                      _buildMenuRow(
                        icon: CupertinoIcons.question,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(builder: (context) => const HelpSupportScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildMenuRow(
                        icon: CupertinoIcons.settings,
                        title: 'Settings',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Optional: Sign Out Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoButton(
                    color: CupertinoColors.systemBackground,
                    child: const Text('Sign Out', style: TextStyle(color: CupertinoColors.destructiveRed)),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: CupertinoColors.systemGrey, size: 28),
      title: Text(
        title, 
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
      ),
      trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
