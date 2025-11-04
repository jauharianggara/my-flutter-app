import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is SocketException) {
      return AppConfig.networkErrorMessage;
    } else if (error is http.ClientException) {
      if (error.message.contains('Failed to fetch') ||
          error.message.contains('Connection refused') ||
          error.message.contains('Network is unreachable')) {
        return AppConfig.networkErrorMessage;
      }
      return 'Kesalahan koneksi: ${error.message}';
    } else if (error.toString().contains('TimeoutException')) {
      return AppConfig.timeoutErrorMessage;
    } else if (error.toString().contains('FormatException')) {
      return 'Format respon server tidak valid';
    } else {
      return 'Terjadi kesalahan: ${error.toString()}';
    }
  }

  static String handleHttpError(int statusCode, String? responseBody) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid (400)';
      case 401:
        return 'Tidak terotorisasi. Silakan login ulang (401)';
      case 403:
        return 'Akses ditolak (403)';
      case 404:
        return 'Endpoint tidak ditemukan (404)';
      case 500:
        return 'Kesalahan server internal (500)';
      case 502:
        return 'Bad Gateway (502)';
      case 503:
        return 'Layanan tidak tersedia (503)';
      default:
        return 'Kesalahan HTTP: $statusCode';
    }
  }

  static bool isNetworkError(dynamic error) {
    return error is SocketException ||
        (error is http.ClientException &&
            (error.message.contains('Failed to fetch') ||
                error.message.contains('Connection refused') ||
                error.message.contains('Network is unreachable')));
  }
}
