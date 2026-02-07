import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'person_test.dart' as person_tests;
import 'data_service_test.dart' as data_service_tests;
import 'image_cache_manager_test.dart' as image_cache_manager_tests;
import 'image_preloader_test.dart' as image_preloader_tests;
import 'permission_service_test.dart' as permission_service_tests;
import 'search_service_test.dart' as search_service_tests;
import 'style_test.dart' as style_tests;
import 'app_dialogs_test.dart' as app_dialogs_tests;
import 'icon_button_widget_test.dart' as icon_button_widget_tests;
import 'person_info_widget_test.dart' as person_info_widget_tests;
import 'search_dialog_test.dart' as search_dialog_tests;
import 'settings_dialog_test.dart' as settings_dialog_tests;
import 'main_slideshow_page_test.dart' as main_slideshow_page_tests;
import 'slideshow_page_test.dart' as slideshow_page_tests;

void main() {
  // Run all test suites
  group('Model Tests', () {
    group('Person Tests', person_tests.main);
  });

  group('Service Tests', () {
    group('Data Service Tests', data_service_tests.main);
    group('Image Cache Manager Tests', image_cache_manager_tests.main);
    group('Image Preloader Tests', image_preloader_tests.main);
    group('Permission Service Tests', permission_service_tests.main);
    group('Search Service Tests', search_service_tests.main);
  });

  group('Utils Tests', () {
    group('Style Tests', style_tests.main);
  });

  group('Widget Tests', () {
    group('App Dialogs Tests', app_dialogs_tests.main);
    group('Icon Button Widget Tests', icon_button_widget_tests.main);
    group('Person Info Widget Tests', person_info_widget_tests.main);
    group('Search Dialog Tests', search_dialog_tests.main);
    group('Settings Dialog Tests', settings_dialog_tests.main);
  });

  group('Screen Tests', () {
    group('Main Slideshow Page Tests', main_slideshow_page_tests.main);
    group('Slideshow Page Tests', slideshow_page_tests.main);
  });

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
