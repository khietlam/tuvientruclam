import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppTextStyles {
  static TextStyle getResponsiveStyle(
      BuildContext context,
      double mobileSize,
      double desktopSize, [
        Color? color,
      ]) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: ResponsiveBreakpoints.of(context).isMobile
          ? mobileSize
          : desktopSize,
    );
  }

  static TextStyle getResponsiveTitleStyle(BuildContext context) {
    return getResponsiveStyle(
      context,
      24,
      36,
    ).copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle getResponsiveSubtitleStyle(BuildContext context) {
    return getResponsiveStyle(context, 14, 20, Colors.white70);
  }

  static TextStyle getResponsiveBodyStyle(BuildContext context) {
    return getResponsiveStyle(context, 12, 18, Colors.white54);
  }
}

class AppButtonStyles {
  static ButtonStyle primaryButton() {
    return TextButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle cancelButton() {
    return TextButton.styleFrom(
      backgroundColor: Colors.white54,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle successButton() {
    return TextButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle errorButton() {
    return TextButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle elevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // minimumSize: Size(
      //   ResponsiveBreakpoints.of(context).isMobile ? 200 : 300,
      //   50,
      // ),
    );
  }
}