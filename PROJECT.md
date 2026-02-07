# TuVienTrucLam - Project Documentation

## 📋 Project Overview

TuVienTrucLam is a comprehensive Flutter application for Buddhist temple management with advanced search capabilities, Vietnamese diacritic support, high-performance image caching for 3000+ images, and a fully automated CI/CD pipeline.

## 🚀 Current Status (February 2026)

### ✅ Completed Features
- **Flutter Application**: Fully functional with search, slideshow, and settings
- **Advanced Image Caching**: Optimized for 3000+ images with smart preloading
- **Performance Optimization**: Memory management and hero animation control
- **CI/CD Pipeline**: Complete GitHub Actions workflow
- **Code Quality**: 0 analyzer issues, comprehensive test coverage
- **Security**: Custom vulnerability scanning implemented
- **Documentation**: Comprehensive guides and API docs

### 🔧 Technical Specifications
- **Framework**: Flutter 3.38.9
- **Language**: Dart 3.10.3
- **Platform**: Android (iOS ready)
- **Architecture**: MVC with service layer
- **Caching**: Flutter's built-in Image.file with custom optimization
- **Storage**: SharedPreferences for settings persistence
- **Testing**: Comprehensive unit and widget tests (15 test files)
- **CI/CD**: GitHub Actions with 5 workflows

## 📱 Application Features

### Core Functionality
1. **Search System**
   - Vietnamese diacritic support
   - Case-insensitive search
   - Multiple field matching
   - Pagination with load more

2. **Person Management**
   - Browse person records
   - Advanced filtering
   - Detail views with enhanced UI

3. **Optimized Slideshow Display**
   - High-performance presentation for 3000+ images
   - Smart preloading (next 3 + previous)
   - Hero animation control (auto vs manual)
   - Configurable timing and transitions

4. **Advanced Settings Management**
   - Duration configuration
   - Data folder selection
   - Unified cache management interface
   - Configurable auto-clear cache (never/daily/weekly/monthly)

### Performance Features
1. **Image Caching System**
   - Flutter's built-in Image.file caching
   - Memory optimization (80 images, 200MB limit)
   - Smart preloading for smooth transitions
   - Cache width/height optimization (2x screen resolution)

2. **Memory Management**
   - Bounded cache size to prevent crashes
   - Automatic cache clearing based on user preference
   - Efficient image decoding with cache parameters
   - Safe error handling for missing files

3. **Animation Optimization**
   - Hero animations disabled for automatic slideshow
   - Hero animations enabled for manual navigation
   - Smooth fade-in transitions (300ms)
   - Performance-focused animation design

### Technical Features
- **Responsive Design**: Multiple screen sizes with optimized layouts
- **Offline Support**: Local data storage and processing
- **Security**: Input validation and sanitization
- **Performance**: Optimized search algorithms and image handling

## 🏗️ Architecture Overview

### Directory Structure
```
lib/
├── main.dart                    # App entry point with cache configuration
├── models/
│   └── person.dart             # Data model for person records
├── screens/
│   ├── main_slideshow_page.dart # Main entry screen
│   └── slideshow_page.dart     # Slideshow with caching integration
├── services/
│   ├── data_service.dart       # Data management
│   ├── image_cache_manager.dart # Custom cache management
│   ├── image_preloader.dart    # Smart preloading service
│   ├── permission_service.dart # Device permissions
│   └── search_service.dart     # Search functionality
├── widgets/
│   ├── app_dialogs.dart        # Reusable dialog components
│   ├── cached_image_widget.dart # Optimized image display widget
│   ├── group_grid_view_widget.dart # Grid view with preloading
│   ├── icon_button_widget.dart # Custom icon button widget
│   ├── layout_constants.dart   # Layout constants and responsive sizing
│   ├── person_info_widget.dart # Person detail display
│   ├── search_dialog.dart      # Search interface
│   └── settings_dialog.dart    # Unified settings with cache management
└── utils/
    └── style.dart              # App styling and themes
```

### Caching Architecture
```
┌─────────────────────────────────────────┐
│              Main App                  │
├─────────────────────────────────────────┤
│  ImageCacheManager (Singleton)         │
│  ├── Auto-clear timer (configurable)   │
│  ├── Flutter image cache (80/200MB)    │
│  └── Cache statistics                  │
├─────────────────────────────────────────┤
│  ImagePreloader (Service)              │
│  ├── Next 3 images preloading          │
│  ├── Previous image preloading         │
│  ├── Grid preloading (20 images)       │
│  └── Duplicate prevention              │
├─────────────────────────────────────────┤
│  CachedImageWidget (UI)                │
│  ├── Memory-efficient decoding         │
│  ├── Cache width/height optimization   │
│  ├── Fade-in animations                │
│  └── Hero animation control            │
└─────────────────────────────────────────┘
```

## 🛠️ Development Setup

### Prerequisites
```bash
# Required versions
Flutter SDK: 3.38.9+
Dart SDK: 3.10.3+
Java JDK: 17+
```

### Quick Start
```bash
# Clone and setup
git clone https://github.com/khietlam/tuvientruclam.git
cd tuvientruclam
flutter pub get
flutter run
```

### Development Commands
```bash
# Testing
flutter test --coverage

# Code quality
flutter analyze --fatal-infos
dart format --set-exit-if-changed .

# Building
flutter build apk --release
flutter build appbundle --release
```

## 🚀 CI/CD Pipeline

### Workflows Overview
1. **Build Release APK** - Production builds with releases
2. **Build Debug APK** - Development builds
3. **Code Quality** - Analysis, testing, security
4. **Deploy Play Store** - Store deployment
5. **Test** - Simple verification workflow

### Build Process
```
Push Code → Trigger Workflow → 
Setup Environment → 
Install Dependencies → 
Run Tests → 
Build APK/AAB → 
Upload Artifacts → 
Create Release (master only)
```

### Branch Strategy
- `master`: Production builds with automatic releases
- `develop`: Staging builds
- `feature/*`: Feature development with debug builds
- `hotfix/*`: Bug fixes with debug builds

## 📊 Quality Metrics

### Code Quality
- **Analyzer Issues**: 0 (fixed from 17)
- **Test Files**: 15 comprehensive test suites
- **Code Coverage**: Automated reporting
- **Formatting**: 100% compliant
- **Security**: No vulnerabilities

### Performance Metrics
- **Image Load Time**: <100ms for cached images
- **Memory Usage**: Bounded to 200MB for image cache
- **Preload Efficiency**: Next 3 + previous images ready
- **Animation Performance**: 60fps smooth transitions

### Build Performance
- **Release Build**: 5-7 minutes
- **Debug Build**: 3-4 minutes
- **Quality Checks**: 2-3 minutes

## 🔐 Security Implementation

### Automated Scans
- **Secret Detection**: Hardcoded credentials scanning
- **Network Security**: HTTP vs HTTPS checking
- **Debug Safety**: Sensitive data in logs detection
- **Dependencies**: Vulnerability monitoring

### Best Practices
- No secrets in source code
- Secure API communication
- Input validation
- Error handling

## 🎯 Performance Optimizations

### Image Caching Strategy
1. **Flutter Native Caching**: Leverages Image.file built-in caching
2. **Memory Limits**: 80 images max, 200MB total
3. **Smart Decoding**: Cache at 2x screen resolution
4. **Preloading**: Next 3 + previous images
5. **Auto Cleanup**: Configurable timer-based clearing

### Memory Management
- Bounded cache prevents OOM crashes
- Efficient image decoding with cache parameters
- Safe disposal of timers and resources
- Error handling for missing/corrupt files

### Animation Optimization
- Hero animations disabled during automatic slideshow
- Hero animations enabled for manual navigation only
- 300ms fade-in transitions for smooth UX
- Minimal animation overhead for 3000 images

## 📦 Build Artifacts

### Release Builds
- **APK**: `app-release.apk` (device installation)
- **AAB**: `app-release.aab` (Play Store)
- **Checksums**: SHA256 verification
- **Retention**: 30 days

### Debug Builds
- **APK**: `app-debug.apk` (testing)
- **Retention**: 7 days

## 📚 Documentation Structure

```
├── README.md                 # Main project documentation
├── CI-CD.md                  # CI/CD detailed guide
├── CI-CD-SETUP.md           # Quick setup guide
├── .github/workflows/
│   ├── README.md            # Workflow documentation
│   ├── build-release-apk.yml
│   ├── build-debug-apk.yml
│   ├── code-quality.yml
│   ├── deploy-play-store.yml
│   └── test.yml
└── scripts/
    ├── README.md            # Scripts documentation
    ├── build-release.sh
    ├── test.sh
    └── security-scan.sh
```

## 🔄 Development Workflow

### 1. Feature Development
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
# ... (develop feature)

# Test locally
flutter test
flutter analyze
dart format .

# Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# Create Pull Request
```

### 2. Bug Fixes
```bash
# Create hotfix branch
git checkout -b hotfix/bug-fix

# Fix issue
# ... (fix bug)

# Test and push
git add .
git commit -m "Fix critical bug"
git push origin hotfix/bug-fix
```

### 3. Release Process
```bash
# Merge to master (triggers release build)
git checkout master
git merge feature/new-feature
git push origin master

# Automatic: Build → Test → Release → Deploy
```

## 🚨 Troubleshooting Guide

### Common Issues

#### Build Failures
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

#### Test Failures
```bash
# Check specific test
flutter test --name "test_name"

# Run with coverage
flutter test --coverage
```

#### CI/CD Issues
1. Check workflow syntax
2. Verify permissions
3. Review logs in Actions tab
4. Ensure Flutter version compatibility

#### Performance Issues
```bash
# Check image cache size
# Monitor memory usage
# Verify preloading is working
# Check for memory leaks
```

### Debug Commands
```bash
# Doctor check
flutter doctor -v

# Dependency tree
flutter pub deps

# Outdated packages
flutter pub outdated
```

## 📈 Future Roadmap

### Planned Features
- [ ] iOS deployment
- [ ] Advanced analytics
- [ ] Cloud synchronization
- [ ] Multi-language support
- [ ] Admin dashboard

### Technical Improvements
- [ ] Integration tests
- [ ] Performance monitoring
- [ ] Automated dependency updates
- [ ] Enhanced security scanning
- [ ] Advanced caching strategies

## 🤝 Contributing Guidelines

### Code Standards
- Follow Flutter/Dart conventions
- Write descriptive commit messages
- Include tests for new features
- Document complex logic
- Consider performance implications

### Pull Request Process
1. Fork repository
2. Create feature branch
3. Implement changes
4. Add tests
5. Update documentation
6. Submit PR with description

### Review Requirements
- All tests must pass
- Code must be formatted
- Analyzer must show 0 issues
- Security scan must pass
- Performance impact considered

## 📞 Support & Resources

### Documentation
- [Main README](./README.md)
- [CI/CD Guide](./CI-CD.md)
- [Setup Guide](./CI-CD-SETUP.md)
- [Workflows](./.github/workflows/README.md)

### Community
- [GitHub Issues](https://github.com/khietlam/tuvientruclam/issues)
- [GitHub Discussions](https://github.com/khietlam/tuvientruclam/discussions)

### External Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

## 📜 Project History

### Key Milestones
- **Initial Development**: Core Flutter application
- **Testing Suite**: 79 comprehensive tests
- **CI/CD Implementation**: Full automation pipeline
- **Security Hardening**: Vulnerability scanning
- **Code Quality**: 0 analyzer issues achieved
- **Documentation**: Complete guides and references
- **Performance Optimization**: Advanced caching for 3000+ images
- **UI Enhancement**: Modern settings interface and animations

### Technical Debt Resolved
- ✅ Flutter version compatibility (3.38.9)
- ✅ Dart SDK requirements (3.10.3)
- ✅ Analyzer issues (17 → 0)
- ✅ Code formatting (100% compliant)
- ✅ Security scan compatibility
- ✅ Workflow syntax errors
- ✅ Branch naming (master vs main)
- ✅ Image caching implementation
- ✅ Memory management optimization
- ✅ Hero animation performance
- ✅ Settings UI unification

---

**Project Status**: ✅ Production Ready  
**Last Updated**: February 6, 2026  
**Maintainer**: khietlam  
**License**: MIT

**Built with ❤️ using Flutter 3.38.9**
