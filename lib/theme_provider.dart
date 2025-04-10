import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default theme is dark

  ThemeMode get themeMode => _themeMode;

  // Toggle between light and dark theme
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();
  }

  // Check if current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
