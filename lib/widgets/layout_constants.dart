/// Layout constants for consistent spacing and sizing across the app
class LayoutConstants {
  // Grid view constants
  static const double gridPadding = 16.0;
  static const double gridSpacing = 8.0;
  static const int gridColumnCount = 2;
  static const int gridRowCount = 3;

  // Additional padding for controls and system UI
  static const double controlsHeight = 100.0;
  static const double systemUIPadding = 32.0;

  // Dialog constants
  static const double dialogWidthRatio = 0.9;
  static const double dialogHeightRatio = 0.8;
  static const double dialogBorderRadius = 16.0;
  static const double cardBorderRadius = 12.0;

  // Scrollbar constants
  static const double scrollbarThickness = 8.0;
  static const double scrollbarRadius = 4.0;
  static const int scrollbarVisibilityThreshold = 6;

  // Auto-hide controls timer
  static const Duration controlsHideDelay = Duration(seconds: 10);

  // Image animation
  static const Duration imageAnimationDuration = Duration(milliseconds: 300);

  // Private constructor to prevent instantiation
  LayoutConstants._();
}
