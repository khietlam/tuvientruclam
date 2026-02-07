import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'image_cache_manager.dart';

/// Cache frequency options
enum CacheFrequency { never, daily, weekly, monthly }

/// Service for managing cache configuration and auto-clear functionality
class CacheConfigService {
  static Timer? _autoClearCacheTimer;

  /// Setup auto-clear cache timer based on saved preferences
  static Future<void> initializeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final frequencyString =
        prefs.getString('autoClearCacheFrequency') ?? 'daily';
    setupAutoClearCache(frequencyString);
  }

  /// Setup auto-clear cache timer with specified frequency
  static void setupAutoClearCache(String frequencyString) {
    // Cancel existing timer
    _autoClearCacheTimer?.cancel();

    final frequency = _parseFrequency(frequencyString);
    final interval = _getDurationForFrequency(frequency);

    if (interval != null) {
      _autoClearCacheTimer = Timer.periodic(interval, (timer) {
        _clearImageCache();
      });
    }
  }

  /// Update auto-clear cache frequency and persist to preferences
  static Future<void> updateFrequency(String frequency) async {
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('autoClearCacheFrequency', frequency);

    // Update timer
    setupAutoClearCache(frequency);
  }

  /// Get current cache frequency from preferences
  static Future<String> getCurrentFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('autoClearCacheFrequency') ?? 'daily';
  }

  /// Parse frequency string to enum
  static CacheFrequency _parseFrequency(String frequencyString) {
    switch (frequencyString) {
      case 'never':
        return CacheFrequency.never;
      case 'daily':
        return CacheFrequency.daily;
      case 'weekly':
        return CacheFrequency.weekly;
      case 'monthly':
        return CacheFrequency.monthly;
      default:
        return CacheFrequency.daily;
    }
  }

  /// Get duration for cache frequency
  static Duration? _getDurationForFrequency(CacheFrequency frequency) {
    switch (frequency) {
      case CacheFrequency.never:
        return null;
      case CacheFrequency.daily:
        return const Duration(days: 1);
      case CacheFrequency.weekly:
        return const Duration(days: 7);
      case CacheFrequency.monthly:
        return const Duration(days: 30);
    }
  }

  /// Clear image cache safely
  static void _clearImageCache() {
    try {
      ImageCacheManager().clearCache();
    } catch (e) {
      // Silent fail - cache clearing shouldn't crash the app
    }
  }

  /// Cancel auto-clear timer (call on app dispose)
  static void dispose() {
    _autoClearCacheTimer?.cancel();
    _autoClearCacheTimer = null;
  }
}
