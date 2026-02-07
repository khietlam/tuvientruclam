import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/models/person.dart';
import 'package:tuvientruclam/screens/slideshow_page.dart';

void main() {
  group('SlideshowPage Tests', () {
    late List<Person> testPersons;

    setUp(() {
      testPersons = [
        Person(id: 1, theDanh: 'Person 1', phapDanh: 'Pháp Danh 1'),
        Person(id: 2, theDanh: 'Person 2', phapDanh: 'Pháp Danh 2'),
      ];
    });

    testWidgets('should create SlideshowPage with persons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, widget) => ResponsiveBreakpoints.builder(
            child: widget!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: SlideshowPage(persons: testPersons),
        ),
      );

      expect(find.byType(SlideshowPage), findsOneWidget);
    });

    testWidgets('should show loading for empty persons list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, widget) => ResponsiveBreakpoints.builder(
            child: widget!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: const SlideshowPage(persons: []),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have Scaffold widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, widget) => ResponsiveBreakpoints.builder(
            child: widget!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: SlideshowPage(persons: testPersons),
        ),
      );

      await tester.pump();

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should accept persons list', (WidgetTester tester) async {
      final widget = SlideshowPage(persons: testPersons);

      expect(widget.persons, testPersons);
      expect(widget.persons.length, 2);
    });
  });
}
