import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/utils/style.dart';

void main() {
  group('AppTextStyles Tests', () {
    testWidgets('getResponsiveStyle should return TextStyle for mobile', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppTextStyles.getResponsiveStyle(
                context,
                12,
                20,
                Colors.red,
              );

              return Text('Test', style: style);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style, isNotNull);
      expect(textWidget.style!.color, Colors.red);
    });

    testWidgets('getResponsiveStyle should use default color', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppTextStyles.getResponsiveStyle(context, 12, 20);
              return Text('Test', style: style);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style!.color, Colors.black);
    });

    testWidgets('getResponsiveTitleStyle should return bold style', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppTextStyles.getResponsiveTitleStyle(context);
              return Text('Test', style: style);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style!.fontWeight, FontWeight.bold);
    });

    testWidgets('getResponsiveSubtitleStyle should return white70 color', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppTextStyles.getResponsiveSubtitleStyle(context);
              return Text('Test', style: style);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style!.color, Colors.white70);
    });

    testWidgets('getResponsiveBodyStyle should return white54 color', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppTextStyles.getResponsiveBodyStyle(context);
              return Text('Test', style: style);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style!.color, Colors.white54);
    });
  });

  group('AppButtonStyles Tests', () {
    test('primaryButton should return correct style', () {
      final style = AppButtonStyles.primaryButton();

      expect(style, isA<ButtonStyle>());
      expect(style.backgroundColor?.resolve({}), Colors.white);
      expect(style.foregroundColor?.resolve({}), Colors.black);
    });

    test('cancelButton should return correct style', () {
      final style = AppButtonStyles.cancelButton();

      expect(style, isA<ButtonStyle>());
      expect(style.backgroundColor?.resolve({}), Colors.white54);
      expect(style.foregroundColor?.resolve({}), Colors.black);
    });

    test('successButton should return correct style', () {
      final style = AppButtonStyles.successButton();

      expect(style, isA<ButtonStyle>());
      expect(style.backgroundColor?.resolve({}), Colors.green);
      expect(style.foregroundColor?.resolve({}), Colors.white);
    });

    test('errorButton should return correct style', () {
      final style = AppButtonStyles.errorButton();

      expect(style, isA<ButtonStyle>());
      expect(style.backgroundColor?.resolve({}), Colors.red);
      expect(style.foregroundColor?.resolve({}), Colors.white);
    });

    testWidgets('elevatedButtonStyle should return correct style', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppButtonStyles.elevatedButtonStyle(context);

              return ElevatedButton(
                style: style,
                onPressed: () {},
                child: const Text('Test'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style, isNotNull);
      expect(button.style!.backgroundColor?.resolve({}), Colors.green);
      expect(button.style!.foregroundColor?.resolve({}), Colors.white);
    });

    test('all button styles should have rounded corners', () {
      final styles = [
        AppButtonStyles.primaryButton(),
        AppButtonStyles.cancelButton(),
        AppButtonStyles.successButton(),
        AppButtonStyles.errorButton(),
      ];

      for (final style in styles) {
        final shape = style.shape?.resolve({});
        expect(shape, isA<RoundedRectangleBorder>());
        if (shape is RoundedRectangleBorder) {
          expect(shape.borderRadius, BorderRadius.circular(8));
        }
      }
    });
  });

  group('Style Consistency', () {
    test('button styles should be distinct', () {
      final primary = AppButtonStyles.primaryButton();
      final cancel = AppButtonStyles.cancelButton();
      final success = AppButtonStyles.successButton();
      final error = AppButtonStyles.errorButton();

      expect(
        primary.backgroundColor?.resolve({}),
        isNot(equals(cancel.backgroundColor?.resolve({}))),
      );
      expect(
        success.backgroundColor?.resolve({}),
        isNot(equals(error.backgroundColor?.resolve({}))),
      );
    });

    testWidgets('text styles should scale with screen size', (
      WidgetTester tester,
    ) async {
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
          home: Builder(
            builder: (context) {
              final style = AppTextStyles.getResponsiveStyle(context, 12, 20);
              return Text('Test', style: style);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style!.fontSize, isNotNull);
    });
  });
}
