# Test Script for Windows PowerShell
# TuVienTrucLam Flutter Application

param(
    [switch]$SkipCoverage = $false,
    [switch]$SkipFormat = $false,
    [switch]$Help = $false
)

if ($Help) {
    Write-Host "TuVienTrucLam Test Script"
    Write-Host "Usage: .\test.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -SkipCoverage          Skip generating coverage report"
    Write-Host "  -SkipFormat            Skip code formatting check"
    Write-Host "  -Help                  Show this help message"
    exit 0
}

Write-Host "Running Flutter tests and quality checks..." -ForegroundColor Green

$failed = $false

try {
    # Get dependencies
    Write-Host "Getting dependencies..." -ForegroundColor Yellow
    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to get dependencies!" -ForegroundColor Red
        $failed = $true
    }
    
    # Run tests
    Write-Host "Running unit tests..." -ForegroundColor Yellow
    if ($SkipCoverage) {
        flutter test
    } else {
        flutter test --coverage
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Tests failed!" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Host "Tests passed!" -ForegroundColor Green
    }
    
    # Run code analysis
    Write-Host "Analyzing code..." -ForegroundColor Yellow
    flutter analyze --fatal-infos
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Code analysis failed!" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Host "Code analysis passed!" -ForegroundColor Green
    }
    
    # Check code formatting
    if (-not $SkipFormat) {
        Write-Host "Checking code formatting..." -ForegroundColor Yellow
        dart format --set-exit-if-changed .
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Code formatting issues found!" -ForegroundColor Red
            Write-Host "Run 'dart format .' to fix formatting issues." -ForegroundColor Yellow
            $failed = $true
        } else {
            Write-Host "Code formatting is correct!" -ForegroundColor Green
        }
    }
    
    # Security scan
    Write-Host "Running security scan..." -ForegroundColor Yellow
    
    # Check for hardcoded secrets
    Write-Host "  Checking for hardcoded secrets..." -ForegroundColor Cyan
    $secrets = Select-String -Path "lib\*.dart" -Pattern "password|secret|key|token" -ErrorAction SilentlyContinue
    if ($secrets) {
        Write-Host "  Potential secrets found:" -ForegroundColor Yellow
        $secrets | ForEach-Object {
            Write-Host "    $($_.Path):$($_.LineNumber) - $($_.Line.Trim())" -ForegroundColor Gray
        }
    } else {
        Write-Host "  No hardcoded secrets found" -ForegroundColor Green
    }
    
    # Check for insecure HTTP calls
    Write-Host "  Checking for insecure HTTP calls..." -ForegroundColor Cyan
    $httpCalls = Select-String -Path "lib\*.dart" -Pattern "http://" -ErrorAction SilentlyContinue
    if ($httpCalls) {
        Write-Host "  Insecure HTTP calls found:" -ForegroundColor Yellow
        $httpCalls | ForEach-Object {
            Write-Host "    $($_.Path):$($_.LineNumber) - $($_.Line.Trim())" -ForegroundColor Gray
        }
    } else {
        Write-Host "  No insecure HTTP calls found" -ForegroundColor Green
    }
    
    # Summary
    Write-Host ""
    if ($failed) {
        Write-Host "Some tests failed!" -ForegroundColor Red
        exit 1
    } else {
        Write-Host "All tests passed!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Quality Checks Summary:" -ForegroundColor Cyan
        Write-Host "✅ Dependencies resolved" -ForegroundColor Green
        Write-Host "✅ Unit tests passed" -ForegroundColor Green
        Write-Host "✅ Code analysis passed" -ForegroundColor Green
        if (-not $SkipFormat) {
            Write-Host "✅ Code formatting correct" -ForegroundColor Green
        }
        Write-Host "✅ Security scan completed" -ForegroundColor Green
    }
    
} catch {
    Write-Host "Test script failed with error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Done!" -ForegroundColor Green
