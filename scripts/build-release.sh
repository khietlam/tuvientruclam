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
