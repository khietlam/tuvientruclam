import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuvientruclam/widgets/icon_button_widget.dart';

void main() {
  group('IconButtonWidget Tests', () {
    testWidgets('should render with required properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () {}),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should call onTap when pressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(
              icon: Icons.search,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('should use custom icon color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(
              icon: Icons.search,
              onTap: () {},
              iconColor: Colors.red,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.search));
      expect(icon.color, Colors.red);
    });

    testWidgets('should use default white icon color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () {}),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.search));
      expect(icon.color, Colors.white);
    });

    testWidgets('should use custom background color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(
              icon: Icons.search,
              onTap: () {},
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.backgroundColor, Colors.blue);
    });

    testWidgets('should use default black54 background color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () {}),
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.backgroundColor, Colors.black54);
    });

    testWidgets('should use heroTag when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(
              icon: Icons.search,
              onTap: () {},
              heroTag: 'test_hero',
            ),
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.heroTag, 'test_hero');
    });

    testWidgets('should be mini sized', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () {}),
          ),
        ),
      );

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.mini, isTrue);
    });

    testWidgets('should have bottom padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () {}),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find
            .ancestor(
              of: find.byType(FloatingActionButton),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, const EdgeInsets.only(bottom: 12));
    });

    testWidgets('should render different icons', (WidgetTester tester) async {
      final icons = [
        Icons.search,
        Icons.settings,
        Icons.home,
        Icons.play_arrow,
        Icons.pause,
      ];

      for (final icon in icons) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IconButtonWidget(icon: icon, onTap: () {}),
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget);
      }
    });

    testWidgets('should handle multiple taps', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () => tapCount++),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(tapCount, 3);
    });

    testWidgets('should work with all color combinations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                IconButtonWidget(
                  icon: Icons.search,
                  onTap: () {},
                  iconColor: Colors.white,
                  backgroundColor: Colors.black,
                  heroTag: 'button1',
                ),
                IconButtonWidget(
                  icon: Icons.settings,
                  onTap: () {},
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  heroTag: 'button2',
                ),
                IconButtonWidget(
                  icon: Icons.home,
                  onTap: () {},
                  iconColor: Colors.red,
                  backgroundColor: Colors.blue,
                  heroTag: 'button3',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsNWidgets(3));
    });

    testWidgets('should maintain state during rebuild', (
      WidgetTester tester,
    ) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () => tapCount++),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(tapCount, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWidget(icon: Icons.search, onTap: () => tapCount++),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(tapCount, 2);
    });
  });
}
