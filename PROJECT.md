# TuVienTrucLam - Project Documentation

## 📋 Project Overview

TuVienTrucLam is a comprehensive Flutter application for Buddhist temple management with advanced search capabilities, Vietnamese diacritic support, and a fully automated CI/CD pipeline.

## 🚀 Current Status (February 2026)

### ✅ Completed Features
- **Flutter Application**: Fully functional with search, slideshow, and settings
- **CI/CD Pipeline**: Complete GitHub Actions workflow
- **Code Quality**: 0 analyzer issues, 79 passing tests
- **Security**: Custom vulnerability scanning implemented
- **Documentation**: Comprehensive guides and API docs

### 🔧 Technical Specifications
- **Framework**: Flutter 3.38.9
- **Language**: Dart 3.10.3
- **Platform**: Android (iOS ready)
- **Architecture**: MVC with service layer
- **Testing**: Unit and widget tests (79 tests)
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
   - Detail views

3. **Slideshow Display**
   - Automated content presentation
   - Configurable timing
   - Responsive design

4. **Settings Management**
   - Duration configuration
   - Data folder selection
   - User preferences

### Technical Features
- **Responsive Design**: Multiple screen sizes
- **Offline Support**: Local data storage
- **Security**: Input validation and sanitization
- **Performance**: Optimized search algorithms

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
- **Tests**: 79 passing (100%)
- **Code Coverage**: Automated reporting
- **Formatting**: 100% compliant
- **Security**: No vulnerabilities

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

## 🤝 Contributing Guidelines

### Code Standards
- Follow Flutter/Dart conventions
- Write descriptive commit messages
- Include tests for new features
- Document complex logic

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

### Technical Debt Resolved
- ✅ Flutter version compatibility (3.38.9)
- ✅ Dart SDK requirements (3.10.3)
- ✅ Analyzer issues (17 → 0)
- ✅ Code formatting (100% compliant)
- ✅ Security scan compatibility
- ✅ Workflow syntax errors
- ✅ Branch naming (master vs main)

---

**Project Status**: ✅ Production Ready  
**Last Updated**: February 5, 2026  
**Maintainer**: khietlam  
**License**: MIT

**Built with ❤️ using Flutter 3.38.9**
