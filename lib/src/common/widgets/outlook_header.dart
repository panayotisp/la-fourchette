import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlookHeader extends StatelessWidget {
  final String title;
  final Widget? bottomWidget;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onBack;

  const OutlookHeader({
    super.key,
    required this.title,
    this.bottomWidget,
    this.icon,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding + 10, bottom: 20, left: 16, right: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0078D4), // Outlook Blue
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (onBack != null) ...[
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        padding: const EdgeInsets.only(right: 12),
                        child: const Icon(CupertinoIcons.arrow_left, color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFF0078D4), size: 24),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (bottomWidget != null) ...[
            const SizedBox(height: 20),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}
