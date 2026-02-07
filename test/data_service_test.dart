import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuvientruclam/models/person.dart';
import 'package:tuvientruclam/services/data_service.dart';

void main() {
  group('DataService Tests', () {
    group('Static Properties', () {
      test('should initialize with null paths', () {
        DataService.imagePath = null;
        DataService.dataJsonPath = null;

        expect(DataService.imagePath, isNull);
        expect(DataService.dataJsonPath, isNull);
      });

      test('should allow setting imagePath', () {
        DataService.imagePath = '/test/path/images';
        expect(DataService.imagePath, '/test/path/images');

        DataService.imagePath = null;
      });

      test('should allow setting dataJsonPath', () {
        DataService.dataJsonPath = '/test/path/data.json';
        expect(DataService.dataJsonPath, '/test/path/data.json');

        DataService.dataJsonPath = null;
      });
    });

    group('JSON Parsing', () {
      test('should parse valid JSON data', () {
        final jsonString = json.encode([
          {
            'id': 1001,
            'theDanh': 'Phạm Thị Ngọc Lan',
            'phapDanh': 'Ngọc Lan',
            'ngayMat': '15/10/2023',
            'huongTho': 75,
            'nguyenQuan': 'Hà Nội',
          },
          {
            'id': 1002,
            'theDanh': 'Trần Văn Hùng',
            'phapDanh': 'Tâm Hùng',
            'ngayMat': '20/11/2023',
            'huongTho': 80,
            'nguyenQuan': 'Hà Nam',
          },
        ]);

        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons.length, 2);
        expect(persons[0].id, 1001);
        expect(persons[0].theDanh, 'Phạm Thị Ngọc Lan');
        expect(persons[1].id, 1002);
        expect(persons[1].theDanh, 'Trần Văn Hùng');
      });

      test('should parse empty JSON array', () {
        final jsonString = json.encode([]);
        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons, isEmpty);
      });

      test('should parse JSON with partial fields', () {
        final jsonString = json.encode([
          {
            'id': 1003,
            'theDanh': 'Nguyễn Thị Hà',
            'phapDanh': null,
            'ngayMat': null,
            'huongTho': null,
            'nguyenQuan': null,
          },
        ]);

        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons.length, 1);
        expect(persons[0].id, 1003);
        expect(persons[0].theDanh, 'Nguyễn Thị Hà');
        expect(persons[0].phapDanh, isNull);
      });

      test('should handle UTF-8 encoding', () {
        final jsonString = json.encode([
          {
            'id': 1004,
            'theDanh': 'Đỗ Thị Dung',
            'phapDanh': 'Tâm Dung',
            'nguyenQuan': 'Thừa Thiên Huế',
          },
        ]);

        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons[0].theDanh, 'Đỗ Thị Dung');
        expect(persons[0].phapDanh, 'Tâm Dung');
        expect(persons[0].nguyenQuan, 'Thừa Thiên Huế');
      });

      test('should handle large datasets', () {
        final largeList = List.generate(
          1000,
          (index) => {
            'id': index + 1,
            'theDanh': 'Person ${index + 1}',
            'phapDanh': 'Pháp Danh ${index + 1}',
          },
        );

        final jsonString = json.encode(largeList);
        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons.length, 1000);
        expect(persons.first.id, 1);
        expect(persons.last.id, 1000);
      });
    });

    group('Path Validation', () {
      test('should validate file path format', () {
        final validPaths = [
          '/storage/emulated/0/TuVienTrucLam/data.json',
          'C:/Users/Test/TuVienTrucLam/data.json',
          '/home/user/TuVienTrucLam/data.json',
        ];

        for (final path in validPaths) {
          final file = File(path);
          expect(file.path, equals(path));
        }
      });

      test('should validate directory path format', () {
        final validPaths = [
          '/storage/emulated/0/TuVienTrucLam/images',
          'C:/Users/Test/TuVienTrucLam/images',
          '/home/user/TuVienTrucLam/images',
        ];

        for (final path in validPaths) {
          final dir = Directory(path);
          expect(dir.path, equals(path));
        }
      });
    });

    group('Error Handling', () {
      test('should handle invalid JSON format', () {
        expect(
          () => json.decode('invalid json'),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle malformed JSON array', () {
        expect(
          () => json.decode('[{id: 1, theDanh: "test"}]'),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle missing required fields', () {
        final jsonString = json.encode([
          {'id': 1005},
        ]);

        expect(() {
          final list = json.decode(jsonString) as List;
          list.map((e) => Person.fromJson(e)).toList();
        }, throwsA(isA<TypeError>()));
      });
    });

    group('Data Integrity', () {
      test('should preserve all person data through serialization', () {
        final originalData = [
          {
            'id': 2001,
            'theDanh': 'Test Person 1',
            'phapDanh': 'Pháp Danh 1',
            'ngayMat': '01/01/2023',
            'huongTho': 75,
            'nguyenQuan': 'Hà Nội',
          },
        ];

        final jsonString = json.encode(originalData);
        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons[0].id, originalData[0]['id']);
        expect(persons[0].theDanh, originalData[0]['theDanh']);
        expect(persons[0].phapDanh, originalData[0]['phapDanh']);
        expect(persons[0].ngayMat, originalData[0]['ngayMat']);
        expect(persons[0].huongTho, originalData[0]['huongTho']);
        expect(persons[0].nguyenQuan, originalData[0]['nguyenQuan']);
      });

      test('should handle duplicate IDs', () {
        final jsonString = json.encode([
          {'id': 3001, 'theDanh': 'Person 1'},
          {'id': 3001, 'theDanh': 'Person 2'},
        ]);

        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons.length, 2);
        expect(persons[0].id, persons[1].id);
        expect(persons[0].theDanh, isNot(equals(persons[1].theDanh)));
      });
    });

    group('Special Characters', () {
      test('should handle special characters in strings', () {
        final jsonString = json.encode([
          {
            'id': 4001,
            'theDanh': 'Nguyễn Văn A (Cô)',
            'phapDanh': 'Tâm Đức & Tâm Hà',
            'nguyenQuan': 'Hà Nội, Việt Nam',
          },
        ]);

        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons[0].theDanh, contains('(Cô)'));
        expect(persons[0].phapDanh, contains('&'));
        expect(persons[0].nguyenQuan, contains(','));
      });

      test('should handle newlines and tabs in strings', () {
        final jsonString = json.encode([
          {'id': 4002, 'theDanh': 'Test\nPerson', 'phapDanh': 'Pháp\tDanh'},
        ]);

        final list = json.decode(jsonString) as List;
        final persons = list.map((e) => Person.fromJson(e)).toList();

        expect(persons[0].theDanh, contains('\n'));
        expect(persons[0].phapDanh, contains('\t'));
      });
    });
  });
}
