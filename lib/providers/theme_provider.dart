import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isPro = false;

  ThemeMode get themeMode => _themeMode;
  bool get isPro => _isPro;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  void togglePro() {
    _isPro = !_isPro;
    notifyListeners();
  }
}