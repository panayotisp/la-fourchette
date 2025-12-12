import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/theme/app_theme.dart';
import 'routing/app_router.dart';

class LaFourchetteApp extends ConsumerWidget {
  const LaFourchetteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return CupertinoApp.router(
      title: 'La Fourchette',
      theme: AppTheme.lightTheme, // Support dark mode later
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
