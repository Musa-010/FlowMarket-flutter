import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveStorageProvider = Provider<HiveStorage>((ref) {
  return HiveStorage();
});

class HiveStorage {
  static const _prefsBox = 'preferences';
  static const _cacheBox = 'cache';
  static const _searchBox = 'recent_searches';

  // --- Preferences ---

  Future<bool> hasSeenOnboarding() async {
    final box = await Hive.openBox(_prefsBox);
    return box.get('has_seen_onboarding', defaultValue: false) as bool;
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    final box = await Hive.openBox(_prefsBox);
    await box.put('has_seen_onboarding', value);
  }

  Future<bool> isDarkMode() async {
    final box = await Hive.openBox(_prefsBox);
    return box.get('is_dark_mode', defaultValue: false) as bool;
  }

  Future<void> setDarkMode(bool value) async {
    final box = await Hive.openBox(_prefsBox);
    await box.put('is_dark_mode', value);
  }

  // --- Cache ---

  Future<void> cacheData(String key, dynamic data) async {
    final box = await Hive.openBox(_cacheBox);
    await box.put(key, data);
  }

  Future<dynamic> getCachedData(String key) async {
    final box = await Hive.openBox(_cacheBox);
    return box.get(key);
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox(_cacheBox);
    await box.clear();
  }

  // --- Recent Searches ---

  Future<List<String>> getRecentSearches() async {
    final box = await Hive.openBox(_searchBox);
    final searches = box.get('searches', defaultValue: <String>[]);
    return List<String>.from(searches as List);
  }

  Future<void> addRecentSearch(String query) async {
    final box = await Hive.openBox(_searchBox);
    final searches = List<String>.from(
      (box.get('searches', defaultValue: <String>[]) as List),
    );
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 5) searches.removeLast();
    await box.put('searches', searches);
  }

  Future<void> removeRecentSearch(String query) async {
    final box = await Hive.openBox(_searchBox);
    final searches = List<String>.from(
      (box.get('searches', defaultValue: <String>[]) as List),
    );
    searches.remove(query);
    await box.put('searches', searches);
  }

  Future<void> clearRecentSearches() async {
    final box = await Hive.openBox(_searchBox);
    await box.put('searches', <String>[]);
  }
}
