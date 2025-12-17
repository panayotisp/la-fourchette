import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/theme/app_theme.dart';
import 'routing/app_router.dart';

import 'common/services/notification_service.dart';

class LaFourchetteApp extends ConsumerStatefulWidget {
  const LaFourchetteApp({super.key});

  @override
  ConsumerState<LaFourchetteApp> createState() => _LaFourchetteAppState();
}

class _LaFourchetteAppState extends ConsumerState<LaFourchetteApp> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications
    Future.microtask(() => ref.read(notificationServiceProvider).init());
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    return CupertinoApp.router(
      title: 'La Fourchette',
      theme: AppTheme.lightTheme, // Support dark mode later
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
    );
  }
}
