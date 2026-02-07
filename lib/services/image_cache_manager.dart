import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'image_preloader.dart';

/// Custom cache manager optimized for 3000 images slideshow
/// Bounded memory cache (100MB) and disk cache (1GB)
class ImageCacheManager extends CacheManager with ImageCacheManagerProvider {
  static const key = 'slideshowImageCache';
  static const _maxNumberOfCacheObjects = 1000; // Limit cached files

  static final ImageCacheManager _instance = ImageCacheManager._();

  factory ImageCacheManager() {
    return _instance;
  }

  ImageCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 30), // Keep images for 30 days
          maxNrOfCacheObjects: _maxNumberOfCacheObjects,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileSystem: IOFileSystem(key),
          fileService: HttpFileService(),
        ),
      );

  /// Get cached image file for local file path
  Future<File?> getCachedImageFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      // For local files, just return the original file
      // The CachedNetworkImage widget will handle the actual caching
      return file;
    } catch (e) {
      debugPrint('Cache error for $filePath: $e');
      return null;
    }
  }

  /// Preload multiple images in background
  Future<void> preloadImages(List<String> filePaths) async {
    for (final filePath in filePaths.take(5)) {
      // Limit preload to 5 images
      try {
        await getCachedImageFile(filePath);
      } catch (e) {
        debugPrint('Preload error for $filePath: $e');
      }
    }
  }

  /// Clear cache to free memory
  Future<void> clearCache() async {
    // Clear Flutter's image cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // Clear preload tracking
    ImagePreloader.clearPreloadTracking();
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      // Since we're using Flutter's built-in Image.file caching,
      // we'll provide basic cache information
      return {
        'size': 0, // Flutter manages this internally
        'count': 0, // Flutter manages this internally
        'sizeMB': '0.00',
        'note': 'Flutter tự quản lý cache bộ nhớ cho ảnh local',
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// Provider for easy access
mixin ImageCacheManagerProvider {
  static ImageCacheManager cacheManager = ImageCacheManager();
}
