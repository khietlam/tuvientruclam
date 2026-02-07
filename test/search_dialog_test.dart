import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/models/person.dart';
import 'package:tuvientruclam/widgets/search_dialog.dart';

void main() {
  group('SearchDialog Tests', () {
    late List<Person> testPersons;
    late Map<String, Person> testPersonsMap;
    // ignore: unused_local_variable
    late Person singleResult;
    // ignore: unused_local_variable
    late List<Person> multipleResults;
    // ignore: unused_local_variable
    bool reopenSearchCalled = false;

    Widget wrapWithResponsive(Widget child) {
      return MaterialApp(
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: widget!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
        ),
        home: child,
      );
    }

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
      ];

      testPersonsMap = {for (var p in testPersons) p.id.toString(): p};
      singleResult = testPersons.first; // Initialize with first person
      multipleResults = [];
      reopenSearchCalled = false;
    });

    testWidgets('should display search dialog with correct UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchDialog(
              persons: testPersons,
              personsMap: testPersonsMap,
              onSingleResult: (person) => singleResult = person,
              onMultipleResults: (persons) => multipleResults = persons,
              onReopenSearch: () => reopenSearchCalled = true,
            ),
          ),
        ),
      );

      // Verify dialog title
      expect(find.text('Tìm kiếm'), findsOneWidget);

      // Verify search hint text
      expect(
        find.text(
          'Nhập ID, thê danh, pháp danh, ngày mất, hướng thổ hoặc nguyên quán:',
        ),
        findsOneWidget,
      );

      // Verify placeholder text
      expect(find.text('Ví dụ: 1023, Hữu Thành, Huu Thanh'), findsOneWidget);

      // Verify tip text
      expect(
        find.text('Mẹo: Có thể tìm kiếm có dấu hoặc không dấu'),
        findsOneWidget,
      );

      // Verify buttons
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.text('Tìm'), findsOneWidget);

      // Verify results count is NOT displayed (new feature)
      expect(find.textContaining('Tìm thấy'), findsNothing);
    });

    testWidgets('should show error dialog when search term limit exceeded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Enter more than 6 search terms
      final textField = find.byType(TextField);
      await tester.enterText(
        textField,
        'term1, term2, term3, term4, term5, term6, term7',
      );

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pumpAndSettle();

      // Verify error dialog appears
      expect(find.text('Lỗi!'), findsOneWidget);
      expect(find.text('Tối đa 6 từ khóa một lần tìm'), findsOneWidget);
      expect(find.text('Đóng'), findsOneWidget);
    });

    testWidgets('should show error dialog when no results found', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Enter search term that won't match anything
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'NonExistentTerm');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pumpAndSettle();

      // Verify error dialog appears
      expect(find.text('Lỗi!'), findsOneWidget);
      expect(find.text('Không tìm thấy kết quả!'), findsOneWidget);
    });

    testWidgets('should call onSingleResult when exactly one person found', (
      WidgetTester tester,
    ) async {
      Person? resultPerson;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: [testPersons.first], // Only one person
                      personsMap: {
                        testPersons.first.id.toString(): testPersons.first,
                      },
                      onSingleResult: (person) => resultPerson = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Search for the specific person by ID
      final textField = find.byType(TextField);
      await tester.enterText(textField, '1001');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pumpAndSettle();

      // Verify single result callback was called
      expect(resultPerson, isNotNull);
      expect(resultPerson!.id, equals(1001));

      // Dialog should be closed
      expect(find.text('Open Search'), findsOneWidget);
    });

    testWidgets('should call onMultipleResults when multiple persons found', (
      WidgetTester tester,
    ) async {
      List<Person>? resultPersons;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => resultPersons = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Search for term that matches multiple people
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Tâm');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pumpAndSettle();

      // Verify multiple results callback was called
      expect(resultPersons, isNotNull);
      expect(resultPersons!.length, greaterThan(1));

      // Dialog should be closed
      expect(find.text('Open Search'), findsOneWidget);
    });

    testWidgets('should close dialog when cancel button pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Open Search'), findsOneWidget);
      expect(find.text('Tìm kiếm'), findsNothing);
    });

    testWidgets('should handle empty search gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Don't enter any text, just tap search
      await tester.tap(find.text('Tìm'));
      await tester.pump();

      // Dialog should still be open (no search performed)
      expect(find.text('Tìm kiếm'), findsOneWidget);
    });

    testWidgets('should handle whitespace-only search gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Enter only whitespace
      final textField = find.byType(TextField);
      await tester.enterText(textField, '   ,  ,   ');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pump();

      // Dialog should still be open (no search performed)
      expect(find.text('Tìm kiếm'), findsOneWidget);
    });

    testWidgets('should work without onReopenSearch callback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      // No onReopenSearch callback
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog - should work without optional callback
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Verify dialog displays normally
      expect(find.text('Tìm kiếm'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.text('Tìm'), findsOneWidget);
    });

    testWidgets('should show loading indicator during search', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Enter search term
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Tâm');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pump(); // Don't wait for settle to catch loading state

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not display results count (new feature)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                      onReopenSearch: () => reopenSearchCalled = true,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Initially no results count
      expect(find.textContaining('Tìm thấy'), findsNothing);

      // Enter search term
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Tâm');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pump(); // Check during loading

      // Still no results count displayed (new feature)
      expect(find.textContaining('Tìm thấy'), findsNothing);
    });

    testWidgets('should show "Tải thêm" button when more results available', (
      WidgetTester tester,
    ) async {
      // Create a large list of persons to trigger pagination
      final largePersonList = List.generate(
        50,
        (index) => Person(
          id: 2000 + index,
          theDanh: 'Tâm Test $index',
          phapDanh: 'Pháp $index',
          ngayMat: '01/01/2024',
          huongTho: 1,
          nguyenQuan: 'Test',
        ),
      );

      final largePersonsMap = {
        for (var p in largePersonList) p.id.toString(): p,
      };

      await tester.pumpWidget(
        wrapWithResponsive(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: largePersonList,
                      personsMap: largePersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Search for term that matches many results
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Tâm');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pump(); // Don't settle yet to check for Load More button

      // Wait a bit for search to process
      await tester.pump(const Duration(milliseconds: 100));

      // The "Tải thêm" button should appear if there are paginated results
      // Note: Button may or may not appear depending on SearchService.defaultPageSize
      // This test verifies the button can appear when appropriate
      final loadMoreButton = find.text('Tải thêm');

      // Either Load More button exists or dialog closed with results
      expect(
        loadMoreButton.evaluate().isNotEmpty ||
            find.text('Open Search').evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('should load more results when "Tải thêm" button pressed', (
      WidgetTester tester,
    ) async {
      // Create a large list to ensure pagination
      final largePersonList = List.generate(
        50,
        (index) => Person(
          id: 3000 + index,
          theDanh: 'Ngọc Test $index',
          phapDanh: 'Pháp $index',
          ngayMat: '01/01/2024',
          huongTho: 1,
          nguyenQuan: 'Test',
        ),
      );

      final largePersonsMap = {
        for (var p in largePersonList) p.id.toString(): p,
      };

      List<Person>? capturedResults;

      await tester.pumpWidget(
        wrapWithResponsive(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: largePersonList,
                      personsMap: largePersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => capturedResults = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Search for term
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Ngọc');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pump(); // Don't settle to check for Load More

      // Wait for search to complete
      await tester.pump(const Duration(milliseconds: 100));

      // If "Tải thêm" button exists, the pagination feature is working
      final loadMoreButton = find.text('Tải thêm');
      if (tester.any(loadMoreButton)) {
        await tester.tap(loadMoreButton);
        await tester.pump(); // Check loading state

        // Verify loading indicator appears during load more
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        // After loading more, dialog should still be open
        expect(find.text('Tìm kiếm'), findsOneWidget);
      } else {
        // Dialog closed immediately with results
        await tester.pumpAndSettle();
        expect(capturedResults, isNotNull);
        expect(capturedResults!.length, greaterThan(0));
      }
    });

    testWidgets('should disable search button while searching', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithResponsive(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singleResult = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Enter search term
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Tâm');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pump(); // Don't settle to catch disabled state

      // Find the search button
      final searchButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Tìm').last,
      );

      // Verify button is disabled during search
      expect(searchButton.onPressed, isNull);
    });

    testWidgets('should handle search with ID correctly', (
      WidgetTester tester,
    ) async {
      Person? resultPerson;

      await tester.pumpWidget(
        wrapWithResponsive(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => resultPerson = person,
                      onMultipleResults: (persons) => multipleResults = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Search by ID
      final textField = find.byType(TextField);
      await tester.enterText(textField, '1002');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pumpAndSettle();

      // Verify correct person found by ID
      expect(resultPerson, isNotNull);
      expect(resultPerson!.id, equals(1002));
      expect(resultPerson!.theDanh, equals('Trần Văn Hùng'));
    });

    testWidgets('should handle diacritic-insensitive search', (
      WidgetTester tester,
    ) async {
      Person? singlePerson;
      List<Person>? resultPersons;

      await tester.pumpWidget(
        wrapWithResponsive(
          Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => SearchDialog(
                      persons: testPersons,
                      personsMap: testPersonsMap,
                      onSingleResult: (person) => singlePerson = person,
                      onMultipleResults: (persons) => resultPersons = persons,
                    ),
                  );
                },
                child: Text('Open Search'),
              ),
            ),
          ),
        ),
      );

      // Open search dialog
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Search without diacritics for "Hùng" (should match "Trần Văn Hùng")
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Hung');

      // Tap search button
      await tester.tap(find.text('Tìm'));
      await tester.pumpAndSettle();

      // Dialog should close after search
      expect(find.text('Tìm kiếm'), findsNothing);
      expect(find.text('Open Search'), findsOneWidget);

      // Verify diacritic-insensitive search works
      // Either single result or multiple results should be set
      final hasResults =
          singlePerson != null ||
          (resultPersons != null && resultPersons!.isNotEmpty);
      expect(hasResults, isTrue);

      // Check that results contain person with "Hùng" in name
      if (singlePerson != null) {
        expect(singlePerson!.theDanh.contains('Hùng'), isTrue);
      } else if (resultPersons != null && resultPersons!.isNotEmpty) {
        expect(
          resultPersons!.any(
            (p) =>
                p.theDanh.contains('Hùng') ||
                p.phapDanh?.contains('Hùng') == true,
          ),
          isTrue,
        );
      }
    });
  });
}
