@echo off
echo =======================================
echo Flutter Windows Troubleshoot & Fix
echo =======================================

echo.
echo 1. Killing any running Flutter app processes...
tasklist | findstr my_flutter_app.exe >nul
if %errorlevel% equ 0 (
    echo Found running processes. Terminating...
    taskkill /f /im my_flutter_app.exe
    timeout /t 3 >nul
) else (
    echo No running processes found.
)

echo.
echo 2. Killing any Flutter daemon processes...
taskkill /f /im dart.exe >nul 2>&1
taskkill /f /im flutter.exe >nul 2>&1

echo.
echo 3. Cleaning Flutter cache and build...
flutter clean
rd /s /q build >nul 2>&1

echo.
echo 4. Getting fresh dependencies...
flutter pub get

echo.
echo 5. Generating code...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo 6. Running Flutter doctor...
flutter doctor

echo.
echo 7. Testing Windows build...
flutter run -d windows --observatory-port=58295 --verbose

pause