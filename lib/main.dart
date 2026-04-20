import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:wegoagain/favorites_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// ---------------------------------------------------------
// Data Model
// ---------------------------------------------------------
class HardTruth {
  final String id;
  final String title;
  final String content;
  final String category;
  final String source;

  HardTruth({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.source,
  });

  factory HardTruth.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return HardTruth(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'Advice',
      source: data['source'] ?? 'Unknown',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
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
      headlineSmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w500),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.light),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.dark),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'WeGoAgain',
          debugShowCheckedModeBanner: false,
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
  List<HardTruth> _truths = [];
  HardTruth? _currentTruth;
  
  Set<String> _favoriteIds = {};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
    _initApp();
  }

  Future<void> _initApp() async {
    await _initPrefs();
    await _fetchTruthsFromFirestore();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = _prefs?.getStringList('favoriteTruthIds')?.toSet() ?? {};
    });
  }

  Future<void> _fetchTruthsFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('truths').get();
      final truths = snapshot.docs.map((doc) => HardTruth.fromFirestore(doc)).toList();
      
      // Fallback if empty database
      if (truths.isEmpty) {
        truths.add(HardTruth(
          id: 'fallback_1',
          title: 'Stay Consistent',
          content: 'No database content found yet. Start small.',
          category: 'System',
          source: 'WeGoAgain',
        ));
      }

      setState(() {
        _truths = truths;
        _currentTruth = _truths.isNotEmpty ? _truths[0] : null;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching truths: $e");
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _saveFavorites() async {
    await _prefs?.setStringList('favoriteTruthIds', _favoriteIds.toList());
  }

  void _updateCurrentTruth(int index) {
    if (_truths.isNotEmpty) {
      setState(() {
        _currentTruth = _truths[index % _truths.length];
      });
    }
  }

  void _shareQuote() {
    if (_currentTruth != null) {
      Share.share('${_currentTruth!.title}\\n\\n${_currentTruth!.content}\\n\\n- ${_currentTruth!.source}');
    }
  }

  void _toggleFavorite() {
    if (_currentTruth == null) return;
    setState(() {
      if (_isFavorite) {
        _favoriteIds.remove(_currentTruth!.id);
      } else {
        _favoriteIds.add(_currentTruth!.id);
      }
      _saveFavorites();
    });
  }

  bool get _isFavorite => _currentTruth != null && _favoriteIds.contains(_currentTruth!.id);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(favoriteIds: _favoriteIds.toList())));
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
              child: _truths.isEmpty
                  ? const Text("No truths available.")
                  : SwipableStack(
                      controller: _controller,
                      onSwipeCompleted: (index, direction) {
                        final swipedTruth = _truths[index % _truths.length];
                        setState(() {
                          if (direction == SwipeDirection.right) {
                            _favoriteIds.add(swipedTruth.id);
                          } else if (direction == SwipeDirection.left) {
                            _favoriteIds.remove(swipedTruth.id);
                          }
                          _saveFavorites();
                        });
                        _updateCurrentTruth(index + 1);
                      },
                      builder: (context, properties) {
                        final truth = _truths[properties.index % _truths.length];
                        return Stack(
                          children: [
                            Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                                child: SingleChildScrollView(
                                  // This enables scrollable long-form reading inside the card!
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          truth.category.toUpperCase(),
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        truth.title,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        truth.content,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          height: 1.6,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      Row(
                                        children: [
                                          Icon(Icons.source, size: 16, color: Colors.grey),
                                          const SizedBox(width: 8),
                                          Text(
                                            truth.source,
                                            style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (properties.swipeProgress > 0)
                              Center(
                                child: Opacity(
                                  opacity: properties.swipeProgress,
                                  child: Icon(
                                    properties.direction == SwipeDirection.right ? Icons.bookmark : Icons.close,
                                    color: properties.direction == SwipeDirection.right ? Colors.green : Colors.red,
                                    size: 120,
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
        tooltip: 'Share',
      ),
    );
  }
}
