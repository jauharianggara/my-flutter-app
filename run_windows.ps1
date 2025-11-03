# Flutter Windows Runner with Port 58295
# PowerShell script to run Flutter app on Windows with specific debug port

Write-Host "🚀 Starting Flutter Windows app on port 58295..." -ForegroundColor Green
Write-Host "🔧 Debug tools will be available at http://localhost:58295" -ForegroundColor Blue

try {
    # Check if flutter is available
    Write-Host "🔍 Checking Flutter installation..." -ForegroundColor Yellow
    flutter --version
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Flutter not found. Please install Flutter SDK first." -ForegroundColor Red
        exit 1
    }
    
    # Kill any existing my_flutter_app.exe processes
    Write-Host "🧹 Checking for existing app processes..." -ForegroundColor Yellow
    $processes = Get-Process -Name "my_flutter_app" -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "🛑 Found existing app processes. Terminating..." -ForegroundColor Yellow
        $processes | Stop-Process -Force
        Start-Sleep -Seconds 2
        Write-Host "✅ Existing processes terminated." -ForegroundColor Green
    }
    
    # Clean build if needed
    Write-Host "🧹 Cleaning previous build..." -ForegroundColor Yellow
    flutter clean
    
    # Get dependencies
    Write-Host "� Getting dependencies..." -ForegroundColor Yellow
    flutter pub get
    
    Write-Host "�📱 Available devices:" -ForegroundColor Yellow
    flutter devices
    
    Write-Host "`n🏃 Running Flutter app..." -ForegroundColor Green
    flutter run -d windows --observatory-port=58295
    
}
catch {
    Write-Host "❌ Error occurred: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try to kill any hanging processes
    $processes = Get-Process -Name "my_flutter_app" -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "🛑 Cleaning up hanging processes..." -ForegroundColor Yellow
        $processes | Stop-Process -Force
    }
    
    exit 1
}

Write-Host "`n✅ Flutter app finished." -ForegroundColor Green
Read-Host "Press Enter to exit"