- [x] Verify that the copilot-instructions.md file in the .github directory is created.

- [x] Clarify Project Requirements

- [x] Scaffold the Project

- [x] Customize the Project

- [x] Install Required Extensions

- [x] Compile the Project

- [x] Create and Run Task

- [x] Launch the Project

- [x] Ensure Documentation is Complete

# Flutter Employee Management App

This workspace contains a Flutter mobile application for employee and office management with the following features:

## Project Overview
- **Type**: Flutter Mobile Application
- **Purpose**: Employee and Office Management System
- **Backend Integration**: REST API with JWT authentication
- **State Management**: Provider pattern

## Key Features Implemented
- JWT Authentication (Login/Register)
- Employee CRUD operations with photo upload
- Office and Job Position management
- Secure API integration with comprehensive error handling
- Material Design UI with custom theming

## Project Structure
- `lib/models/` - Data models with JSON serialization
- `lib/services/` - API service classes for backend communication
- `lib/providers/` - State management providers
- `lib/screens/` - UI screens and pages
- `lib/widgets/` - Reusable UI components
- `lib/utils/` - Utility functions

## Development Setup
1. Ensure Flutter SDK is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter packages pub run build_runner build` to generate model code
4. Configure API endpoint in `lib/services/api_service.dart`
5. Use VS Code tasks or PowerShell script to launch the app

## Running the App
### Option 1: VS Code Tasks
- Use F5 or Run > Start Debugging
- Or use Command Palette: "Tasks: Run Task" → "Flutter Run (Windows - Port 58295)"

### Option 2: PowerShell Script (Recommended for Windows)
```powershell
.\fix_and_run_windows.ps1
```
This script automatically:
- Cleans up any running Flutter processes
- Removes build cache
- Reinstalls dependencies
- Runs the app on Windows with port 58295

### Debug Tools
- Observatory: http://localhost:58295
- Flutter DevTools will be available when app is running

## Windows-Specific Notes
- First build may take several minutes
- If you encounter process locking issues, use the PowerShell script
- The script includes comprehensive cleanup for smooth rebuilds

## Ready for Development
The project is fully scaffolded and ready for further development. All core features are implemented and the app compiles without errors.