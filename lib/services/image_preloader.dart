import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/person.dart';
import '../services/data_service.dart';
import '../services/image_cache_manager.dart';

/// Service for preloading images to improve slideshow performance
class ImagePreloader {
  static final ImageCacheManager _cacheManager = ImageCacheManager();
  static final Set<int> _preloadedImages = <int>{};

  /// Preload next images in slideshow for smooth transitions
  static Future<void> preloadNextImages(
    List<Person> persons,
    int currentIndex, {
    int count = 3,
  }) async {
    if (persons.isEmpty) return;

    final List<String> imagePaths = [];

    // Preload next images
    for (int i = 1; i <= count; i++) {
      final nextIndex = (currentIndex + i) % persons.length;
      final imagePath = _getImagePath(persons[nextIndex].id);
      if (imagePath != null &&
          !_preloadedImages.contains(persons[nextIndex].id)) {
        imagePaths.add(imagePath);
        _preloadedImages.add(persons[nextIndex].id);
      }
    }

    // Preload previous image
    final prevIndex = (currentIndex - 1 + persons.length) % persons.length;
    final prevImagePath = _getImagePath(persons[prevIndex].id);
    if (prevImagePath != null &&
        !_preloadedImages.contains(persons[prevIndex].id)) {
      imagePaths.add(prevImagePath);
      _preloadedImages.add(persons[prevIndex].id);
    }

    if (imagePaths.isNotEmpty) {
      try {
        await _cacheManager.preloadImages(imagePaths);
        debugPrint('Preloaded ${imagePaths.length} images');
      } catch (e) {
        debugPrint('Preload error: $e');
      }
    }
  }

  /// Preload images for grid view
  static Future<void> preloadGridImages(List<Person> persons) async {
    if (persons.isEmpty) return;

    final List<String> imagePaths = [];

    // Limit grid preload to first 20 images to avoid memory issues
    for (final person in persons.take(20)) {
      final imagePath = _getImagePath(person.id);
      if (imagePath != null && !_preloadedImages.contains(person.id)) {
        imagePaths.add(imagePath);
        _preloadedImages.add(person.id);
      }
    }

    if (imagePaths.isNotEmpty) {
      try {
        await _cacheManager.preloadImages(imagePaths);
        debugPrint('Preloaded ${imagePaths.length} grid images');
      } catch (e) {
        debugPrint('Grid preload error: $e');
      }
    }
  }

  /// Clear preload tracking (call when changing data sources)
  static void clearPreloadTracking() {
    _preloadedImages.clear();
  }

  /// Get file path for image ID
  static String? _getImagePath(int id) {
    final jpg = File('${DataService.imagePath}/$id.jpg');
    final jpeg = File('${DataService.imagePath}/$id.jpeg');

    if (jpg.existsSync()) {
      return jpg.path;
    } else if (jpeg.existsSync()) {
      return jpeg.path;
    }
    return null;
  }

  /// Preload specific image by ID
  static Future<void> preloadImage(int id) async {
    final imagePath = _getImagePath(id);
    if (imagePath != null && !_preloadedImages.contains(id)) {
      try {
        await _cacheManager.preloadImages([imagePath]);
        _preloadedImages.add(id);
        debugPrint('Preloaded image $id');
      } catch (e) {
        debugPrint('Preload error for image $id: $e');
      }
    }
  }

  /// Check if image is preloaded
  static bool isImagePreloaded(int id) {
    return _preloadedImages.contains(id);
  }

  /// Get preload statistics
  static Map<String, dynamic> getPreloadStats() {
    return {
      'preloadedCount': _preloadedImages.length,
      'preloadedIds': _preloadedImages.toList(),
    };
  }
}
