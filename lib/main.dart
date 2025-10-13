import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
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

  void _newQuote() {
    setState(() {
      _currentQuote = _quotes[Random().nextInt(_quotes.length)];
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
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPress: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                  style: theme.typography.base.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              FButton(
                onPress: _newQuote,
                child: const Text('Another One'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}