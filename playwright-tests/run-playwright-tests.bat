@echo off
echo Installing Playwright and running Employee Management tests...
echo.

echo Step 1: Installing Node.js dependencies...
npm install
if %errorlevel% neq 0 (
    echo Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Step 2: Installing Playwright browsers...
npx playwright install
if %errorlevel% neq 0 (
    echo Failed to install Playwright browsers
    pause
    exit /b 1
)

echo.
echo Step 3: Checking Flutter app is running...
curl -s http://localhost:58295 > nul
if %errorlevel% neq 0 (
    echo WARNING: Flutter app not running on port 58295
    echo Please start the Flutter app first with: flutter run -d chrome --web-port=58295
    echo.
)

echo.
echo Step 4: Running Playwright tests...
npx playwright test
if %errorlevel% neq 0 (
    echo Tests failed
    pause
    exit /b 1
)

echo.
echo Step 5: Opening test report...
npx playwright show-report

echo.
echo Playwright testing complete!
echo Compare with Flutter tests by running: flutter test (in parent directory)
pause