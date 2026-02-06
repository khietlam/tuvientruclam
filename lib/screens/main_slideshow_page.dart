import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/screens/slideshow_page.dart';

import '../services/data_service.dart';
import '../services/permission_service.dart';
import '../widgets/app_dialogs.dart';

class MainSlideshowPage extends StatefulWidget {
  const MainSlideshowPage({super.key});

  @override
  State<MainSlideshowPage> createState() => _MainSlideshowPageState();
}

class _MainSlideshowPageState extends State<MainSlideshowPage> {
  SlideshowPage? _slideshowPage;
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _requestStoragePermissions();
      final data = await DataService.loadDataFromExternal();
      if (mounted) {
        setState(() {
          _slideshowPage = SlideshowPage(persons: data);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _requestStoragePermissions() async {
    // Request basic storage permissions
    await PermissionService.requestStoragePermission();

    // For Android 11+, also request manage external storage
    if (Platform.isAndroid) {
      final manageStorageStatus = await Permission.manageExternalStorage.status;
      if (!manageStorageStatus.isGranted) {
        final result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          debugPrint('Manage external storage permission denied');
        }
      }
    }
  }

  Future<void> _uploadData() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final result = await DataService.selectDataFolder();

      if (mounted) {
        // Show success dialog briefly, then automatically start slideshow
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AppDialogs.successDialog(
            context,
            "Thành công!",
            result,
            "Bắt đầu",
            () {
              Navigator.pop(context); // Close success dialog
              setState(() {
                _isLoading = true; // Show loading while initializing data
              });
              _initializeData(); // Load data and start slideshow
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (_) => AppDialogs.errorDialog(
            context,
            "Lỗi!",
            e.toString(),
            "Đóng",
            () => Navigator.pop(context),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_slideshowPage != null) {
      return _slideshowPage!;
    }

    // Show upload screen when no data is available
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: ResponsiveBreakpoints.of(context).isMobile ? 80 : 120,
                color: Colors.white54,
              ),
              const SizedBox(height: 32),
              Text(
                "Chưa có dữ liệu",
                textAlign: TextAlign.center,
                style: AppTextStyles.getResponsiveTitleStyle(context),
              ),
              const SizedBox(height: 16),
              Text(
                "Vui lòng chọn thư mục chứa file data.json và hình ảnh để bắt đầu sử dụng ứng dụng.",
                textAlign: TextAlign.center,
                style: AppTextStyles.getResponsiveSubtitleStyle(context),
              ),
              const SizedBox(height: 48),
              if (_isUploading)
                Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      "Đang chọn thư mục...",
                      style: AppTextStyles.getResponsiveStyle(context, 14, 20),
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _uploadData,
                  icon: const Icon(Icons.folder_open),
                  label: Text(
                    "Chọn thư mục dữ liệu",
                    style: AppTextStyles.getResponsiveStyle(
                      context,
                      14,
                      20,
                      Colors.white,
                    ),
                  ),
                  style: AppButtonStyles.elevatedButtonStyle(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
