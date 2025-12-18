import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../common/widgets/outlook_header.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          OutlookHeader(
            title: 'Help & Support',
            icon: CupertinoIcons.question,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              children: [
                // Section 1: Catering & Orders
                _buildSectionHeader('CATERING & ORDERS'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSupportRow(
                        icon: CupertinoIcons.phone_fill,
                        title: 'Call Catering',
                        subtitle: '+30 210 1234567',
                        onTap: () => _launchUrl('tel:+302101234567'),
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSupportRow(
                        icon: CupertinoIcons.mail_solid,
                        title: 'Email Catering',
                        subtitle: 'catering@lafourchette.com',
                        onTap: () => _launchUrl('mailto:catering@lafourchette.com'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section 2: App Support (IT)
                _buildSectionHeader('APP SUPPORT'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSupportRow(
                        icon: CupertinoIcons.chat_bubble_text_fill,
                        title: 'Send Feedback',
                        subtitle: 'Tell us what you think',
                        onTap: () {}, // TODO: Implement Feedback Form
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSupportRow(
                        icon: CupertinoIcons.ant_fill, // Bug icon
                        title: 'Report a Problem',
                        subtitle: 'Contact IT Support',
                        onTap: () => _launchUrl('mailto:support@lafourchette.com?subject=Bug Report'),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.secondaryLabel,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSupportRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: CupertinoColors.activeBlue, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
      ),
      trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }
}
