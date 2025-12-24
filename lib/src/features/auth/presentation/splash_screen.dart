import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // For now, go to role selection
      // Future: Check auth state and route accordingly
      context.go('/role-select');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.square_favorites_alt_fill,
                size: 60,
                color: AppTheme.darkGreen,
              ),
            ),
            const SizedBox(height: 30),
            
            // App Name
            const Text(
              'La Fourchette',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              'Daily Menu System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 50),
            
            // Loading Indicator
            const CupertinoActivityIndicator(
              color: AppTheme.lightGreen,
              radius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
