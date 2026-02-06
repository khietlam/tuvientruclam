import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppDialogs {
  static Widget loadingDialog(BuildContext context, String message) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      content: Row(
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(width: 20),
          Text(
            message,
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
        ],
      ),
    );
  }

  static Widget successDialog(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        title,
        style: AppTextStyles.getResponsiveStyle(context, 20, 28, Colors.green),
      ),
      content: Text(
        message,
        style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white),
      ),
      actions: [
        TextButton(
          style: AppButtonStyles.successButton(),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: AppTextStyles.getResponsiveStyle(
              context,
              12,
              20,
              Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static Widget errorDialog(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        title,
        style: AppTextStyles.getResponsiveStyle(context, 20, 28, Colors.red),
      ),
      content: Text(
        message,
        style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white),
      ),
      actions: [
        TextButton(
          style: AppButtonStyles.errorButton(),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: AppTextStyles.getResponsiveStyle(
              context,
              12,
              20,
              Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static Widget confirmationDialog(
    BuildContext context,
    String title,
    String message,
    String confirmText,
    String cancelText,
    VoidCallback onConfirm,
  ) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        title,
        style: AppTextStyles.getResponsiveStyle(context, 20, 28),
      ),
      content: Text(
        message,
        style: AppTextStyles.getResponsiveStyle(context, 12, 20),
      ),
      actions: [
        TextButton(
          style: AppButtonStyles.cancelButton(),
          child: Text(
            cancelText,
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          style: AppButtonStyles.primaryButton(),
          onPressed: onConfirm,
          child: Text(
            confirmText,
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
        ),
      ],
    );
  }
}

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
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: Size(
        ResponsiveBreakpoints.of(context).isMobile ? 200 : 300,
        50,
      ),
    );
  }
}
