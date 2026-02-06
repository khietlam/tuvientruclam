# Flutter CI/CD Configuration

## Overview
This repository includes automated CI/CD pipelines using GitHub Actions to build, test, and deploy Flutter applications.

## Workflows

### 1. Build Release APK (`build-release-apk.yml`)
**Triggers:**
- Push to `master` or `develop` branches
- Pull requests to `master`
- Manual workflow dispatch

**Features:**
- Builds release APK and App Bundle (.aab)
- Automatic versioning with build numbers
- Artifact upload with checksums
- Automatic releases on master branch pushes
- Code signing ready (configure signing keys as secrets)

### 2. Build Debug APK (`build-debug-apk.yml`)
**Triggers:**
- Push to `feature/*` and `hotfix/*` branches
- Pull requests to `develop` or `master`
- Manual workflow dispatch

**Features:**
- Builds debug APK for testing
- Short artifact retention (7 days)
- Basic test execution

### 3. Code Quality and Security (`code-quality.yml`)
**Triggers:**
- Push to all branches
- Pull requests to `master` or `develop`

**Features:**
- Flutter analyze with strict rules
- Code formatting checks
- Test coverage reporting to Codecov
- Security vulnerability scanning
- Dependency audit

## Setup Instructions

### 1. Repository Secrets
Configure these secrets in your GitHub repository settings:

```
# Optional: For code signing (if needed)
KEYSTORE_BASE64: Base64 encoded keystore file
KEYSTORE_PASSWORD: Keystore password
KEY_ALIAS: Key alias
KEY_PASSWORD: Key password

# Optional: For deployment
PLAY_STORE_JSON_KEY: Play Store service account JSON
FIREBASE_TOKEN: Firebase deployment token
```

### 2. Flutter Version
Update the Flutter version in workflow files:
```yaml
flutter-version: '3.38.9'  # Change to your required version
```

### 3. Branch Strategy
- `master`: Production builds with automatic releases
- `develop`: Staging builds
- `feature/*`: Feature branch debug builds
- `hotfix/*`: Hotfix debug builds

## Artifact Downloads

### Release APKs
1. Go to Actions tab in GitHub
2. Select the workflow run
3. Download artifacts from the "Artifacts" section
4. For main branch builds, check the Releases page

### Debug APKs
- Available for 7 days after build
- Download from workflow run artifacts

## Version Management

Builds are automatically versioned:
- Format: `1.0.BUILD_NUMBER`
- Example: `1.0.123` (where 123 is the GitHub run number)

## Testing

Tests run automatically on:
- All pull requests
- Pushes to all branches
- Manual workflow dispatch

Coverage reports are sent to Codecov for tracking.

## Security

- Dependency vulnerability scanning
- Basic secret detection
- Code audit with `dart pub audit`

## Deployment

### Google Play Store
1. Set up `PLAY_STORE_JSON_KEY` secret
2. Add deployment step to release workflow
3. Use App Bundle (.aab) for Play Store submission

### Firebase App Distribution
1. Set up `FIREBASE_TOKEN` secret
2. Add Firebase deployment step
3. Configure distribution lists

## Customization

### Build Variants
Add additional build steps for different flavors:
```yaml
- name: Build APK (Production)
  run: flutter build apk --release --flavor=production
  
- name: Build APK (Staging)  
  run: flutter build apk --release --flavor=staging
```

### Custom Scripts
Add custom build scripts in `scripts/` directory and reference them in workflows.

## Troubleshooting

### Common Issues
1. **Flutter version mismatch**: Update version in workflow files
2. **Dependency conflicts**: Run `flutter pub get` locally first
3. **Build failures**: Check workflow logs for specific errors
4. **Test failures**: Run tests locally to reproduce issues

### Debugging
- Enable verbose logging with `--verbose` flag
- Check individual step logs in GitHub Actions
- Use workflow dispatch for manual testing

## Best Practices

1. **Keep Flutter version consistent** across all workflows
2. **Use semantic versioning** for releases
3. **Maintain high test coverage** (>80% recommended)
4. **Review security scan results** regularly
5. **Clean up old artifacts** to save storage
6. **Monitor build times** and optimize if needed

## Support

For issues with the CI/CD pipeline:
1. Check GitHub Actions logs
2. Review Flutter documentation
3. Ensure all dependencies are compatible
4. Verify repository secrets are correctly configured
