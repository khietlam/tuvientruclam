# TuVienTrucLam - CI/CD Configuration

This repository includes a comprehensive CI/CD pipeline for building and deploying Flutter applications.

## 🚀 Quick Start

1. **Push to master branch** → Automatic release build
2. **Push to feature branches** → Debug builds
3. **Pull requests** → Full testing and analysis

## 📋 Available Workflows

### 1. Build Release APK
- **Triggers**: Push to `master`/`develop`, PRs to `master`, manual
- **Outputs**: Release APK, App Bundle (.aab), checksums
- **Features**: Auto-versioning, automatic releases
- **Flutter Version**: 3.38.9

### 2. Build Debug APK  
- **Triggers**: Feature/hotfix branches, PRs
- **Outputs**: Debug APK (7-day retention)
- **Features**: Quick testing builds

### 3. Code Quality & Security
- **Triggers**: All pushes and PRs
- **Features**: Linting, testing, security scanning, coverage

### 4. Play Store Deployment
- **Triggers**: Published releases, manual
- **Features**: Deploy to internal/alpha/beta/production tracks

## 🛠️ Setup Required

### Repository Secrets
Configure these in GitHub repository settings:

```bash
# Optional: For Play Store deployment
PLAY_STORE_JSON_KEY=your_service_account_json

# Optional: For code signing
KEYSTORE_BASE64=base64_encoded_keystore
KEYSTORE_PASSWORD=your_keystore_password
KEY_ALIAS=your_key_alias
KEY_PASSWORD=your_key_password
```

### Local Scripts
Use the provided scripts for local development:

**Unix-like systems (Linux, macOS, WSL):**
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Build release locally
./scripts/build-release.sh

# Run tests locally
./scripts/test.sh
```

**Windows (PowerShell):**
```powershell
# Build release locally
.\scripts\build-release.ps1

# Run tests locally
.\scripts\test.ps1
```

## 📱 Artifact Downloads

### Release Builds
1. Go to **Actions** tab in GitHub
2. Select workflow run
3. Download artifacts from the **Artifacts** section
4. Check **Releases** page for main branch builds

### File Types
- **APK**: Direct installation on Android devices
- **AAB**: For Google Play Store submission
- **Checksums**: SHA256 verification files

## 🔧 Customization

### Flutter Version
Update in workflow files:
```yaml
flutter-version: '3.38.9'  # Change to your version
```

### Build Variants
Add different flavors in `android/app/build.gradle.ci`

### Branch Strategy
- `master`: Production builds with releases
- `develop`: Staging builds  
- `feature/*`: Feature testing
- `hotfix/*`: Bug fixes

## 📊 Monitoring

- **Test Coverage**: Sent to Codecov
- **Build Status**: GitHub Actions badges
- **Security**: Dependency vulnerability scanning
- **Code Quality**: Flutter analyze with strict rules

### ✅ Latest Test Results (Feb 7, 2026)

**All 401 tests passing!** 🎉

```bash
flutter test --coverage
00:17 +401: All tests passed!
Exit code: 0
```

**Test Breakdown:**
- Model Tests: 15 tests
- Service Tests: 156 tests
- Utils Tests: 23 tests
- Widget Tests: 184 tests
- Screen Tests: 8 tests
- Integration Tests: 15 tests

See [TEST_COVERAGE.md](TEST_COVERAGE.md) for detailed test documentation.

## 🚨 Troubleshooting

### Common Issues
1. **Flutter version mismatch** → Update version in workflows
2. **Build failures** → Check workflow logs for specific errors
3. **Test failures** → Run tests locally to reproduce
4. **Permission errors** → Check repository secrets

### Debug Steps
1. Check individual workflow step logs
2. Use manual workflow dispatch for testing
3. Enable verbose logging with `--verbose` flag

## 📝 Best Practices

1. **Maintain high test coverage** (>80% recommended)
2. **Review security scan results** regularly
3. **Use semantic versioning** for releases
4. **Clean up old artifacts** to save storage
5. **Monitor build times** and optimize

## 🔐 Security Features

- Dependency vulnerability scanning
- Basic secret detection
- Code audit with `dart pub audit`
- Secure secret management

## 📞 Support

For CI/CD issues:
1. Check GitHub Actions logs
2. Review Flutter documentation
3. Verify repository secrets
4. Ensure dependencies are compatible

---

**Ready to go!** Your CI/CD pipeline is now configured. Push your code to trigger automatic builds and deployments.
