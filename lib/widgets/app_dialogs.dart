import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../utils/style.dart';

class AppDialogs {
  static Widget loadingDialog(BuildContext context, String message) {
    return AlertDialog(
      elevation: 8,
      backgroundColor: Colors.black87,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.black,
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
      elevation: 8,
      backgroundColor: Colors.black87,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.black,
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
      elevation: 8,
      backgroundColor: Colors.black87,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.black,
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
      elevation: 8,
      backgroundColor: Colors.black87,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.black,
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
