import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:wegoagain/favorites_screen.dart';
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
    settings: initializationSettings,
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
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

    void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;
    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
      headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.deepPurple.shade200,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'WeGoAgain',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SwipableStackController _controller;
  bool _isLoading = true;
  List<String> _quotes = [
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

  String _currentQuote = "";
  Set<String> _favoriteQuotes = {};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
    _initApp();
  }

  Future<void> _initApp() async {
    await _initPrefs();
    await _loadQuote();
    _scheduleDailyQuoteNotification();
    _listenForNotifications();
  }

  Future<void> _loadQuote() async {
    final today = DateUtils.dateOnly(DateTime.now()).toIso8601String();
    final cachedDate = _prefs?.getString('quoteDate');
    final cachedQuote = _prefs?.getString('quoteOfTheDay');

    if (cachedDate == today && cachedQuote != null) {
      _setupQuotes(cachedQuote);
    } else {
      await _fetchQuoteOfTheDay();
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchQuoteOfTheDay() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        if (json.isNotEmpty) {
          final quote = json[0]['q'] as String;
          final author = json[0]['a'] as String;
          final formattedQuote = '"$quote" - $author';

          final today = DateUtils.dateOnly(DateTime.now()).toIso8601String();
          await _prefs?.setString('quoteOfTheDay', formattedQuote);
          await _prefs?.setString('quoteDate', today);

          _setupQuotes(formattedQuote);
        } else {
           _setupQuotes(null);
        }
      } else {
        _setupQuotes(null);
      }
    } catch (e) {
       _setupQuotes(null);
    }
  }

  void _setupQuotes(String? dailyQuote) {
      final tempQuotes = List<String>.from(_quotes);
      if (dailyQuote != null && !tempQuotes.contains(dailyQuote)) {
        tempQuotes.insert(0, dailyQuote);
      }
      setState(() {
        _quotes = tempQuotes;
        _currentQuote = _quotes.isNotEmpty ? _quotes[0] : "";
        _isLoading = false;
      });
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

  void _updateCurrentQuote(int index) {
    setState(() {
      if (index < _quotes.length) {
        _currentQuote = _quotes[index % _quotes.length];
      }
    });
  }

  void _shareQuote() {
    SharePlus.instance.share(
      ShareParams(text: _currentQuote),
    );
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
    String quote = _quotes[Random().nextInt(_quotes.length)];
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        if (json.isNotEmpty) {
          final fetchedQuote = json[0]['q'] as String;
          final author = json[0]['a'] as String;
          quote = '"$fetchedQuote" - $author';
        }
      }
    } catch (e) {
      // Fallback to a random quote if API fails
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Quote of the Day',
      body: quote,
      scheduledDate: _nextInstanceOfTenAM(),
      notificationDetails: const NotificationDetails(
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
           if (!_quotes.contains(payload)) {
            _quotes.insert(0, payload);
          }
          _controller.rewind();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WeGoAgain'),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
            tooltip: 'Favorite',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(favoriteQuotes: _favoriteQuotes.toList())));
            },
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SwipableStack(
                controller: _controller,
                onSwipeCompleted: (index, direction) {
                  final swipedQuote = _quotes[index % _quotes.length];
                  setState(() {
                    if (direction == SwipeDirection.right) {
                      _favoriteQuotes.add(swipedQuote);
                    } else if (direction == SwipeDirection.left) {
                      _favoriteQuotes.remove(swipedQuote);
                    }
                    _saveFavorites();
                  });
                  _updateCurrentQuote(index + 1);
                },
                builder: (context, properties) {
                  final quote = _quotes[properties.index % _quotes.length];
                  return Stack(
                    children: [
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Text(
                              quote,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                      ),
                      if (properties.swipeProgress > 0)
                        Center(
                          child: Opacity(
                            opacity: properties.swipeProgress,
                            child: Icon(
                              properties.direction == SwipeDirection.right ? Icons.favorite : Icons.close,
                              color: properties.direction == SwipeDirection.right ? Colors.green : Colors.red,
                              size: 100,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shareQuote,
        child: const Icon(Icons.share),
        tooltip: 'Share Quote',
      ),
    );
  }
}
