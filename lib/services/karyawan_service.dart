import 'dart:io';
import '../models/karyawan.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class KaryawanService {
  static Future<ApiResponse<List<Karyawan>>> getAllKaryawans() async {
    try {
      final response = await ApiService.get(ApiService.karyawansEndpoint);
      return ApiService.handleListResponse<Karyawan>(
        response,
        (json) => Karyawan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<List<Karyawan>>(
        success: false,
        message: 'Failed to get karyawans: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<List<KaryawanWithKantor>>>
      getAllKaryawansWithKantor() async {
    try {
      final response =
          await ApiService.get(ApiService.karyawansWithKantorEndpoint);
      return ApiService.handleListResponse<KaryawanWithKantor>(
        response,
        (json) => KaryawanWithKantor.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<List<KaryawanWithKantor>>(
        success: false,
        message: 'Failed to get karyawans with kantor: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Karyawan>> getKaryawanById(int id) async {
    try {
      final response =
          await ApiService.get('${ApiService.karyawansEndpoint}/$id');
      return ApiService.handleResponse<Karyawan>(
        response,
        (json) => Karyawan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Karyawan>(
        success: false,
        message: 'Failed to get karyawan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<KaryawanWithKantor>> getKaryawanWithKantorById(
      int id) async {
    try {
      final response = await ApiService.get(
          '${ApiService.karyawansEndpoint}/$id/with-kantor');
      return ApiService.handleResponse<KaryawanWithKantor>(
        response,
        (json) => KaryawanWithKantor.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<KaryawanWithKantor>(
        success: false,
        message: 'Failed to get karyawan with kantor: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Karyawan>> createKaryawan(
      CreateKaryawanRequest request) async {
    try {
      final response = await ApiService.post(
        ApiService.karyawansEndpoint,
        request.toJson(),
      );
      return ApiService.handleResponse<Karyawan>(
        response,
        (json) => Karyawan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Karyawan>(
        success: false,
        message: 'Failed to create karyawan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Karyawan>> createKaryawanWithPhoto(
    CreateKaryawanRequest request,
    File photo,
  ) async {
    try {
      final fields =
          request.toJson().map((key, value) => MapEntry(key, value.toString()));
      final files = {'foto': photo};

      final streamedResponse = await ApiService.postMultipart(
        ApiService.karyawansWithPhotoEndpoint,
        fields,
        files,
      );

      final responseBody = await streamedResponse.stream.bytesToString();

      // Convert StreamedResponse to Response for handling
      final httpResponseObj = Response(
        responseBody,
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
      );

      return ApiService.handleResponse<Karyawan>(
        httpResponseObj as dynamic,
        (json) => Karyawan.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<Karyawan>(
        success: false,
        message: 'Failed to create karyawan with photo: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<Karyawan>> updateKaryawan(
      int id, UpdateKaryawanRequest request) async {
    try {
      print('DEBUG: Update Karyawan Request:');
      print('DEBUG: ID: $id');
      print('DEBUG: Request JSON: ${request.toJson()}');

      final response = await ApiService.put(
        '${ApiService.karyawansEndpoint}/$id',
        request.toJson(),
      );
      return ApiService.handleResponse<Karyawan>(
        response,
        (json) => Karyawan.fromJson(json),
      );
    } catch (e) {
      print('DEBUG: Update Karyawan Error: $e');
      return ApiResponse<Karyawan>(
        success: false,
        message: 'Failed to update karyawan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<void>> deleteKaryawan(int id) async {
    try {
      final response =
          await ApiService.delete('${ApiService.karyawansEndpoint}/$id');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<void>(
          success: true,
          message: 'Karyawan deleted successfully',
        );
      } else {
        return ApiResponse<void>(
          success: false,
          message: 'Failed to delete karyawan',
          errors: ['HTTP ${response.statusCode}'],
        );
      }
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to delete karyawan: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<void>> uploadKaryawanPhoto(
      int id, File photo) async {
    try {
      final files = {'foto': photo};

      final streamedResponse = await ApiService.postMultipart(
        '${ApiService.karyawansEndpoint}/$id/photo',
        {},
        files,
      );

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        return ApiResponse<void>(
          success: true,
          message: 'Photo uploaded successfully',
        );
      } else {
        return ApiResponse<void>(
          success: false,
          message: 'Failed to upload photo',
          errors: ['HTTP ${streamedResponse.statusCode}'],
        );
      }
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to upload photo: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<void>> deleteKaryawanPhoto(int id) async {
    try {
      final response =
          await ApiService.delete('${ApiService.karyawansEndpoint}/$id/photo');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<void>(
          success: true,
          message: 'Photo deleted successfully',
        );
      } else {
        return ApiResponse<void>(
          success: false,
          message: 'Failed to delete photo',
          errors: ['HTTP ${response.statusCode}'],
        );
      }
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to delete photo: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }
}

// Helper class to convert StreamedResponse to Response
class Response {
  final String body;
  final int statusCode;
  final Map<String, String> headers;

  Response(this.body, this.statusCode, {this.headers = const {}});
}
