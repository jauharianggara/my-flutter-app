class AppConfig {
  // Konfigurasi aplikasi
  static const bool useOfflineMode =
      true; // Set true untuk menggunakan demo data offline
  static const String apiBaseUrl = 'http://localhost:8080';
  static const bool showDebugLogs = true;

  // Mode aplikasi
  static const String appMode = useOfflineMode ? 'OFFLINE' : 'ONLINE';

  // Pesan untuk user
  static String get modeMessage {
    if (useOfflineMode) {
      return 'Aplikasi berjalan dalam mode DEMO/OFFLINE. Data yang ditampilkan adalah data contoh.';
    } else {
      return 'Aplikasi terhubung dengan server API.';
    }
  }

  // Helper method untuk mengecek koneksi
  static bool get isOfflineMode => useOfflineMode;
  static bool get isOnlineMode => !useOfflineMode;
}
