class AppConfig {
  // Konfigurasi API URL - bisa diganti sesuai environment
  static const String apiBaseUrl = 'http://localhost:8080';

  // Timeout settings
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Debug settings
  static const bool enableDebugLogs = true;

  // Error messages
  static const String networkErrorMessage =
      'Tidak dapat terhubung ke server. Pastikan backend API berjalan di $apiBaseUrl';
  static const String timeoutErrorMessage =
      'Koneksi timeout. Periksa koneksi internet Anda.';
  static const String serverErrorMessage =
      'Terjadi kesalahan pada server. Silakan coba lagi nanti.';

  // Helper methods
  static bool get isLocalhost =>
      apiBaseUrl.contains('localhost') || apiBaseUrl.contains('127.0.0.1');

  static String get serverStatusMessage {
    if (isLocalhost) {
      return 'Backend API lokal tidak berjalan di $apiBaseUrl\n\n'
          'Pastikan:\n'
          '1. Server backend sudah dijalankan\n'
          '2. Port 8080 tidak diblokir firewall\n'
          '3. URL API sudah benar';
    } else {
      return 'Tidak dapat terhubung ke server di $apiBaseUrl\n\n'
          'Periksa koneksi internet Anda.';
    }
  }
}
