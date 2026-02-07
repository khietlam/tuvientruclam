import 'package:flutter_test/flutter_test.dart';
import 'package:tuvientruclam/models/person.dart';

void main() {
  group('Person Model Tests', () {
    group('Constructor', () {
      test('should create Person with all fields', () {
        final person = Person(
          id: 1001,
          theDanh: 'Phạm Thị Ngọc Lan',
          phapDanh: 'Ngọc Lan',
          ngayMat: '15/10/2023',
          huongTho: 75,
          nguyenQuan: 'Hà Nội',
        );

        expect(person.id, 1001);
        expect(person.theDanh, 'Phạm Thị Ngọc Lan');
        expect(person.phapDanh, 'Ngọc Lan');
        expect(person.ngayMat, '15/10/2023');
        expect(person.huongTho, 75);
        expect(person.nguyenQuan, 'Hà Nội');
      });

      test('should create Person with only required fields', () {
        final person = Person(id: 1002, theDanh: 'Trần Văn Hùng');

        expect(person.id, 1002);
        expect(person.theDanh, 'Trần Văn Hùng');
        expect(person.phapDanh, isNull);
        expect(person.ngayMat, isNull);
        expect(person.huongTho, isNull);
        expect(person.nguyenQuan, isNull);
      });

      test('should create Person with partial fields', () {
        final person = Person(
          id: 1003,
          theDanh: 'Nguyễn Thị Hà',
          phapDanh: 'Tâm Hà',
          ngayMat: null,
          huongTho: null,
          nguyenQuan: 'Hà Nam',
        );

        expect(person.id, 1003);
        expect(person.theDanh, 'Nguyễn Thị Hà');
        expect(person.phapDanh, 'Tâm Hà');
        expect(person.ngayMat, isNull);
        expect(person.huongTho, isNull);
        expect(person.nguyenQuan, 'Hà Nam');
      });
    });

    group('fromJson', () {
      test('should parse JSON with all fields', () {
        final json = {
          'id': 1001,
          'theDanh': 'Phạm Thị Ngọc Lan',
          'phapDanh': 'Ngọc Lan',
          'ngayMat': '15/10/2023',
          'huongTho': 75,
          'nguyenQuan': 'Hà Nội',
        };

        final person = Person.fromJson(json);

        expect(person.id, 1001);
        expect(person.theDanh, 'Phạm Thị Ngọc Lan');
        expect(person.phapDanh, 'Ngọc Lan');
        expect(person.ngayMat, '15/10/2023');
        expect(person.huongTho, 75);
        expect(person.nguyenQuan, 'Hà Nội');
      });

      test('should parse JSON with only required fields', () {
        final json = {'id': 1002, 'theDanh': 'Trần Văn Hùng'};

        final person = Person.fromJson(json);

        expect(person.id, 1002);
        expect(person.theDanh, 'Trần Văn Hùng');
        expect(person.phapDanh, isNull);
        expect(person.ngayMat, isNull);
        expect(person.huongTho, isNull);
        expect(person.nguyenQuan, isNull);
      });

      test('should parse JSON with null optional fields', () {
        final json = {
          'id': 1003,
          'theDanh': 'Nguyễn Thị Hà',
          'phapDanh': null,
          'ngayMat': null,
          'huongTho': null,
          'nguyenQuan': null,
        };

        final person = Person.fromJson(json);

        expect(person.id, 1003);
        expect(person.theDanh, 'Nguyễn Thị Hà');
        expect(person.phapDanh, isNull);
        expect(person.ngayMat, isNull);
        expect(person.huongTho, isNull);
        expect(person.nguyenQuan, isNull);
      });

      test('should parse JSON with partial fields', () {
        final json = {
          'id': 1004,
          'theDanh': 'Lê Văn An',
          'phapDanh': 'Tâm An',
          'ngayMat': '01/01/2023',
        };

        final person = Person.fromJson(json);

        expect(person.id, 1004);
        expect(person.theDanh, 'Lê Văn An');
        expect(person.phapDanh, 'Tâm An');
        expect(person.ngayMat, '01/01/2023');
        expect(person.huongTho, isNull);
        expect(person.nguyenQuan, isNull);
      });

      test('should handle integer ID', () {
        final json = {'id': 1005, 'theDanh': 'Test Person'};

        final person = Person.fromJson(json);
        expect(person.id, 1005);
      });

      test('should handle string theDanh with special characters', () {
        final json = {'id': 1006, 'theDanh': 'Đỗ Thị Dung (Cô)'};

        final person = Person.fromJson(json);
        expect(person.theDanh, 'Đỗ Thị Dung (Cô)');
      });

      test('should handle empty string fields', () {
        final json = {
          'id': 1007,
          'theDanh': 'Test Person',
          'phapDanh': '',
          'ngayMat': '',
          'nguyenQuan': '',
        };

        final person = Person.fromJson(json);
        expect(person.phapDanh, '');
        expect(person.ngayMat, '');
        expect(person.nguyenQuan, '');
      });

      test('should handle zero huongTho', () {
        final json = {'id': 1008, 'theDanh': 'Test Person', 'huongTho': 0};

        final person = Person.fromJson(json);
        expect(person.huongTho, 0);
      });

      test('should handle large huongTho values', () {
        final json = {'id': 1009, 'theDanh': 'Test Person', 'huongTho': 120};

        final person = Person.fromJson(json);
        expect(person.huongTho, 120);
      });
    });

    group('Edge Cases', () {
      test('should handle Vietnamese diacritics in all fields', () {
        final json = {
          'id': 2001,
          'theDanh': 'Nguyễn Văn Đức',
          'phapDanh': 'Tâm Đức',
          'ngayMat': '25/12/2023',
          'huongTho': 80,
          'nguyenQuan': 'Thừa Thiên Huế',
        };

        final person = Person.fromJson(json);
        expect(person.theDanh, 'Nguyễn Văn Đức');
        expect(person.phapDanh, 'Tâm Đức');
        expect(person.nguyenQuan, 'Thừa Thiên Huế');
      });

      test('should handle long strings', () {
        final json = {
          'id': 2002,
          'theDanh': 'A' * 100,
          'phapDanh': 'B' * 100,
          'nguyenQuan': 'C' * 100,
        };

        final person = Person.fromJson(json);
        expect(person.theDanh.length, 100);
        expect(person.phapDanh!.length, 100);
        expect(person.nguyenQuan!.length, 100);
      });

      test('should handle date formats', () {
        final json = {
          'id': 2003,
          'theDanh': 'Test Person',
          'ngayMat': '01/01/2023',
        };

        final person = Person.fromJson(json);
        expect(person.ngayMat, '01/01/2023');
      });
    });
  });
}
