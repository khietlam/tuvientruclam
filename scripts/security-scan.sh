#!/bin/bash
set -e

echo "Running security scan..."

echo "Checking for hardcoded secrets..."
grep -r "password\|secret\|key\|token" --include="*.dart" lib/ --exclude-dir=test || true

echo "Checking for insecure network calls..."
grep -r "http://" --include="*.dart" lib/ --exclude-dir=test || true

echo "Checking for debug prints with sensitive data..."
grep -r "print(" --include="*.dart" lib/ --exclude-dir=test | grep -i "password\|secret\|key\|token" || true

echo "Checking dependencies tree..."
flutter pub deps --style=tree > deps.txt
echo "Dependencies tree saved to deps.txt"

echo "Security scan completed!"
