import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HolidayView extends StatelessWidget {
  final String holidayName;
  final VoidCallback? onNextDay;

  const HolidayView({
    super.key, 
    required this.holidayName,
    this.onNextDay,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Sparkle Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.sparkles,
                size: 64,
                color: CupertinoColors.systemYellow,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              'Happy $holidayName!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'We are taking a break to celebrate. Our kitchen will be back open tomorrow!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            
            // Action Button
            if (onNextDay != null)
              CupertinoButton.filled(
                borderRadius: BorderRadius.circular(30),
                onPressed: onNextDay,
                child: const Text('See Tomorrow\'s Menu'),
              ),
          ],
        ),
      ),
    );
  }
}
