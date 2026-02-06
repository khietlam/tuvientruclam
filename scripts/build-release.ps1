# Build Release Script for Windows PowerShell
# TuVienTrucLam Flutter Application

param(
    [string]$BuildNumber = $null,
    [switch]$SkipTests = $false,
    [switch]$Help = $false
)

if ($Help) {
    Write-Host "TuVienTrucLam Build Script"
    Write-Host "Usage: .\build-release.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -BuildNumber <number>  Custom build number"
    Write-Host "  -SkipTests             Skip running tests"
    Write-Host "  -Help                  Show this help message"
    exit 0
}

Write-Host "Building Flutter release APK..." -ForegroundColor Green

# Get build number from environment or use timestamp
if (-not $BuildNumber) {
    if ($env:BUILD_NUMBER) {
        $BuildNumber = $env:BUILD_NUMBER
    } else {
        $BuildNumber = [int][double]::Parse((Get-Date -UFormat %s))
    }
}

$VersionName = "1.0.$BuildNumber"

Write-Host "Build Number: $BuildNumber" -ForegroundColor Cyan
Write-Host "Version Name: $VersionName" -ForegroundColor Cyan

try {
    # Clean previous builds
    Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
    flutter clean
    
    # Get dependencies
    Write-Host "Getting dependencies..." -ForegroundColor Yellow
    flutter pub get
    
    # Run tests unless skipped
    if (-not $SkipTests) {
        Write-Host "Running tests..." -ForegroundColor Yellow
        $testResult = flutter test
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Tests failed!" -ForegroundColor Red
            exit 1
        }
        Write-Host "Tests passed!" -ForegroundColor Green
    }
    
    # Run code analysis
    Write-Host "Running code analysis..." -ForegroundColor Yellow
    $analyzeResult = flutter analyze --fatal-infos
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Code analysis failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Code analysis passed!" -ForegroundColor Green
    
    # Build APK
    Write-Host "Building APK..." -ForegroundColor Yellow
    $apkResult = flutter build apk --release --build-number=$BuildNumber --build-name=$VersionName --verbose
    if ($LASTEXITCODE -ne 0) {
        Write-Host "APK build failed!" -ForegroundColor Red
        exit 1
    }
    
    # Build App Bundle
    Write-Host "Building App Bundle..." -ForegroundColor Yellow
    $aabResult = flutter build appbundle --release --build-number=$BuildNumber --build-name=$VersionName --verbose
    if ($LASTEXITCODE -ne 0) {
        Write-Host "App Bundle build failed!" -ForegroundColor Red
        exit 1
    }
    
    # Generate checksums
    Write-Host "Generating checksums..." -ForegroundColor Yellow
    Set-Location build\app\outputs\flutter-apk\
    sha256sum app-release.apk | Out-File app-release.apk.sha256
    Set-Location ..\..\..\..
    
    Set-Location build\app\outputs\bundle\release\
    sha256sum app-release.aab | Out-File app-release.aab.sha256
    Set-Location ..\..\..\..
    
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Outputs:" -ForegroundColor Cyan
    Write-Host "APK: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
    Write-Host "AAB: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
    Write-Host "APK Checksum: build\app\outputs\flutter-apk\app-release.apk.sha256" -ForegroundColor White
    Write-Host "AAB Checksum: build\app\outputs\bundle\release\app-release.aab.sha256" -ForegroundColor White
    
} catch {
    Write-Host "Build failed with error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Done!" -ForegroundColor Green
