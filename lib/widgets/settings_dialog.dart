import 'package:flutter/material.dart';
import '../utils/style.dart';
import '../widgets/app_dialogs.dart';
import '../services/image_cache_manager.dart';
import '../services/image_preloader.dart';

class SettingsDialog extends StatefulWidget {
  final int currentDuration;
  final Function(int) onDurationChanged;
  final VoidCallback onChangeDataFolder;
  final String autoClearCacheFrequency;
  final Function(String) onAutoClearCacheChanged;

  const SettingsDialog({
    super.key,
    required this.currentDuration,
    required this.onDurationChanged,
    required this.onChangeDataFolder,
    required this.autoClearCacheFrequency,
    required this.onAutoClearCacheChanged,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _controller;
  Map<String, dynamic>? _cacheStats;
  bool _isLoadingCache = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentDuration.toString(),
    );
    _loadCacheStats();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCacheStats() async {
    setState(() {
      _isLoadingCache = true;
    });

    try {
      final stats = await ImageCacheManager().getCacheStats();
      final preloadStats = ImagePreloader.getPreloadStats();

      setState(() {
        _cacheStats = {
          ...stats,
          'preloadedCount': preloadStats['preloadedCount'],
        };
        _isLoadingCache = false;
      });
    } catch (e) {
      setState(() {
        _cacheStats = {'error': e.toString()};
        _isLoadingCache = false;
      });
    }
  }

  Future<void> _clearCache() async {
    try {
      await ImageCacheManager().clearCache();
      ImagePreloader.clearPreloadTracking();
      await _loadCacheStats();

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AppDialogs.successDialog(
            context,
            "Thành công!",
            "Đã xóa cache hình ảnh.",
            "OK",
            () => Navigator.pop(context),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AppDialogs.errorDialog(
            context,
            "Lỗi!",
            "Không thể xóa cache: ${e.toString()}",
            "OK",
            () => Navigator.pop(context),
          ),
        );
      }
    }
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
      elevation: 8,
      backgroundColor: Colors.black87,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.black,
      title: Text(
        "Cài đặt",
        style: AppTextStyles.getResponsiveStyle(context, 20, 28, Colors.white),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thời gian chuyển slide (giây):",
                    style: AppTextStyles.getResponsiveStyle(
                      context,
                      12,
                      20,
                      Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: Colors.black87,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.getResponsiveStyle(
                        context,
                        12,
                        20,
                        Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Nhập số giây (1-60)",
                        hintStyle: AppTextStyles.getResponsiveStyle(
                          context,
                          12,
                          20,
                          Colors.white38,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Phạm vi: 1-60 giây",
                    style: AppTextStyles.getResponsiveStyle(
                      context,
                      12,
                      18,
                      Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Unified cache management section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Quản lý cache hình ảnh",
                      style: AppTextStyles.getResponsiveStyle(
                        context,
                        12,
                        20,
                        Colors.white70,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Auto clear cache dropdown
                  Text(
                    "Tự động xóa cache",
                    style: AppTextStyles.getResponsiveStyle(
                      context,
                      12,
                      20,
                      Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: Colors.black87,
                    child: DropdownButtonFormField<String>(
                      initialValue: widget.autoClearCacheFrequency,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      dropdownColor: Colors.black87,
                      style: AppTextStyles.getResponsiveStyle(
                        context,
                        12,
                        20,
                        Colors.white70,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'never',
                          child: Text('Không bao giờ'),
                        ),
                        DropdownMenuItem(
                          value: 'daily',
                          child: Text('Hàng ngày'),
                        ),
                        DropdownMenuItem(
                          value: 'weekly',
                          child: Text('Hàng tuần'),
                        ),
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text('Hàng tháng'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          widget.onAutoClearCacheChanged(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cache statistics
                  Text(
                    "Thông tin cache",
                    style: AppTextStyles.getResponsiveStyle(
                      context,
                      12,
                      20,
                      Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoadingCache)
                    const CircularProgressIndicator(color: Colors.white54)
                  else if (_cacheStats != null) ...[
                    if (_cacheStats!['error'] != null)
                      Text(
                        "Lỗi: ${_cacheStats!['error']}",
                        style: AppTextStyles.getResponsiveStyle(
                          context,
                          12,
                          18,
                          Colors.red,
                        ),
                      )
                    else ...[
                      Text(
                        "Đã preload: ${_cacheStats!['preloadedCount'] ?? 0} ảnh",
                        style: AppTextStyles.getResponsiveStyle(
                          context,
                          12,
                          20,
                          Colors.white70,
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),

                  // Clear cache button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _clearCache,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(
                        "Xóa cache ngay",
                        style: AppTextStyles.getResponsiveStyle(
                          context,
                          12,
                          20,
                          Colors.white,
                        ),
                      ),
                      style: AppButtonStyles.elevatedButtonStyle(context)
                          .copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.orange,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
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
                  style: AppTextStyles.getResponsiveStyle(
                    context,
                    12,
                    20,
                    Colors.white,
                  ),
                ),
                style: AppButtonStyles.elevatedButtonStyle(context),
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
