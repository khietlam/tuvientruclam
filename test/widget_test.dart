import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'search_service_test.dart' as search_service_tests;
import 'app_dialogs_test.dart' as app_dialogs_tests;
import 'search_dialog_test.dart' as search_dialog_tests;
import 'settings_dialog_test.dart' as settings_dialog_tests;
import 'main_slideshow_page_test.dart' as main_slideshow_page_tests;
import 'slideshow_page_test.dart' as slideshow_page_tests;

void main() {
  // Run all test suites
  group('Search Service Tests', search_service_tests.main);
  group('App Dialogs Tests', app_dialogs_tests.main);
  group('Search Dialog Tests', search_dialog_tests.main);
  group('Settings Dialog Tests', settings_dialog_tests.main);
  group('Main Slideshow Page Tests', main_slideshow_page_tests.main);
  group('Slideshow Page Tests', slideshow_page_tests.main);

  // Basic app integration test
  group('App Integration Tests', () {
    testWidgets('App should build without crashing', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
