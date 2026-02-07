# TuVienTrucLam

A Flutter application for Buddhist temple management and information display with advanced image caching and performance optimizations.

## 📱 About

TuVienTrucLam is a comprehensive mobile application designed for Buddhist temples to manage and display information including:
- Person/search functionality with Vietnamese diacritic support
- High-performance slideshow display for 3000+ images
- Advanced image caching and preloading system
- Configurable settings with cache management
- Data import/export capabilities

## 🚀 Features

### Core Functionality
- **Search System**: Advanced search with Vietnamese diacritic support
- **Person Management**: Browse and search through person records
- **Optimized Slideshow**: Automated content presentation with smooth transitions
- **Smart Cache Management**: Configurable auto-clear cache system
- **Settings Management**: Comprehensive application configuration
- **Data Management**: Import and manage temple data

### Performance Features
- **Image Caching**: Flutter's built-in caching with memory optimization
- **Smart Preloading**: Next 3 + previous image preloading
- **Hero Animation Control**: Disabled for automatic, enabled for manual navigation
- **Memory Management**: Bounded cache size (80 images, 200MB)
- **Auto Cache Clearing**: Configurable daily/weekly/monthly cleanup

### UI/UX Features
- **Responsive Design**: Works across different screen sizes
- **Modern Interface**: Clean settings dialog with unified cache management
- **Smooth Animations**: Fade-in transitions and optimized performance
- **Vietnamese Support**: Full diacritic handling in search and display
- **Offline Capability**: Local data storage and processing

## 🛠️ Tech Stack

- **Framework**: Flutter 3.38.9
- **Language**: Dart 3.10.3
- **Architecture**: MVC pattern with service layer
- **Caching**: Flutter's built-in Image.file caching
- **Storage**: SharedPreferences for settings
- **Testing**: Comprehensive unit and widget tests (15 test files)
- **CI/CD**: GitHub Actions for automated builds and deployment

## 📦 Installation

### Prerequisites
- Flutter SDK 3.38.9 or higher
- Dart SDK 3.10.3 or higher
- Android Studio / VS Code with Flutter extensions

### Setup Instructions
```bash
# Clone the repository
git clone https://github.com/khietlam/tuvientruclam.git
cd tuvientruclam

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run code analysis
flutter analyze --fatal-infos

# Check code formatting
dart format --set-exit-if-changed .
```

## 🔧 Development

### Build Commands
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### Scripts
- `scripts/build-release.sh` / `scripts/build-release.ps1` - Automated release build scripts (Bash/PowerShell)
- `scripts/test.sh` / `scripts/test.ps1` - Run all quality checks (Bash/PowerShell)
- `scripts/security-scan.sh` - Security vulnerability scanning

## 🚀 CI/CD Pipeline

This project includes a comprehensive CI/CD pipeline using GitHub Actions:

### Automated Workflows
1. **Build Release APK** - Triggered on pushes to `master`/`develop`
2. **Build Debug APK** - Triggered on feature branches
3. **Code Quality** - Runs analysis, tests, and security scans
4. **Deploy Play Store** - Deploys to Google Play Store

### Build Artifacts
- **Release APK**: For direct device installation
- **App Bundle**: For Google Play Store submission
- **Checksums**: SHA256 verification files
- **Test Coverage**: Code coverage reports

### Branch Strategy
- `master`: Production builds with automatic releases
- `develop`: Staging builds
- `feature/*`: Feature branch debug builds
- `hotfix/*`: Bug fix debug builds

## 📊 Project Status

### Code Quality
- ✅ 0 analyzer issues
- ✅ Comprehensive test coverage (15 test files)
- ✅ 100% formatted code
- ✅ Security scanning passed

### Performance Optimizations
- ✅ Image caching implemented for 3000+ images
- ✅ Smart preloading system
- ✅ Configurable auto-clear cache
- ✅ Memory-efficient image loading
- ✅ Hero animation optimization

### Build Status
- ✅ Flutter 3.38.9 compatible
- ✅ Dart 3.10.3 compatible
- ✅ Android release ready
- ✅ Play Store ready

## 📱 Download

### Latest Release
- **GitHub Releases**: [Download APK here](https://github.com/khietlam/tuvientruclam/releases)
- **Artifacts**: Available in GitHub Actions

### Build from Source
See [Installation](#-installation) section above.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart coding standards
- Write tests for new features
- Ensure all tests pass before PR
- Use meaningful commit messages

## 📄 Documentation

- [CI/CD Guide](./CI-CD.md) - Complete CI/CD documentation
- [Setup Instructions](./CI-CD-SETUP.md) - Quick setup guide
- [Workflows](./.github/workflows/README.md) - GitHub Actions documentation

## 🔐 Security

This application follows security best practices:
- No hardcoded secrets
- Secure network communication
- Regular dependency scanning
- Input validation and sanitization

## 📞 Support

For support and questions:
- Create an [Issue](https://github.com/khietlam/tuvientruclam/issues)
- Check [Discussions](https://github.com/khietlam/tuvientruclam/discussions)

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors and testers
- Buddhist community for feedback and suggestions

---

**Built with ❤️ using Flutter**
