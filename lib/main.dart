import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/favorites_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalNotifications();
  tz.initializeTimeZones();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

Future<void> _configureLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      selectNotificationSubject.add(notificationResponse.payload);
    },
  );

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeMode == ThemeMode.light ? FThemes.zinc.light : FThemes.zinc.dark;

    return MaterialApp(
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      theme: theme.toApproximateMaterialTheme(),
      builder: (_, child) => FAnimatedTheme(data: theme, child: child!),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _quotes = [
    "The only way to do great work is to love what you do.",
    "Believe you can and you're halfway there.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "Success is not final, failure is not fatal: it is the courage to continue that counts.",
    "It does not matter how slowly you go as long as you do not stop.",
    "The only limit to our realization of tomorrow will be our doubts of today.",
    "The journey of a thousand miles begins with a single step.",
    "Keep your face always toward the sunshine—and shadows will fall behind you.",
    "What you get by achieving your goals is not as important as what you become by achieving your goals.",
    "We go again."
  ];

  String _currentQuote = "The only way to do great work is to love what you do.";
  Set<String> _favoriteQuotes = {};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _scheduleDailyQuoteNotification();
    _listenForNotifications();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteQuotes = _prefs?.getStringList('favoriteQuotes')?.toSet() ?? {};
    });
  }

  Future<void> _saveFavorites() async {
    await _prefs?.setStringList('favoriteQuotes', _favoriteQuotes.toList());
  }

  void _newQuote() {
    setState(() {
      _currentQuote = _quotes[Random().nextInt(_quotes.length)];
    });
  }

  void _shareQuote() {
    Share.share(_currentQuote);
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        _favoriteQuotes.remove(_currentQuote);
      } else {
        _favoriteQuotes.add(_currentQuote);
      }
      _saveFavorites();
    });
  }

  bool get _isFavorite => _favoriteQuotes.contains(_currentQuote);

  Future<void> _scheduleDailyQuoteNotification() async {
    final random = Random();
    final quote = _quotes[random.nextInt(_quotes.length)];

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Quote of the Day',
      quote,
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_quote_channel',
          'Daily Quote Notifications',
          channelDescription: 'Channel for daily inspirational quotes',
          importance: Importance.low,
          priority: Priority.low,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: quote,
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _listenForNotifications() {
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload != null && payload.isNotEmpty) {
        setState(() {
          _currentQuote = payload;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = FTheme.of(context);

    return FScaffold(
      header: FHeader(
        title: const Text('WeGoAgain'),
        suffixes: [
          FHeaderAction(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPress: _toggleFavorite,
            tooltip: _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
          ),
          FHeaderAction(
            icon: const Icon(Icons.list),
            onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(favoriteQuotes: _favoriteQuotes.toList())));
            },
            tooltip: 'View Favorites',
          ),
          FHeaderAction(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPress: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  _currentQuote,
                  key: ValueKey<String>(_currentQuote),
                  textAlign: TextAlign.center,
                  style: theme.typography.base.copyWith(
                    color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FButton(
                    onPress: _newQuote,
                    child: const Text('Another One'),
                  ),
                  const SizedBox(width: 16),
                  FButton(
                    onPress: _shareQuote,
                    child: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}