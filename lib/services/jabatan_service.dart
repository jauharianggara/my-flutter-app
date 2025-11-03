import '../models/jabatan.dart';
import '../models/api_response.dart';
import 'api_service.dart';

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

  static Future<ApiResponse<Jabatan>> getJabatanById(int id) async {
    try {
      final response = await ApiService.get('${ApiService.jabatansEndpoint}/$id');
      return ApiService.handleResponse<Jabatan>(
        response,
        (json) => Jabatan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Jabatan>(
        success: false,
        message: 'Failed to get jabatan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Jabatan>> createJabatan(CreateJabatanRequest request) async {
    try {
      final response = await ApiService.post(
        ApiService.jabatansEndpoint,
        request.toJson(),
      );
      return ApiService.handleResponse<Jabatan>(
        response,
        (json) => Jabatan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Jabatan>(
        success: false,
        message: 'Failed to create jabatan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Jabatan>> updateJabatan(int id, UpdateJabatanRequest request) async {
    try {
      final response = await ApiService.put(
        '${ApiService.jabatansEndpoint}/$id',
        request.toJson(),
      );
      return ApiService.handleResponse<Jabatan>(
        response,
        (json) => Jabatan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Jabatan>(
        success: false,
        message: 'Failed to update jabatan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<void>> deleteJabatan(int id) async {
    try {
      final response = await ApiService.delete('${ApiService.jabatansEndpoint}/$id');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<void>(
          success: true,
          message: 'Jabatan deleted successfully',
        );
      } else {
        return ApiResponse<void>(
          success: false,
          message: 'Failed to delete jabatan',
          errors: ['HTTP ${response.statusCode}'],
        );
      }
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to delete jabatan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }
}