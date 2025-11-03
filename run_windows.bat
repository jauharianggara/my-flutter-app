@echo off
echo ======================================
echo Flutter Windows App Runner (Port 58295)
echo ======================================

echo.
echo Checking for existing app processes...
tasklist | findstr my_flutter_app.exe >nul
if %errorlevel% equ 0 (
    echo Found existing app process. Terminating...
    taskkill /f /im my_flutter_app.exe >nul 2>&1
    timeout /t 2 >nul
    echo Process terminated.
) else (
    echo No existing processes found.
)

echo.
echo Cleaning previous build...
flutter clean

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Starting Flutter Windows app on port 58295...
echo Debug tools will be available at http://localhost:58295
echo.

flutter run -d windows --observatory-port=58295 --enable-software-rendering

echo.
echo App finished.
pause