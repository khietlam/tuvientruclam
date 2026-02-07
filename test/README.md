# Test Coverage

This project includes comprehensive test coverage for all major components.

## Test Structure

### Model Tests
- **person_test.dart** - Tests for the Person model:
  - Constructor with all fields
  - Constructor with partial fields
  - JSON parsing (fromJson)
  - Edge cases (Vietnamese diacritics, long strings, special characters)
  - Null field handling

### Service Tests
- **data_service_test.dart** - Tests for the DataService class:
  - JSON parsing and data loading
  - Path validation
  - Error handling
  - UTF-8 encoding
  - Data integrity
  - Special characters handling

- **image_cache_manager_test.dart** - Tests for the ImageCacheManager:
  - Singleton pattern
  - Cache configuration
  - Cache statistics
  - Cache clearing
  - Image preloading
  - Error resilience
  - Path handling

- **image_preloader_test.dart** - Tests for the ImagePreloader service:
  - Preloading next images
  - Preloading grid images
  - Preload tracking
  - Statistics retrieval
  - Edge cases and performance

- **permission_service_test.dart** - Tests for the PermissionService:
  - Storage permission requests
  - Platform handling
  - Error resilience

- **search_service_test.dart** - Tests for the SearchService class:
  - Search term parsing
  - Person search by various fields (ID, name, dates, etc.)
  - Diacritic handling
  - Edge cases and error conditions

### Utils Tests
- **style_test.dart** - Tests for styling utilities:
  - Responsive text styles
  - Button styles (primary, cancel, success, error)
  - Style consistency
  - Responsive sizing

### Widget Tests
- **app_dialogs_test.dart** - Tests for reusable dialog components:
  - Loading dialogs
  - Success/error dialogs
  - Confirmation dialogs
  - Dialog styling consistency

- **icon_button_widget_test.dart** - Tests for the IconButtonWidget:
  - Rendering with required properties
  - Tap callbacks
  - Custom colors
  - Hero tags
  - Multiple taps

- **person_info_widget_test.dart** - Tests for the PersonInfoWidget:
  - Display with all fields
  - Display with partial fields
  - Container styling
  - Scrollability
  - Vietnamese diacritics
  - Edge cases

- **search_dialog_test.dart** - Tests for the SearchDialog widget:
  - UI rendering
  - User interactions
  - Search functionality
  - Error handling
  - Loading states

- **settings_dialog_test.dart** - Tests for the SettingsDialog widget:
  - Duration input validation
  - Data folder change functionality
  - Form validation
  - Cache management
  - Auto clear cache settings

### Screen Tests
- **main_slideshow_page_test.dart** - Tests for the main screen:
  - Widget creation
  - Loading states
  - Scaffold structure

- **slideshow_page_test.dart** - Tests for the slideshow functionality:
  - Widget creation with persons
  - Empty persons list handling
  - Scaffold structure

## Running Tests

### Install Dependencies
```bash
flutter pub get
```

### Generate Mock Files (if needed)
```bash
flutter packages pub run build_runner build
```

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/search_service_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Categories

### Unit Tests
- SearchService logic
- Utility functions
- Data parsing

### Widget Tests
- UI component rendering
- User interactions
- State management
- Navigation

### Integration Tests
- App startup
- Navigation flows
- Error handling

## Test Data

Tests use mock data including:
- Sample Person objects with various field combinations
- Edge cases (null values, empty strings)
- Large datasets for performance testing

## Best Practices Followed

1. **Descriptive Test Names** - Each test clearly describes what it's testing
2. **Arrange-Act-Assert** - Tests follow the AAA pattern
3. **Mock Dependencies** - External dependencies are mocked for isolation
4. **Edge Cases** - Tests cover both happy paths and error conditions
5. **UI Testing** - Widget tests verify both appearance and behavior
6. **Accessibility** - Tests verify proper widget hierarchy and semantics

## Coverage Goals

- **Lines**: >90%
- **Functions**: >95%
- **Branches**: >85%
- **Statements**: >90%

## Troubleshooting

### Tests Fail After Refactoring
If tests fail after code changes:
1. Check if mock files need regeneration: `flutter packages pub run build_runner build`
2. Verify test data matches new code structure
3. Update expected values in assertions

### Widget Tests Fail
1. Ensure proper MaterialApp wrapper
2. Check for proper async handling with `pumpAndSettle()`
3. Verify widget keys and finders are correct

### Integration Tests Fail
1. Check navigation routes are properly configured
2. Verify app initialization completes successfully
3. Ensure proper cleanup between tests
