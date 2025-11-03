# Flutter Windows Fix & Run Script
# PowerShell script to fix and run Flutter Windows app

param(
    [switch]$Force,
    [string]$Port = "58295"
)

Write-Host "======================================"
Write-Host "Flutter Windows Fix & Run Script"
Write-Host "======================================"
Write-Host ""

function Stop-ProcessSafely {
    param([string]$ProcessName)
    
    $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "Terminating $ProcessName processes..."
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "$ProcessName processes terminated."
    }
    else {
        Write-Host "No $ProcessName processes found."
    }
}

try {
    # Step 1: Kill all related processes
    Write-Host "Step 1: Cleaning up processes..."
    Stop-ProcessSafely "my_flutter_app"
    Stop-ProcessSafely "dart"
    Stop-ProcessSafely "flutter"
    
    # Step 2: Remove build directory
    Write-Host "Step 2: Removing build directory..."
    if (Test-Path "build") {
        Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Build directory removed."
    }
    
    # Step 3: Clean Flutter
    Write-Host "Step 3: Running flutter clean..."
    & flutter clean
    Write-Host "Flutter clean completed."
    
    # Step 4: Get dependencies
    Write-Host "Step 4: Getting dependencies..."
    & flutter pub get
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get dependencies"
    }
    Write-Host "Dependencies installed."
    
    # Step 5: Check devices
    Write-Host "Step 5: Checking available devices..."
    & flutter devices
    
    # Step 6: Run the app
    Write-Host "Step 6: Running Flutter app on port $Port..."
    Write-Host "Debug tools will be available at http://localhost:$Port"
    Write-Host "Press Ctrl+C to stop the app"
    Write-Host ""
    
    # Build run arguments
    $runArgs = @(
        "run",
        "-d", "windows",
        "--observatory-port=$Port"
    )
    
    if ($Force) {
        $runArgs += "--enable-software-rendering"
    }
    
    & flutter @runArgs
    
}
catch {
    Write-Host "Error occurred: $($_.Exception.Message)"
    
    # Final cleanup
    Write-Host "Final cleanup..."
    Stop-ProcessSafely "my_flutter_app"
    
    Write-Host ""
    Write-Host "Try running with -Force flag:"
    Write-Host "   .\fix_and_run_windows.ps1 -Force"
    
    exit 1
}

Write-Host ""
Write-Host "Script completed."