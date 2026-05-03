import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/person.dart';
import '../utils/style.dart';
import '../widgets/icon_button_widget.dart';
import '../widgets/cached_image_widget.dart';
import '../widgets/person_info_widget.dart';
import '../widgets/group_grid_view_widget.dart';
import '../widgets/search_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/app_dialogs.dart';
import '../services/data_service.dart';
import '../services/image_preloader.dart';
import '../services/cache_config_service.dart';
import '../services/permission_service.dart';
import '../widgets/layout_constants.dart';
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
  bool isManualNavigation = false;

  Map<String, Person> persons = {};
  List<Person> selected = [];
  bool showGrid = false;

  bool showControls = true;
  Timer? slideshowTimer;
  Timer? hideTimer;

  // Settings variables
  int slideshowDuration = 5; // Default 5 seconds
  String autoClearCacheFrequency = 'daily'; // Default daily

  // Re-entry guard: prevents the scan screen from being pushed twice on a double-tap.
  bool _scanInProgress = false;

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
    _loadSettings();
    startSlideshow();
    autoHideControls();
    // Start preloading images for smooth transitions
    _preloadInitialImages();
  }

  Future<void> _loadSettings() async {
    final frequency = await CacheConfigService.getCurrentFrequency();
    setState(() {
      autoClearCacheFrequency = frequency;
    });
  }

  void startSlideshow() {
    slideshowTimer?.cancel();
    slideshowTimer = Timer.periodic(Duration(seconds: slideshowDuration), (_) {
      if (!paused && widget.persons.isNotEmpty && !showGrid) {
        _animateToNextSlide();
      }
    });
  }

  void _animateToNextSlide({bool isManual = false}) {
    if (isManual) {
      setState(() {
        isManualNavigation = true;
      });
      // Reset to automatic after a delay
      Future.delayed(Duration(seconds: slideshowDuration), () {
        if (mounted) {
          setState(() {
            isManualNavigation = false;
          });
        }
      });
    }

    setState(() {
      index = (index + 1) % widget.persons.length;
    });
    // Preload next images
    _preloadNextImages();
  }

  void _animateToPreviousSlide({bool isManual = false}) {
    if (isManual) {
      setState(() {
        isManualNavigation = true;
      });
      // Reset to automatic after a delay
      Future.delayed(Duration(seconds: slideshowDuration), () {
        if (mounted) {
          setState(() {
            isManualNavigation = false;
          });
        }
      });
    }

    setState(() {
      index = (index - 1 + widget.persons.length) % widget.persons.length;
    });
    // Preload previous images
    _preloadNextImages();
  }

  /// Preload initial images when slideshow starts
  void _preloadInitialImages() {
    if (widget.persons.isNotEmpty) {
      ImagePreloader.preloadNextImages(widget.persons, index);
    }
  }

  /// Preload next images for smooth transitions
  void _preloadNextImages() {
    if (widget.persons.isNotEmpty) {
      ImagePreloader.preloadNextImages(widget.persons, index);
    }
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
        autoClearCacheFrequency: autoClearCacheFrequency,
        onAutoClearCacheChanged: (frequency) async {
          setState(() {
            autoClearCacheFrequency = frequency;
          });
          // Update the global cache config
          await CacheConfigService.updateFrequency(frequency);
        },
      ),
    );
  }

  void autoHideControls() {
    hideTimer?.cancel();
    hideTimer = Timer(LayoutConstants.controlsHideDelay, () {
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
        elevation: 8,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  size: ResponsiveBreakpoints.of(context).isMobile
                      ? 220.0
                      : 300,
                  backgroundColor: Colors.white,
                  embeddedImage: AssetImage('assets/round_logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: ResponsiveBreakpoints.of(context).isMobile
                        ? Size(40, 40)
                        : Size(60, 60),
                  ),
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
    if (_scanInProgress) return;
    _scanInProgress = true;
    // Pause the slideshow while the scanner is on top, so the off-screen
    // page doesn't keep advancing slides and preloading images while the
    // camera pipeline needs CPU/decoder bandwidth.
    paused = true;
    try {
      if (await _isEmulator()) {
        if (mounted) showSearch();
        return;
      }

      final granted = await PermissionService.requestCameraPermission();
      if (!granted) {
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

      if (!mounted) return;
      final raw = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const _QrScannerScreen()),
      );

      if (raw == null || raw.isEmpty) return;
      debugPrint('QR Scan result: $raw');

      final id = int.tryParse(raw);
      if (id == null) return;

      final found = widget.persons.indexWhere((p) => p.id == id);
      debugPrint('Found index: $found');

      if (!mounted) return;
      if (found != -1) {
        setState(() {
          index = found;
        });
      } else {
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
    } catch (e) {
      debugPrint('Unexpected QR Scan error: $e');
      // Fallback to manual input on any camera error
      if (mounted) showSearch();
    } finally {
      _scanInProgress = false;
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
    final canSwipe = widget.persons.length > 1;

    return GestureDetector(
      onTap: onUserTouch,
      onHorizontalDragEnd: canSwipe
          ? (details) {
              const swipeVelocityThreshold = 200.0;
              final vx = details.velocity.pixelsPerSecond.dx;
              if (vx <= -swipeVelocityThreshold) {
                paused = true;
                _animateToNextSlide(isManual: true);
                onUserTouch();
              } else if (vx >= swipeVelocityThreshold) {
                paused = true;
                _animateToPreviousSlide(isManual: true);
                onUserTouch();
              }
            }
          : null,
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
                child: CachedImageWidget(
                  key: ValueKey<String>(p.id.toString()),
                  id: p.id,
                  heroTag: isManualNavigation ? 'slideshow_${p.id}' : null,
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
                            _animateToPreviousSlide(isManual: true);
                          });
                        },
                        heroTag: 'previous_button',
                      ),
                      IconButtonWidget(
                        icon: Icons.navigate_next,
                        onTap: () {
                          setState(() {
                            paused = true;
                            _animateToNextSlide(isManual: true);
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

/// Full-screen QR scanner backed by `mobile_scanner` (CameraX on Android,
/// AVFoundation on iOS). Keeps the front camera and applies a rotation
/// fallback when a portrait layout receives a landscape preview buffer
/// (some Android tablets), while using cover-fit to avoid tiny preview.
/// Pops with the first non-empty raw value detected, or `null` if cancelled.
class _QrScannerScreen extends StatefulWidget {
  const _QrScannerScreen();

  @override
  State<_QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<_QrScannerScreen> {
  late final MobileScannerController _controller;
  StreamSubscription<BarcodeCapture>? _barcodeSub;
  bool _popped = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.front,
      formats: [BarcodeFormat.qrCode],
      torchEnabled: false,
    );
    _barcodeSub = _controller.barcodes.listen(_onDetect);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await _controller.start();
      } catch (_) {
        // Ignore transient startup errors. The next open will retry.
      }
    });
  }

  @override
  void dispose() {
    _barcodeSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_popped || !mounted) return;
    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;
    if (raw == null || raw.isEmpty) return;
    _popped = true;
    Navigator.of(context).pop(raw);
  }

  Future<void> _toggleFlash() async {
    try {
      await _controller.toggleTorch();
      if (!mounted) return;
      setState(() => _flashOn = !_flashOn);
    } catch (_) {
      // Torch unsupported — ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            child: MobileScanner(
              controller: _controller,
              fit: BoxFit.cover,
            ),
            builder: (context, state, scannerChild) {
              final viewport = MediaQuery.sizeOf(context);
              final isViewportPortrait = viewport.height >= viewport.width;
              final hasPreviewSize =
                  state.size.width > 0 && state.size.height > 0;
              final isPreviewLandscape =
                  hasPreviewSize && state.size.width > state.size.height;

              final shouldRotatePreview =
                  state.isInitialized &&
                  isViewportPortrait &&
                  isPreviewLandscape;

              return RotatedBox(
                quarterTurns: shouldRotatePreview ? 1 : 0,
                child: scannerChild,
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonWidget(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                    heroTag: 'qr_scanner_close_button',
                  ),
                  IconButtonWidget(
                    icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                    onTap: _toggleFlash,
                    heroTag: 'qr_scanner_torch_button',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

