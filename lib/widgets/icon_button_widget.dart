import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? heroTag;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: backgroundColor ?? Colors.black54,
        heroTag: heroTag,
        onPressed: onTap,
        child: Icon(icon, color: iconColor ?? Colors.white),
      ),
    );
  }
}
