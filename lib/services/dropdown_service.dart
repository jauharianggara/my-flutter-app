import '../models/api_response.dart';
import 'api_service.dart';

// Model for Kantor
class Kantor {
  final int id;
  final String nama;

  Kantor({required this.id, required this.nama});

  factory Kantor.fromJson(Map<String, dynamic> json) {
    return Kantor(
      id: json['id'],
      nama: json['nama_kantor'] ?? json['nama'] ?? '', // Handle both field names
    );
  }
}

// Model for Jabatan
class Jabatan {
  final int id;
  final String nama;

  Jabatan({required this.id, required this.nama});

  factory Jabatan.fromJson(Map<String, dynamic> json) {
    return Jabatan(
      id: json['id'],
      nama: json['nama_jabatan'] ?? json['nama'] ?? '', // Handle both field names
    );
  }
}

class KantorService {
  static Future<ApiResponse<List<Kantor>>> getAllKantors() async {
    try {
      final response = await ApiService.get(ApiService.kantorsEndpoint);
      return ApiService.handleListResponse<Kantor>(
        response,
        (json) => Kantor.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<List<Kantor>>(
        success: false,
        message: 'Failed to get kantors: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }
}

class JabatanService {
  static Future<ApiResponse<List<Jabatan>>> getAllJabatans() async {
    try {
      final response = await ApiService.get(ApiService.jabatansEndpoint);
      return ApiService.handleListResponse<Jabatan>(
        response,
        (json) => Jabatan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<List<Jabatan>>(
        success: false,
        message: 'Failed to get jabatans: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }
}
