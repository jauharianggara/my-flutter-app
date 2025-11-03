#!/usr/bin/env pwsh

# Playwright Test Runner for Employee Management App
# Comparison with Flutter Testing Framework

Write-Host "🎭 Playwright vs Flutter Testing Comparison" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Node.js
Write-Host "📦 Step 1: Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js 18+ first." -ForegroundColor Red
    exit 1
}

# Step 2: Install dependencies
Write-Host ""
Write-Host "📥 Step 2: Installing Playwright dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies installed" -ForegroundColor Green

# Step 3: Install browsers
Write-Host ""
Write-Host "🌐 Step 3: Installing Playwright browsers..." -ForegroundColor Yellow
npx playwright install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install browsers" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Browsers installed" -ForegroundColor Green

# Step 4: Check Flutter app
Write-Host ""
Write-Host "🚀 Step 4: Checking Flutter app status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:58295" -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Flutter app is running on port 58295" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Flutter app not accessible on port 58295" -ForegroundColor Yellow
    Write-Host "   Please start Flutter app with: flutter run -d chrome --web-port=58295" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Continue anyway? (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        exit 1
    }
}

# Step 5: Run tests
Write-Host ""
Write-Host "🧪 Step 5: Running Playwright tests..." -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Cyan

# Show test run options
Write-Host ""
Write-Host "Test Run Options:" -ForegroundColor Cyan
Write-Host "1. Run all tests (headless)" -ForegroundColor White
Write-Host "2. Run tests with browser UI" -ForegroundColor White
Write-Host "3. Run tests with Playwright UI" -ForegroundColor White
Write-Host "4. Debug mode" -ForegroundColor White
Write-Host "5. Skip tests, show existing report" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Choose option (1-5, default: 1)"

switch ($choice) {
    "2" {
        Write-Host "Running tests with browser UI..." -ForegroundColor Green
        npx playwright test --headed
    }
    "3" {
        Write-Host "Opening Playwright UI..." -ForegroundColor Green
        npx playwright test --ui
    }
    "4" {
        Write-Host "Running in debug mode..." -ForegroundColor Green
        npx playwright test --debug
    }
    "5" {
        Write-Host "Opening existing report..." -ForegroundColor Green
        npx playwright show-report
        exit 0
    }
    default {
        Write-Host "Running all tests (headless)..." -ForegroundColor Green
        npx playwright test
    }
}

# Check test results
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ All Playwright tests passed!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Some Playwright tests failed" -ForegroundColor Red
}

# Step 6: Show report
Write-Host ""
Write-Host "📊 Step 6: Opening test report..." -ForegroundColor Yellow
npx playwright show-report

# Comparison summary
Write-Host ""
Write-Host "🔄 COMPARISON SUMMARY" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Playwright Testing:" -ForegroundColor Yellow
Write-Host "  ✅ Real browser environment" -ForegroundColor Green
Write-Host "  ✅ Cross-browser compatibility" -ForegroundColor Green
Write-Host "  ✅ Visual regression testing" -ForegroundColor Green
Write-Host "  ❌ Web-only (no native mobile)" -ForegroundColor Red
Write-Host "  ❌ Slower execution" -ForegroundColor Red
Write-Host "  ❌ Complex setup" -ForegroundColor Red
Write-Host "  ❌ Brittle selectors" -ForegroundColor Red
Write-Host ""
Write-Host "Flutter Testing:" -ForegroundColor Yellow
Write-Host "  ✅ Cross-platform (mobile, web, desktop)" -ForegroundColor Green
Write-Host "  ✅ Fast execution" -ForegroundColor Green
Write-Host "  ✅ Simple setup" -ForegroundColor Green
Write-Host "  ✅ Reliable widget-based testing" -ForegroundColor Green
Write-Host "  ✅ Direct state access" -ForegroundColor Green
Write-Host "  ✅ Type safety with Dart" -ForegroundColor Green
Write-Host ""
Write-Host "🏆 WINNER: Flutter Testing Framework" -ForegroundColor Green
Write-Host "   Superior for cross-platform applications" -ForegroundColor Green
Write-Host ""
Write-Host "To compare, run Flutter tests:" -ForegroundColor Cyan
Write-Host "   cd .." -ForegroundColor White
Write-Host "   flutter test" -ForegroundColor White
Write-Host ""
Write-Host "Comparison complete! 🎉" -ForegroundColor Green