import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tuvientruclam/screens/main_slideshow_page.dart';
import 'package:tuvientruclam/services/cache_config_service.dart';

/// Main entry point for the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();
  runApp(const TuVienTrucLamApp());
}

/// Initialize app settings and configurations
Future<void> _initializeApp() async {
  // Set device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Enable immersive mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Configure image cache
  _configureImageCache();

  // Setup auto-clear cache based on saved preference
  await CacheConfigService.initializeFromPreferences();
}

/// Configure Flutter's image cache settings
void _configureImageCache() {
  PaintingBinding.instance.imageCache
    ..maximumSize = 80
    ..maximumSizeBytes = 200 << 20; // 200MB
}

class TuVienTrucLamApp extends StatelessWidget {
  const TuVienTrucLamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: const MainSlideshowPage(),
    );
  }
}
