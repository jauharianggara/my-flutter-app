import '../models/kantor.dart';
import '../models/api_response.dart';
import 'api_service.dart';

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

  static Future<ApiResponse<Kantor>> getKantorById(int id) async {
    try {
      final response =
          await ApiService.get('${ApiService.kantorsEndpoint}/$id');
      return ApiService.handleResponse<Kantor>(
        response,
        (json) => Kantor.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Kantor>(
        success: false,
        message: 'Failed to get kantor: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Kantor>> createKantor(
      CreateKantorRequest request) async {
    try {
      final response = await ApiService.post(
        ApiService.kantorsEndpoint,
        request.toJson(),
      );
      return ApiService.handleResponse<Kantor>(
        response,
        (json) => Kantor.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Kantor>(
        success: false,
        message: 'Failed to create kantor: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Kantor>> updateKantor(
      int id, UpdateKantorRequest request) async {
    try {
      final response = await ApiService.put(
        '${ApiService.kantorsEndpoint}/$id',
        request.toJson(),
      );
      return ApiService.handleResponse<Kantor>(
        response,
        (json) => Kantor.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Kantor>(
        success: false,
        message: 'Failed to update kantor: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<void>> deleteKantor(int id) async {
    try {
      final response =
          await ApiService.delete('${ApiService.kantorsEndpoint}/$id');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<void>(
          success: true,
          message: 'Kantor deleted successfully',
        );
      } else {
        return ApiResponse<void>(
          success: false,
          message: 'Failed to delete kantor',
          errors: ['HTTP ${response.statusCode}'],
        );
      }
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to delete kantor: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }
}
