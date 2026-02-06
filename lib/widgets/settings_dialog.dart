import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../widgets/app_dialogs.dart';

class SettingsDialog extends StatefulWidget {
  final int currentDuration;
  final Function(int) onDurationChanged;
  final VoidCallback onChangeDataFolder;

  const SettingsDialog({
    super.key,
    required this.currentDuration,
    required this.onDurationChanged,
    required this.onChangeDataFolder,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentDuration.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final newDuration = int.tryParse(_controller.text);
    if (newDuration != null && newDuration >= 1 && newDuration <= 60) {
      widget.onDurationChanged(newDuration);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AppDialogs.errorDialog(
          context,
          "Lỗi!",
          "Vui lòng nhập số từ 1 đến 60",
          "OK",
          () => Navigator.pop(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        "Cài đặt",
        style: AppTextStyles.getResponsiveStyle(context, 20, 28),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thời gian chuyển slide (giây):",
              style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white),
              decoration: InputDecoration(
                hintText: "Nhập số giây (1-60)",
                hintStyle: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white38),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Phạm vi: 1-60 giây",
              style: AppTextStyles.getResponsiveBodyStyle(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onChangeDataFolder();
                },
                icon: const Icon(Icons.folder_open),
                label: Text(
                  "Đổi thư mục dữ liệu",
                  style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: AppButtonStyles.cancelButton(),
          child: Text(
            "Hủy",
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          style: AppButtonStyles.primaryButton(),
          onPressed: _saveSettings,
          child: Text(
            "Lưu",
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
        ),
      ],
    );
  }
}
