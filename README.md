# Employee Management Flutter App

[![CI/CD Pipeline](https://github.com/jauharianggara/my-flutter-app/actions/workflows/ci.yml/badge.svg)](https://github.com/jauharianggara/my-flutter-app/actions/workflows/ci.yml)
[![Code Quality](https://github.com/jauharianggara/my-flutter-app/actions/workflows/quality.yml/badge.svg)](https://github.com/jauharianggara/my-flutter-app/actions/workflows/quality.yml)
[![Deploy to GitHub Pages](https://github.com/jauharianggara/my-flutter-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/jauharianggara/my-flutter-app/actions/workflows/deploy.yml)
[![codecov](https://codecov.io/gh/jauharianggara/my-flutter-app/branch/main/graph/badge.svg)](https://codecov.io/gh/jauharianggara/my-flutter-app)

Aplikasi mobile Flutter untuk sistem manajemen karyawan dan kantor dengan fitur
autentikasi JWT yang terintegrasi dengan API backend.

## Features

### 🔐 Authentication

- Login dengan username/email dan password
- Registrasi user baru
- JWT token authentication
- Auto-logout saat token expired
- Splash screen dengan check status login

### 👥 Employee Management (Karyawan)

- List semua karyawan dengan informasi kantor
- Detail karyawan dengan foto
- Search dan filter karyawan
- CRUD operations (Create, Read, Update, Delete)
- Upload foto karyawan
- Auto-create user account saat create karyawan

### 🏢 Office Management (Kantor)

- Daftar kantor dengan alamat dan koordinat
- CRUD operations untuk kantor
- Integrasi dengan data karyawan

### 💼 Job Position Management (Jabatan)

- Manajemen posisi/jabatan
- CRUD operations untuk jabatan
- Required field untuk karyawan

### 🔒 Security Features

- Rate limiting protection
- CORS protection
- Input validation dan sanitization
- XSS protection
- SQL injection prevention
- Secure headers

## Tech Stack

### Frontend (Flutter)

- **Flutter SDK**: Cross-platform mobile development
- **Provider**: State management
- **HTTP**: API communication
- **Shared Preferences**: Local storage for JWT tokens
- **JSON Annotation**: Model serialization
- **Image Picker**: Photo upload functionality
- **Cached Network Image**: Efficient image loading

### Backend API Integration

- **Base URL**: `http://localhost:8080` (configurable)
- **Authentication**: JWT Bearer tokens
- **File Upload**: Multipart form data for photos
- **Error Handling**: Comprehensive error responses

## Project Structure

```
lib/
├── models/           # Data models with JSON serialization
│   ├── user.dart
│   ├── karyawan.dart
│   ├── kantor.dart
│   ├── jabatan.dart
│   └── api_response.dart
├── services/         # API service classes
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── karyawan_service.dart
│   ├── kantor_service.dart
│   └── jabatan_service.dart
├── providers/        # State management with Provider
│   ├── auth_provider.dart
│   ├── karyawan_provider.dart
│   ├── kantor_provider.dart
│   └── jabatan_provider.dart
├── screens/          # UI screens organized by feature
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── splash_screen.dart
│   ├── karyawan/
│   │   ├── karyawan_list_screen.dart
│   │   ├── create_karyawan_screen.dart
│   │   └── edit_karyawan_screen.dart
│   ├── kantor/
│   │   ├── kantor_list_screen.dart
│   │   ├── create_kantor_screen.dart
│   │   └── edit_kantor_screen.dart
│   ├── jabatan/
│   │   ├── jabatan_list_screen.dart
│   │   ├── create_jabatan_screen.dart
│   │   └── edit_jabatan_screen.dart
│   └── home_screen.dart
├── widgets/          # Reusable UI components
├── utils/            # Utility functions
└── config/           # Configuration files
```

## Getting Started

### Prerequisites

- Flutter SDK (3.5.3 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extension
- Backend API server running on `http://localhost:8080`

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd my-flutter-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure API endpoint** Update `baseUrl` in
   `lib/services/api_service.dart` if needed:
   ```dart
   static const String baseUrl = 'http://your-api-server:8080';
   ```

### Running the App

#### Using VS Code

1. Open the project in VS Code
2. Press `Ctrl+Shift+P` and select "Tasks: Run Task"
3. Choose one of:
   - "Flutter Run" - Run on default device
   - "Flutter Run (Windows - Port 58295)" - Run on Windows with specific debug
     port

#### Using Terminal

```bash
# Default run
flutter run

# Run on Windows with specific debug port
flutter run -d windows --observatory-port=58295

# Or use the batch script
run_windows.bat
```

#### Using Debug Configuration

1. Go to Debug panel in VS Code (Ctrl+Shift+D)
2. Select "Flutter (Windows - Port 58295)" configuration
3. Press F5 to start debugging

#### For Web

```bash
flutter run -d chrome
```

#### For specific device

```bash
flutter devices          # List available devices
flutter run -d device-id # Run on specific device
```

### Building for Production

#### Android APK

```bash
flutter build apk --release
```

#### Android App Bundle

```bash
flutter build appbundle --release
```

#### iOS

```bash
flutter build ios --release
```

## API Configuration

The app expects a backend API with the following endpoints:

### Authentication

- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/user/me` - Get current user profile

### Karyawan (Employee)

- `GET /api/karyawans` - Get all employees
- `GET /api/karyawans/with-kantor` - Get employees with office info
- `POST /api/karyawans` - Create new employee
- `GET /api/karyawans/{id}` - Get employee by ID
- `PUT /api/karyawans/{id}` - Update employee
- `DELETE /api/karyawans/{id}` - Delete employee
- `POST /api/karyawans/{id}/photo` - Upload employee photo

### Kantor (Office)

- `GET /api/kantors` - Get all offices
- `POST /api/kantors` - Create new office
- `GET /api/kantors/{id}` - Get office by ID
- `PUT /api/kantors/{id}` - Update office
- `DELETE /api/kantors/{id}` - Delete office

### Jabatan (Job Position)

- `GET /api/jabatans` - Get all job positions
- `POST /api/jabatans` - Create new job position
- `GET /api/jabatans/{id}` - Get job position by ID
- `PUT /api/jabatans/{id}` - Update job position
- `DELETE /api/jabatans/{id}` - Delete job position

## Development

### Adding New Features

1. Create models in `lib/models/`
2. Create services in `lib/services/`
3. Create providers in `lib/providers/`
4. Create screens in `lib/screens/`
5. Update `main.dart` to include new providers

### Code Generation

When updating models, run:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
flutter test
```

### Static Analysis

```bash
flutter analyze
```

## Screenshots

### Authentication Flow

- Splash Screen dengan auto-login check
- Login screen dengan validasi
- Register screen dengan form lengkap

### Main Features

- Dashboard dengan menu utama
- Employee list dengan search dan filter
- Employee detail dengan foto
- Profile management

## Security Notes

- JWT tokens disimpan secara aman di SharedPreferences
- Input validation di semua form
- Error handling yang comprehensive
- HTTPS untuk production (update baseUrl)

## Troubleshooting

### Common Issues

1. **Build errors after adding dependencies**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Network errors**
   - Pastikan backend API berjalan
   - Check URL di `api_service.dart`
   - Untuk Android emulator, gunakan `10.0.2.2` instead of `localhost`

3. **JSON serialization errors**
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Windows: "cannot open .exe for writing" error** This happens when the app
   process is still running:
   ```bash
   # Kill existing process
   taskkill /f /im my_flutter_app.exe

   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter run -d windows --observatory-port=58295 --enable-software-rendering
   ```

   Or use the automated scripts:
   ```bash
   # Quick fix
   run_windows.bat

   # Complete troubleshooting
   troubleshoot_windows.bat
   ```

5. **VS Code Task Issues** Use these VS Code tasks for better Windows
   development:
   - "Flutter Run (Windows - Port 58295)" - Standard run
   - "Flutter Clean & Run (Windows - Port 58295)" - Clean + run
   - "Kill Flutter App Process" - Force kill hanging processes

6. **Debug Connection Issues** If debug tools don't connect properly:
   ```bash
   # Try with software rendering
   flutter run -d windows --observatory-port=58295 --enable-software-rendering

   # Or use verbose output to debug
   flutter run -d windows --observatory-port=58295 --verbose
   ```

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for
details.
