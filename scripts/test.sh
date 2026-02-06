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
