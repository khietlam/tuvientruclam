# CI/CD Scripts

This directory contains build and testing scripts for both Unix-like systems (Bash) and Windows (PowerShell).

## Available Scripts

### Build Scripts

#### build-release.sh / build-release.ps1
Cross-platform release build scripts.
#!/bin/bash
set -e

echo "Building Flutter release APK..."

# Get build number from environment or use timestamp
BUILD_NUMBER=${BUILD_NUMBER:-$(date +%s)}
VERSION_NAME="1.0.$BUILD_NUMBER"

echo "Build Number: $BUILD_NUMBER"
echo "Version Name: $VERSION_NAME"

# Clean previous builds
flutter clean
flutter pub get

# Build APK
echo "Building APK..."
flutter build apk --release \
  --build-number=$BUILD_NUMBER \
  --build-name=$VERSION_NAME \
  --verbose

# Build App Bundle
echo "Building App Bundle..."
flutter build appbundle --release \
  --build-number=$BUILD_NUMBER \
  --build-name=$VERSION_NAME \
  --verbose

# Generate checksums
echo "Generating checksums..."
cd build/app/outputs/flutter-apk/
sha256sum app-release.apk > app-release.apk.sha256
cd ../../../../..

cd build/app/outputs/bundle/release/
sha256sum app-release.aab > app-release.aab.sha256
cd ../../../../..

echo "Build completed successfully!"
echo "APK: build/app/outputs/flutter-apk/app-release.apk"
echo "AAB: build/app/outputs/bundle/release/app-release.aab"

**PowerShell version (build-release.ps1)**: Same functionality for Windows environments.

### Test Scripts

#### test.sh / test.ps1
Cross-platform testing scripts.
#!/bin/bash
set -e

echo "Running Flutter tests..."

# Get dependencies
flutter pub get

# Run tests with coverage
echo "Running unit tests..."
flutter test --coverage

# Analyze code
echo "Analyzing code..."
flutter analyze

# Check formatting
echo "Checking code formatting..."
dart format --set-exit-if-changed .

echo "All tests passed!"

**PowerShell version (test.ps1)**: Same functionality for Windows environments with additional features like detailed test output.

### Security Scripts

#### security-scan.sh
#!/bin/bash
set -e

if [ -z "$PLAY_STORE_JSON_KEY" ]; then
    echo "Error: PLAY_STORE_JSON_KEY environment variable is required"
    exit 1
fi

echo "Deploying to Google Play Store..."

# Create service account file
echo "$PLAY_STORE_JSON_KEY" > service-account.json

# Get track from environment or use default
TRACK=${TRACK:-"internal"}

echo "Deploying to track: $TRACK"

# Deploy using your preferred method
# This example uses a placeholder - replace with your actual deployment command
# google-play-cli upload-aab \
#   --package-name com.your.package \
#   --aab build/app/outputs/bundle/release/app-release.aab \
#   --track $TRACK \
#   --json-key service-account.json

echo "Deployment completed!"

# Clean up
rm service-account.json

### setup-environment.sh
#!/bin/bash

echo "Setting up Flutter development environment..."

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "Flutter version: $(flutter --version)"

# Get dependencies
flutter pub get

# Check for required tools
echo "Checking required tools..."

# Check Java
if ! command -v java &> /dev/null; then
    echo "Warning: Java is not installed. Required for Android builds."
fi

# Check Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "Warning: ANDROID_HOME is not set. Required for Android builds."
fi

echo "Environment setup completed!"

### clean.sh
#!/bin/bash

echo "Cleaning Flutter project..."

# Clean Flutter
flutter clean

# Remove generated files
rm -f build/app/outputs/flutter-apk/*.sha256
rm -f build/app/outputs/bundle/release/*.sha256
rm -f test-report.json

echo "Clean completed!"

## Usage

### On Unix-like systems (Linux, macOS, WSL)
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run build
./scripts/build-release.sh

# Run tests
./scripts/test.sh

# Run security scan
./scripts/security-scan.sh
```

### On Windows (PowerShell)
```powershell
# Run build
.\scripts\build-release.ps1

# Run tests
.\scripts\test.ps1
```

## Notes
- Bash scripts (.sh) work on Linux, macOS, and Windows Subsystem for Linux (WSL)
- PowerShell scripts (.ps1) are optimized for Windows environments
- Both versions provide the same core functionality
- PowerShell scripts may include additional Windows-specific features
