import 'dart:async';
import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/person.dart';
import '../utils/style.dart';
import '../widgets/icon_button_widget.dart';
import '../widgets/image_display_widget.dart';
import '../widgets/person_info_widget.dart';
import '../widgets/group_grid_view_widget.dart';
import '../widgets/search_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/app_dialogs.dart';
import '../services/data_service.dart';
import 'main_slideshow_page.dart';

class SlideshowPage extends StatefulWidget {
  final List<Person> persons;

  const SlideshowPage({super.key, required this.persons});

  @override
  State<SlideshowPage> createState() => _SlideshowPageState();
}

class _SlideshowPageState extends State<SlideshowPage> {
  int index = 0;
  bool paused = false;

  Map<String, Person> persons = {};
  List<Person> selected = [];
  bool showGrid = false;

  bool showControls = true;
  Timer? slideshowTimer;
  Timer? hideTimer;

  // Settings variables
  int slideshowDuration = 5; // Default 5 seconds

  final _aspectTolerance = 0.00;
  final _selectedCamera = 1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  final selectedFormats = [..._possibleFormats];

  @override
  void dispose() {
    slideshowTimer?.cancel();
    hideTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    persons = {for (var p in widget.persons) p.id.toString(): p};
    startSlideshow();
    autoHideControls();
  }

  void startSlideshow() {
    slideshowTimer?.cancel();
    slideshowTimer = Timer.periodic(Duration(seconds: slideshowDuration), (_) {
      if (!paused && widget.persons.isNotEmpty && !showGrid) {
        _animateToNextSlide();
      }
    });
  }

  void _animateToNextSlide() {
    setState(() {
      index = (index + 1) % widget.persons.length;
    });
  }

  void _animateToPreviousSlide() {
    setState(() {
      index = (index - 1 + widget.persons.length) % widget.persons.length;
    });
  }

  void showSettings() {
    paused = true;
    showDialog(
      context: context,
      builder: (_) => SettingsDialog(
        currentDuration: slideshowDuration,
        onDurationChanged: (newDuration) {
          setState(() {
            slideshowDuration = newDuration;
          });
          startSlideshow(); // Restart with new duration
        },
        onChangeDataFolder: _changeDataFolder,
      ),
    );
  }

  void autoHideControls() {
    hideTimer?.cancel();
    hideTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() => showControls = false);
      }
    });
  }

  void onUserTouch() {
    setState(() => showControls = true);
    autoHideControls();
  }

  Future<void> _changeDataFolder() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            AppDialogs.loadingDialog(context, "Đang chọn thư mục..."),
      );

      final result = await DataService.selectDataFolder();

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AppDialogs.successDialog(
            context,
            "Thành công!",
            result,
            "Khởi động lại",
            () {
              Navigator.pop(context);
              // Restart the app to load new data
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainSlideshowPage()),
              );
            },
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error dialog
      if (mounted) {
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
    }
  }

  void showSearch() {
    paused = true;
    showDialog(
      context: context,
      builder: (_) => SearchDialog(
        persons: widget.persons,
        personsMap: persons,
        onSingleResult: (person) {
          final foundIndex = widget.persons.indexWhere(
            (p) => p.id == person.id,
          );
          setState(() {
            index = foundIndex;
            paused = true;
            showGrid = false;
          });
        },
        onMultipleResults: (foundPersons) {
          foundPersons.sort((a, b) => a.id.compareTo(b.id));
          setState(() {
            selected = foundPersons;
            showGrid = true;
            paused = true;
          });
        },
        onReopenSearch: showSearch,
      ),
    );
  }

  void showQRCode() {
    final p = widget.persons[index];
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mã QR: ${p.theDanh}',
                style: AppTextStyles.getResponsiveStyle(
                  context,
                  14,
                  20,
                  Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: QrImageView(
                  data: p.id.toString(),
                  version: QrVersions.auto,
                  size: 300.0,
                  backgroundColor: Colors.white,
                  embeddedImage: AssetImage('assets/round_logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(size: Size(80, 80)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ID: ${p.id}',
                style: AppTextStyles.getResponsiveStyle(
                  context,
                  12,
                  18,
                  Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: AppButtonStyles.elevatedButtonStyle(context),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Đóng',
                  style: AppTextStyles.getResponsiveStyle(
                    context,
                    12,
                    18,
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _isEmulator() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.isPhysicalDevice == false;
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      return iosInfo.isPhysicalDevice == false;
    }
    return false;
  }

  Future<void> scanQRCode() async {
    // Check if running on emulator
    final isEmulator = await _isEmulator();
    if (isEmulator) {
      showSearch();
      return;
    }

    try {
      // Check camera permission first
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (_) => AppDialogs.errorDialog(
                context,
                "Lỗi!",
                'Camera permission is required to scan QR codes',
                "OK",
                () => Navigator.pop(context),
              ),
            );
          }
          return;
        }
      }

      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'Cancel',
            'flash_on': 'Flash on',
            'flash_off': 'Flash off',
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );

      debugPrint('QR Scan result: ${result.rawContent}');

      if (result.rawContent.isNotEmpty) {
        final id = int.tryParse(result.rawContent);
        if (id == null) return;

        final found = widget.persons.indexWhere((p) => p.id == id);

        debugPrint('Found index: $found');

        if (found != -1) {
          setState(() {
            index = found;
            paused = true;
          });
        } else {
          if (mounted) {
            showDialog(
              context: context,
              builder: (_) => AppDialogs.errorDialog(
                context,
                "Lỗi!",
                "Không tìm thấy ID",
                "Đóng",
                () => Navigator.pop(context),
              ),
            );
          }
        }
      }
    } on PlatformException catch (e) {
      debugPrint('QR Scan error: $e');

      String errorMessage;
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        errorMessage = 'Camera permission denied';
      } else {
        errorMessage = 'Camera error: ${e.message ?? 'Unknown error'}';
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AppDialogs.errorDialog(
            context,
            "Lỗi!",
            errorMessage,
            "Đóng",
            () => Navigator.pop(context),
          ),
        );
      }
    } catch (e) {
      debugPrint('Unexpected QR Scan error: $e');
      // Fallback to manual input on any camera error
      showSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.persons.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (showGrid) {
      return GestureDetector(
        onTap: onUserTouch,
        child: Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: Colors.black)),
              Positioned.fill(child: GroupGridView(persons: selected)),

              if (showControls)
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButtonWidget(
                    icon: Icons.close,
                    iconColor: Colors.white,
                    backgroundColor: Colors.blueGrey,
                    onTap: () {
                      setState(() {
                        showGrid = false;
                        selected.clear();
                      });
                    },
                    heroTag: 'grid_close_button',
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final p = widget.persons[index];

    return GestureDetector(
      onTap: onUserTouch,
      child: Scaffold(
        body: Stack(
          children: [
            // Animated PageView for smooth transitions
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Choose different animation effects based on direction
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: ImageDisplayWidget(
                  key: ValueKey<String>(p.id.toString()),
                  id: p.id,
                  heroTag: 'slideshow_${p.id}',
                ),
              ),
            ),

            // Person info with slide-up animation
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: PersonInfoWidget(
                  key: ValueKey<String>(p.id.toString()),
                  person: p,
                ),
              ),
            ),

            if (showControls)
              Positioned(
                top: 20,
                right: 20,
                child: Column(
                  children: [
                    // Navigation controls - show only home button for individual slideshows from search
                    if (widget.persons.length == 1) ...[
                      IconButtonWidget(
                        icon: Icons.arrow_back,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        heroTag: 'back_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.home,
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const MainSlideshowPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        heroTag: 'home_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.qr_code,
                        onTap: showQRCode,
                        heroTag: 'qr_display_button',
                      ),
                    ] else ...[
                      // Show all controls for multiple person slideshows
                      IconButtonWidget(
                        icon: Icons.search,
                        onTap: showSearch,
                        heroTag: 'search_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.qr_code_scanner,
                        onTap: scanQRCode,
                        heroTag: 'qr_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.settings,
                        onTap: showSettings,
                        heroTag: 'settings_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.home,
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const MainSlideshowPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        heroTag: 'home_button',
                      ),
                      IconButtonWidget(
                        icon: paused ? Icons.play_arrow : Icons.pause,
                        onTap: () {
                          setState(() => paused = !paused);
                        },
                        heroTag: 'play_pause_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.navigate_before,
                        onTap: () {
                          setState(() {
                            paused = true;
                            _animateToPreviousSlide();
                          });
                        },
                        heroTag: 'previous_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.navigate_next,
                        onTap: () {
                          setState(() {
                            paused = true;
                            _animateToNextSlide();
                          });
                        },
                        heroTag: 'next_button',
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
