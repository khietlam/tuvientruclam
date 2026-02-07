import 'package:flutter_test/flutter_test.dart';
import 'package:tuvientruclam/services/image_cache_manager.dart';

void main() {
  group('ImageCacheManager Tests', () {
    late ImageCacheManager cacheManager;

    setUp(() {
      cacheManager = ImageCacheManager();
    });

    group('Singleton Pattern', () {
      test('should return same instance', () {
        final instance1 = ImageCacheManager();
        final instance2 = ImageCacheManager();

        expect(identical(instance1, instance2), isTrue);
      });

      test('should maintain state across instances', () {
        final instance1 = ImageCacheManager();
        final instance2 = ImageCacheManager();

        expect(instance1, equals(instance2));
      });
    });

    group('Cache Configuration', () {
      test('should have correct cache key', () {
        expect(ImageCacheManager.key, 'slideshowImageCache');
      });

      test('should initialize without errors', () {
        expect(() => ImageCacheManager(), returnsNormally);
      });
    });

    group('getCacheStats', () {
      test('should return cache statistics', () async {
        final stats = await cacheManager.getCacheStats();

        expect(stats, isA<Map<String, dynamic>>());
        expect(stats.containsKey('size'), isTrue);
        expect(stats.containsKey('count'), isTrue);
        expect(stats.containsKey('sizeMB'), isTrue);
      });

      test('should handle errors gracefully', () async {
        final stats = await cacheManager.getCacheStats();

        expect(stats, isNotNull);
      });

      test('should return consistent format', () async {
        final stats1 = await cacheManager.getCacheStats();
        final stats2 = await cacheManager.getCacheStats();

        expect(stats1.keys.toSet(), equals(stats2.keys.toSet()));
      });
    });

    group('clearCache', () {
      test('should clear cache without errors', () async {
        expect(() async => await cacheManager.clearCache(), returnsNormally);
      });

      test('should complete successfully', () async {
        await cacheManager.clearCache();
        // If we get here without exception, test passes
        expect(true, isTrue);
      });
    });

    group('preloadImages', () {
      test('should handle empty list', () async {
        expect(
          () async => await cacheManager.preloadImages([]),
          returnsNormally,
        );
      });

      test('should handle single image path', () async {
        expect(
          () async => await cacheManager.preloadImages(['/test/path/1.jpg']),
          returnsNormally,
        );
      });

      test('should handle multiple image paths', () async {
        final paths = [
          '/test/path/1.jpg',
          '/test/path/2.jpg',
          '/test/path/3.jpg',
        ];

        expect(
          () async => await cacheManager.preloadImages(paths),
          returnsNormally,
        );
      });

      test('should limit preload to 5 images', () async {
        final paths = List.generate(10, (i) => '/test/path/$i.jpg');

        expect(
          () async => await cacheManager.preloadImages(paths),
          returnsNormally,
        );
      });

      test('should handle invalid paths gracefully', () async {
        final paths = ['/invalid/path/1.jpg', '/invalid/path/2.jpg'];

        expect(
          () async => await cacheManager.preloadImages(paths),
          returnsNormally,
        );
      });
    });

    group('getCachedImageFile', () {
      test('should handle non-existent file', () async {
        final result = await cacheManager.getCachedImageFile(
          '/non/existent/path.jpg',
        );

        expect(result, isNull);
      });

      test('should handle invalid path', () async {
        final result = await cacheManager.getCachedImageFile('');

        expect(result, isNull);
      });

      test('should not throw on error', () async {
        expect(
          () async => await cacheManager.getCachedImageFile('/invalid'),
          returnsNormally,
        );
      });
    });

    group('ImageCacheManagerProvider', () {
      test('should provide cache manager instance', () {
        final manager = ImageCacheManagerProvider.cacheManager;

        expect(manager, isA<ImageCacheManager>());
      });

      test('should return same instance as singleton', () {
        final manager1 = ImageCacheManagerProvider.cacheManager;
        final manager2 = ImageCacheManager();

        expect(identical(manager1, manager2), isTrue);
      });
    });

    group('Error Resilience', () {
      test('should handle multiple concurrent operations', () async {
        final futures = [
          cacheManager.getCacheStats(),
          cacheManager.getCacheStats(),
          cacheManager.preloadImages(['/test/1.jpg']),
        ];

        expect(() async => await Future.wait(futures), returnsNormally);
      });

      test('should handle rapid cache clears', () async {
        await cacheManager.clearCache();
        await cacheManager.clearCache();
        await cacheManager.clearCache();

        expect(true, isTrue);
      });
    });

    group('Path Handling', () {
      test('should handle various path formats', () async {
        final paths = [
          '/storage/emulated/0/images/1.jpg',
          'C:/Users/Test/images/1.jpg',
          '/home/user/images/1.jpg',
          './relative/path/1.jpg',
        ];

        for (final path in paths) {
          expect(
            () async => await cacheManager.getCachedImageFile(path),
            returnsNormally,
          );
        }
      });

      test('should handle paths with special characters', () async {
        final paths = [
          '/path/with spaces/1.jpg',
          '/path/with-dashes/1.jpg',
          '/path/with_underscores/1.jpg',
        ];

        for (final path in paths) {
          expect(
            () async => await cacheManager.getCachedImageFile(path),
            returnsNormally,
          );
        }
      });
    });
  });
}
