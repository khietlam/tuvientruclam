# CI/CD Scripts

## Build Scripts Directory

### build-release.sh
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

### test.sh
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

### deploy-play-store.sh
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
