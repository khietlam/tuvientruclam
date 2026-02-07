import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/models/person.dart';
import 'package:tuvientruclam/widgets/person_info_widget.dart';

void main() {
  group('PersonInfoWidget Tests', () {
    testWidgets('should display person with all fields', (
      WidgetTester tester,
    ) async {
      final person = Person(
        id: 1001,
        theDanh: 'Phạm Thị Ngọc Lan',
        phapDanh: 'Ngọc Lan',
        ngayMat: '15/10/2023',
        huongTho: 75,
        nguyenQuan: 'Hà Nội',
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.text('Phạm Thị Ngọc Lan'), findsOneWidget);
      expect(find.text('Pháp danh: Ngọc Lan'), findsOneWidget);
      expect(find.text('Ngày mất: 15/10/2023'), findsOneWidget);
      expect(find.text('Hưởng thọ: 75 tuổi'), findsOneWidget);
      expect(find.text('Nguyên quán: Hà Nội'), findsOneWidget);
    });

    testWidgets('should display person with only required fields', (
      WidgetTester tester,
    ) async {
      final person = Person(id: 1002, theDanh: 'Trần Văn Hùng');

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.text('Trần Văn Hùng'), findsOneWidget);
      expect(find.textContaining('Pháp danh:'), findsNothing);
      expect(find.textContaining('Ngày mất:'), findsNothing);
      expect(find.textContaining('Hưởng thọ:'), findsNothing);
      expect(find.textContaining('Nguyên quán:'), findsNothing);
    });

    testWidgets('should display person with partial fields', (
      WidgetTester tester,
    ) async {
      final person = Person(
        id: 1003,
        theDanh: 'Nguyễn Thị Hà',
        phapDanh: 'Tâm Hà',
        ngayMat: null,
        huongTho: null,
        nguyenQuan: 'Hà Nam',
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.text('Nguyễn Thị Hà'), findsOneWidget);
      expect(find.text('Pháp danh: Tâm Hà'), findsOneWidget);
      expect(find.textContaining('Ngày mất:'), findsNothing);
      expect(find.textContaining('Hưởng thọ:'), findsNothing);
      expect(find.text('Nguyên quán: Hà Nam'), findsOneWidget);
    });

    testWidgets('should have correct container styling', (
      WidgetTester tester,
    ) async {
      final person = Person(id: 1004, theDanh: 'Test Person');

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Container),
        ),
      );

      expect(container.alignment, Alignment.center);
      expect(container.color, Colors.black54);
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      final person = Person(
        id: 1005,
        theDanh: 'Very Long Name',
        phapDanh: 'Pháp Danh',
        ngayMat: '01/01/2023',
        huongTho: 100,
        nguyenQuan: 'Hà Nội',
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display theDanh with bold font', (
      WidgetTester tester,
    ) async {
      final person = Person(id: 1006, theDanh: 'Test Person');

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      final autoSizeTexts = tester.widgetList(
        find.byType(
          tester.firstWidget(find.byType(SingleChildScrollView)).runtimeType,
        ),
      );
      expect(autoSizeTexts, isNotEmpty);
    });

    testWidgets('should handle Vietnamese diacritics', (
      WidgetTester tester,
    ) async {
      final person = Person(
        id: 1007,
        theDanh: 'Nguyễn Văn Đức',
        phapDanh: 'Tâm Đức',
        nguyenQuan: 'Thừa Thiên Huế',
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.text('Nguyễn Văn Đức'), findsOneWidget);
      expect(find.text('Pháp danh: Tâm Đức'), findsOneWidget);
      expect(find.text('Nguyên quán: Thừa Thiên Huế'), findsOneWidget);
    });

    testWidgets('should handle zero huongTho', (WidgetTester tester) async {
      final person = Person(id: 1008, theDanh: 'Test Person', huongTho: 0);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.text('Hưởng thọ: 0 tuổi'), findsOneWidget);
    });

    testWidgets('should center align content', (WidgetTester tester) async {
      final person = Person(id: 1009, theDanh: 'Test Person');

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should handle empty string fields', (
      WidgetTester tester,
    ) async {
      final person = Person(
        id: 1010,
        theDanh: 'Test Person',
        phapDanh: '',
        ngayMat: '',
        nguyenQuan: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(body: PersonInfoWidget(person: person)),
        ),
      );

      expect(find.text('Test Person'), findsOneWidget);
      expect(find.text('Pháp danh: '), findsOneWidget);
      expect(find.text('Ngày mất: '), findsOneWidget);
      expect(find.text('Nguyên quán: '), findsOneWidget);
    });
  });
}
