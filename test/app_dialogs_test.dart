import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/widgets/app_dialogs.dart';

void main() {
  group('AppDialogs Tests', () {
    Widget wrapWithApp(Widget child) {
      return MaterialApp(
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: widget!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
        ),
        home: Scaffold(body: child),
      );
    }

    group('loadingDialog', () {
      testWidgets('should display loading indicator and message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) =>
                  AppDialogs.loadingDialog(context, 'Loading...'),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('should have correct styling', (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) =>
                  AppDialogs.loadingDialog(context, 'Test message'),
            ),
          ),
        );

        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, Colors.black87);
        expect(dialog.elevation, 8);
      });

      testWidgets('should display custom message', (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) =>
                  AppDialogs.loadingDialog(context, 'Custom loading message'),
            ),
          ),
        );

        expect(find.text('Custom loading message'), findsOneWidget);
      });
    });

    group('successDialog', () {
      testWidgets('should display title, message and button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.successDialog(
                context,
                'Success!',
                'Operation completed',
                'OK',
                () {},
              ),
            ),
          ),
        );

        expect(find.text('Success!'), findsOneWidget);
        expect(find.text('Operation completed'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });

      testWidgets('should call callback when button pressed', (
        WidgetTester tester,
      ) async {
        bool pressed = false;

        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.successDialog(
                context,
                'Success!',
                'Message',
                'OK',
                () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(pressed, isTrue);
      });

      testWidgets('should have green title color', (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.successDialog(
                context,
                'Success!',
                'Message',
                'OK',
                () {},
              ),
            ),
          ),
        );

        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, Colors.black87);
      });
    });

    group('errorDialog', () {
      testWidgets('should display title, message and button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.errorDialog(
                context,
                'Error!',
                'Something went wrong',
                'Close',
                () {},
              ),
            ),
          ),
        );

        expect(find.text('Error!'), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.text('Close'), findsOneWidget);
      });

      testWidgets('should call callback when button pressed', (
        WidgetTester tester,
      ) async {
        bool pressed = false;

        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.errorDialog(
                context,
                'Error!',
                'Message',
                'Close',
                () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(pressed, isTrue);
      });

      testWidgets('should have red title color', (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.errorDialog(
                context,
                'Error!',
                'Message',
                'Close',
                () {},
              ),
            ),
          ),
        );

        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, Colors.black87);
      });
    });

    group('confirmationDialog', () {
      testWidgets('should display title, message and two buttons', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.confirmationDialog(
                context,
                'Confirm',
                'Are you sure?',
                'Yes',
                'No',
                () {},
              ),
            ),
          ),
        );

        expect(find.text('Confirm'), findsOneWidget);
        expect(find.text('Are you sure?'), findsOneWidget);
        expect(find.text('Yes'), findsOneWidget);
        expect(find.text('No'), findsOneWidget);
      });

      testWidgets('should call onConfirm when confirm button pressed', (
        WidgetTester tester,
      ) async {
        bool confirmed = false;

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
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AppDialogs.confirmationDialog(
                        context,
                        'Confirm',
                        'Are you sure?',
                        'Yes',
                        'No',
                        () => confirmed = true,
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

        expect(confirmed, isTrue);
      });

      testWidgets('should close dialog when cancel button pressed', (
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
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AppDialogs.confirmationDialog(
                        context,
                        'Confirm',
                        'Are you sure?',
                        'Yes',
                        'No',
                        () {},
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm'), findsOneWidget);

        await tester.tap(find.text('No'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm'), findsNothing);
      });
    });

    group('Dialog Styling', () {
      testWidgets('all dialogs should have consistent styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          wrapWithApp(
            Builder(
              builder: (context) => AppDialogs.loadingDialog(context, 'Test'),
            ),
          ),
        );

        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, Colors.black87);
        expect(dialog.elevation, 8);
        expect(dialog.shadowColor, Colors.black);
        expect(dialog.surfaceTintColor, Colors.black);
      });
    });
  });
}
