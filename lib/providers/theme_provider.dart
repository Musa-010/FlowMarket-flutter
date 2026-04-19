import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/hive_storage.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;

  ThemeModeNotifier(this._ref) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await _ref.read(hiveStorageProvider).isDarkMode();
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    await _ref.read(hiveStorageProvider).setDarkMode(!isDark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _ref
        .read(hiveStorageProvider)
        .setDarkMode(mode == ThemeMode.dark);
  }
}
