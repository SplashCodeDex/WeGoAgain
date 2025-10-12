import 'package:WeGoAgain/services/recommendation_service.dart';
import 'package:WeGoAgain/services/in_app_purchase_service.dart';
import 'package:WeGoAgain/services/notification_service.dart';
import 'package:WeGoAgain/services/leaderboard_service.dart';
import 'package:WeGoAgain/services/achievement_service.dart';
import 'package:flutter/material.dart';
import 'package:WeGoAgain/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:WeGoAgain/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:forui/forui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  await notificationService.scheduleDailyQuoteNotification();

  // final InAppPurchaseService inAppPurchaseService = InAppPurchaseService();
  // await inAppPurchaseService.initPlatformState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AchievementService()),
        ChangeNotifierProvider(create: (context) => LeaderboardService()),
        // ChangeNotifierProvider(create: (context) => inAppPurchaseService),
        ChangeNotifierProvider(create: (context) => RecommendationService()),
      ],
      child: const WeGoAgain(),
    ),
  );
}

class WeGoAgain extends StatelessWidget {
  const WeGoAgain({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeMode == ThemeMode.dark ? FThemes.zinc.dark : FThemes.zinc.light;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'WeGoAgain',
          debugShowCheckedModeBanner: false,
          theme: theme.toApproximateMaterialTheme(),
          darkTheme: theme.toApproximateMaterialTheme(), // Forui handles dark/light internally
          themeMode: themeProvider.themeMode,
          builder: (context, child) => FAnimatedTheme(data: theme, child: child!),
          home: const MyHomePage(),
        );
      },
    );
  }
}
