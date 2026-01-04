import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode state
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.dark});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

/// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState()) {
    _loadTheme();
  }

  /// Load saved theme preference
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkMode') ?? true; // Default to dark
      state = ThemeState(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      );
    } catch (e) {
      // If error, default to dark mode
      state = const ThemeState(themeMode: ThemeMode.dark);
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    state = state.copyWith(themeMode: newMode);

    // Save preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
    } catch (e) {
      // If save fails, continue anyway
    }
  }

  /// Set theme mode explicitly
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);

    // Save preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    } catch (e) {
      // If save fails, continue anyway
    }
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});










