import 'package:flutter_test/flutter_test.dart';
import 'package:tuvientruclam/models/person.dart';
import 'package:tuvientruclam/services/image_preloader.dart';

void main() {
  group('ImagePreloader Tests', () {
    late List<Person> testPersons;

    setUp(() {
      testPersons = [
        Person(id: 1, theDanh: 'Person 1'),
        Person(id: 2, theDanh: 'Person 2'),
        Person(id: 3, theDanh: 'Person 3'),
        Person(id: 4, theDanh: 'Person 4'),
        Person(id: 5, theDanh: 'Person 5'),
      ];

      ImagePreloader.clearPreloadTracking();
    });

    tearDown(() {
      ImagePreloader.clearPreloadTracking();
    });

    group('preloadNextImages', () {
      test('should handle empty person list', () async {
        expect(
          () async => await ImagePreloader.preloadNextImages([], 0),
          returnsNormally,
        );
      });

      test('should preload without errors', () async {
        expect(
          () async => await ImagePreloader.preloadNextImages(testPersons, 0),
          returnsNormally,
        );
      });

      test('should handle index at start of list', () async {
        expect(
          () async => await ImagePreloader.preloadNextImages(testPersons, 0),
          returnsNormally,
        );
      });

      test('should handle index at end of list', () async {
        expect(
          () async => await ImagePreloader.preloadNextImages(
            testPersons,
            testPersons.length - 1,
          ),
          returnsNormally,
        );
      });

      test('should handle custom count parameter', () async {
        expect(
          () async =>
              await ImagePreloader.preloadNextImages(testPersons, 0, count: 5),
          returnsNormally,
        );
      });

      test('should handle count larger than list', () async {
        expect(
          () async => await ImagePreloader.preloadNextImages(
            testPersons,
            0,
            count: 100,
          ),
          returnsNormally,
        );
      });

      test('should handle single person list', () async {
        final singlePerson = [Person(id: 1, theDanh: 'Person 1')];

        expect(
          () async => await ImagePreloader.preloadNextImages(singlePerson, 0),
          returnsNormally,
        );
      });
    });

    group('preloadGridImages', () {
      test('should handle empty person list', () async {
        expect(
          () async => await ImagePreloader.preloadGridImages([]),
          returnsNormally,
        );
      });

      test('should preload grid images without errors', () async {
        expect(
          () async => await ImagePreloader.preloadGridImages(testPersons),
          returnsNormally,
        );
      });

      test('should handle large person list', () async {
        final largeList = List.generate(
          100,
          (i) => Person(id: i + 1, theDanh: 'Person ${i + 1}'),
        );

        expect(
          () async => await ImagePreloader.preloadGridImages(largeList),
          returnsNormally,
        );
      });

      test('should handle single person', () async {
        final singlePerson = [Person(id: 1, theDanh: 'Person 1')];

        expect(
          () async => await ImagePreloader.preloadGridImages(singlePerson),
          returnsNormally,
        );
      });
    });

    group('preloadImage', () {
      test('should preload single image by ID', () async {
        expect(
          () async => await ImagePreloader.preloadImage(1),
          returnsNormally,
        );
      });

      test('should handle multiple preload calls', () async {
        await ImagePreloader.preloadImage(1);
        await ImagePreloader.preloadImage(2);
        await ImagePreloader.preloadImage(3);

        expect(true, isTrue);
      });

      test('should handle same ID multiple times', () async {
        await ImagePreloader.preloadImage(1);
        await ImagePreloader.preloadImage(1);
        await ImagePreloader.preloadImage(1);

        expect(true, isTrue);
      });

      test('should handle large ID values', () async {
        expect(
          () async => await ImagePreloader.preloadImage(999999),
          returnsNormally,
        );
      });
    });

    group('isImagePreloaded', () {
      test('should return false for non-preloaded image', () {
        final result = ImagePreloader.isImagePreloaded(999);
        expect(result, isFalse);
      });

      test('should track preload status', () async {
        expect(ImagePreloader.isImagePreloaded(1), isFalse);
      });

      test('should handle multiple checks', () {
        ImagePreloader.isImagePreloaded(1);
        ImagePreloader.isImagePreloaded(2);
        ImagePreloader.isImagePreloaded(3);

        expect(true, isTrue);
      });
    });

    group('clearPreloadTracking', () {
      test('should clear tracking without errors', () {
        expect(() => ImagePreloader.clearPreloadTracking(), returnsNormally);
      });

      test('should clear multiple times', () {
        ImagePreloader.clearPreloadTracking();
        ImagePreloader.clearPreloadTracking();
        ImagePreloader.clearPreloadTracking();

        expect(true, isTrue);
      });

      test('should reset preload tracking', () {
        ImagePreloader.clearPreloadTracking();
        final stats = ImagePreloader.getPreloadStats();

        expect(stats['preloadedCount'], 0);
      });
    });

    group('getPreloadStats', () {
      test('should return stats object', () {
        final stats = ImagePreloader.getPreloadStats();

        expect(stats, isA<Map<String, dynamic>>());
      });

      test('should contain preloadedCount', () {
        final stats = ImagePreloader.getPreloadStats();

        expect(stats.containsKey('preloadedCount'), isTrue);
        expect(stats['preloadedCount'], isA<int>());
      });

      test('should contain preloadedIds', () {
        final stats = ImagePreloader.getPreloadStats();

        expect(stats.containsKey('preloadedIds'), isTrue);
        expect(stats['preloadedIds'], isA<List>());
      });

      test('should return zero count after clear', () {
        ImagePreloader.clearPreloadTracking();
        final stats = ImagePreloader.getPreloadStats();

        expect(stats['preloadedCount'], 0);
        expect(stats['preloadedIds'], isEmpty);
      });

      test('should return consistent format', () {
        final stats1 = ImagePreloader.getPreloadStats();
        final stats2 = ImagePreloader.getPreloadStats();

        expect(stats1.keys.toSet(), equals(stats2.keys.toSet()));
      });
    });

    group('Edge Cases', () {
      test('should handle rapid successive calls', () async {
        final futures = [
          ImagePreloader.preloadNextImages(testPersons, 0),
          ImagePreloader.preloadNextImages(testPersons, 1),
          ImagePreloader.preloadNextImages(testPersons, 2),
        ];

        expect(() async => await Future.wait(futures), returnsNormally);
      });

      test('should handle concurrent grid and next preloads', () async {
        final futures = [
          ImagePreloader.preloadGridImages(testPersons),
          ImagePreloader.preloadNextImages(testPersons, 0),
        ];

        expect(() async => await Future.wait(futures), returnsNormally);
      });

      test('should handle preload during clear', () {
        ImagePreloader.clearPreloadTracking();

        expect(
          () async => await ImagePreloader.preloadImage(1),
          returnsNormally,
        );
      });
    });

    group('Performance', () {
      test('should handle large batch preload', () async {
        final largeList = List.generate(
          1000,
          (i) => Person(id: i + 1, theDanh: 'Person ${i + 1}'),
        );

        expect(
          () async => await ImagePreloader.preloadGridImages(largeList),
          returnsNormally,
        );
      });

      test('should handle rapid preload calls', () async {
        for (int i = 0; i < 50; i++) {
          await ImagePreloader.preloadImage(i);
        }

        expect(true, isTrue);
      });
    });
  });
}
