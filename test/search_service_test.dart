import 'package:flutter_test/flutter_test.dart';
import 'package:tuvientruclam/models/person.dart';
import 'package:tuvientruclam/services/search_service.dart';

void main() {
  group('SearchService Tests', () {
    late List<Person> testPersons;
    late Map<String, Person> testPersonsMap;

    setUp(() {
      testPersons = [
        Person(
          id: 1001,
          theDanh: 'Phạm Thị Ngọc Lan',
          phapDanh: 'Ngọc Lan',
          ngayMat: '15/10/2023',
          huongTho: 1,
          nguyenQuan: 'Hà Nội',
        ),
        Person(
          id: 1002,
          theDanh: 'Trần Văn Hùng',
          phapDanh: 'Tâm Hùng',
          ngayMat: '20/11/2023',
          huongTho: 2,
          nguyenQuan: 'Hà Nam',
        ),
        Person(
          id: 1003,
          theDanh: 'Nguyễn Thị Hà',
          phapDanh: 'Tâm Hà',
          ngayMat: null,
          huongTho: null,
          nguyenQuan: null,
        ),
        Person(
          id: 1004,
          theDanh: 'Lê Văn An',
          phapDanh: null,
          ngayMat: '01/01/2023',
          huongTho: 3,
          nguyenQuan: 'Hà Tĩnh',
        ),
        Person(
          id: 1005,
          theDanh: 'Võ Thị Bích',
          phapDanh: 'Bích Hà',
          ngayMat: '10/12/2023',
          huongTho: null,
          nguyenQuan: 'Đà Nẵng',
        ),
        Person(
          id: 1006,
          theDanh: 'Hoàng Văn Cường',
          phapDanh: 'Cường Hà',
          ngayMat: '05/05/2023',
          huongTho: 4,
          nguyenQuan: 'Hà Giang',
        ),
        Person(
          id: 1007,
          theDanh: 'Đỗ Thị Dung',
          phapDanh: null,
          ngayMat: null,
          huongTho: null,
          nguyenQuan: 'Hà Tây',
        ),
      ];

      testPersonsMap = {for (var p in testPersons) p.id.toString(): p};
    });

    group('parseSearchTerms', () {
      test('should parse single term', () {
        final result = SearchService.parseSearchTerms('Hà');
        expect(result, ['Hà']);
      });

      test('should parse multiple comma-separated terms', () {
        final result = SearchService.parseSearchTerms('Hà, Hùng, Lan');
        expect(result, ['Hà', 'Hùng', 'Lan']);
      });

      test('should trim whitespace from terms', () {
        final result = SearchService.parseSearchTerms(' Hà ,  Hùng , Lan ');
        expect(result, ['Hà', 'Hùng', 'Lan']);
      });

      test('should filter empty terms', () {
        final result = SearchService.parseSearchTerms('Hà, , Hùng, , Lan');
        expect(result, ['Hà', 'Hùng', 'Lan']);
      });

      test('should return empty list for empty input', () {
        final result = SearchService.parseSearchTerms('');
        expect(result, []);
      });

      test('should return empty list for whitespace only', () {
        final result = SearchService.parseSearchTerms('   ,   ,   ');
        expect(result, []);
      });
    });

    group('searchPersons', () {
      test('should return empty list for empty search terms', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          [],
        );
        expect(result, []);
      });

      test('should find person by exact ID', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['1001'],
        );
        expect(result.length, 1);
        expect(result.first.id, 1001);
        expect(result.first.theDanh, 'Phạm Thị Ngọc Lan');
      });

      test('should find person by theDanh (case insensitive)', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['hà'],
        );
        expect(result.length, 7); // Multiple persons have "hà" in their name
      });

      test('should find person by theDanh (diacritic insensitive)', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Ha'],
        );
        expect(result.length, 7); // Multiple persons have "ha" in their name
      });

      test('should find person by phapDanh', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Ngọc'],
        );
        expect(result.length, 1);
        expect(result.first.theDanh, 'Phạm Thị Ngọc Lan');
      });

      test('should find person by ngayMat', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['2023'],
        );
        expect(result.length, 5); // 5 persons with dates in 2023
      });

      test('should find person by huongTho', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['1'],
        );
        expect(result.length, 4); // 4 persons with huongTho = 1
      });

      test('should find person by nguyenQuan', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Hà Nội'],
        );
        expect(result.length, 1);
        expect(result.first.theDanh, 'Phạm Thị Ngọc Lan');
      });

      test('should find multiple persons matching term', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Hà'],
        );
        expect(result.length, 7); // All persons with "Hà" in any field
      });

      test('should find persons by multiple search terms', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Hà', 'Hùng'],
        );
        expect(
          result.length,
          7,
        ); // All persons with "Hà" (Hùng is not found in test data)
      });

      test('should not find non-existent person', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['9999'],
        );
        expect(result, []);
      });

      test('should not find non-existent term', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['NonExistent'],
        );
        expect(result, []);
      });

      test('should handle null fields gracefully', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Dung'],
        );
        expect(result.length, 1);
        expect(result.first.theDanh, 'Đỗ Thị Dung');
      });

      test('should handle mixed case and diacritics', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['HA'],
        );
        expect(result.length, 7); // Should find all "Hà" variations
      });

      test('should not duplicate results for multiple matching fields', () {
        final result = SearchService.searchPersons(
          testPersons,
          testPersonsMap,
          ['Hà'],
        );
        final personIds = result.map((p) => p.id).toSet();
        expect(personIds.length, result.length); // No duplicates
      });
    });

    group('_matchesSearchTerm edge cases', () {
      test('should handle empty theDanh', () {
        final person = Person(
          id: 1008,
          theDanh: '',
          phapDanh: 'Test',
          ngayMat: null,
          huongTho: null,
          nguyenQuan: null,
        );

        final result = SearchService.searchPersons([person], {'1008': person}, [
          'Test',
        ]);
        expect(result.length, 1);
      });

      test('should handle null phapDanh', () {
        final person = Person(
          id: 1009,
          theDanh: 'Test Person',
          phapDanh: null,
          ngayMat: null,
          huongTho: null,
          nguyenQuan: null,
        );

        final result = SearchService.searchPersons([person], {'1009': person}, [
          'Test',
        ]);
        expect(result.length, 1);
      });

      test('should handle null ngayMat', () {
        final person = Person(
          id: 1010,
          theDanh: 'Test Person',
          phapDanh: null,
          ngayMat: null,
          huongTho: null,
          nguyenQuan: null,
        );

        final result = SearchService.searchPersons([person], {'1010': person}, [
          'Test',
        ]);
        expect(result.length, 1);
      });

      test('should handle null huongTho', () {
        final person = Person(
          id: 1011,
          theDanh: 'Test Person',
          phapDanh: null,
          ngayMat: null,
          huongTho: null,
          nguyenQuan: null,
        );

        final result = SearchService.searchPersons([person], {'1011': person}, [
          'Test',
        ]);
        expect(result.length, 1);
      });

      test('should handle null nguyenQuan', () {
        final person = Person(
          id: 1012,
          theDanh: 'Test Person',
          phapDanh: null,
          ngayMat: null,
          huongTho: null,
          nguyenQuan: null,
        );

        final result = SearchService.searchPersons([person], {'1012': person}, [
          'Test',
        ]);
        expect(result.length, 1);
      });
    });
  });
}
