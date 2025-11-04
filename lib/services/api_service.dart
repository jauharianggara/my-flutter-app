import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost:8080'; // Change this to your API URL
  static const String apiPrefix = '/api';

  // Authentication endpoints
  static const String registerEndpoint = '$apiPrefix/auth/register';
  static const String loginEndpoint = '$apiPrefix/auth/login';
  static const String userProfileEndpoint = '$apiPrefix/user/me';

  // Karyawan endpoints
  static const String karyawansEndpoint = '$apiPrefix/karyawans';
  static const String karyawansWithKantorEndpoint =
      '$apiPrefix/karyawans/with-kantor';
  static const String karyawansWithPhotoEndpoint =
      '$apiPrefix/karyawans/with-photo';

  // Kantor endpoints
  static const String kantorsEndpoint = '$apiPrefix/kantors';

  // Jabatan endpoints
  static const String jabatansEndpoint = '$apiPrefix/jabatans';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> getHeaders(
      {bool requireAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Future<Map<String, String>> getMultipartHeaders() async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    final token = await getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<ApiResponse<T>> handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.fromJson(
            jsonData, (data) => fromJson(data as Map<String, dynamic>));
      } else {
        return ApiResponse<T>(
          success: false,
          message: jsonData['message'] ?? 'An error occurred',
          errors: jsonData['errors'] != null
              ? List<String>.from(jsonData['errors'])
              : null,
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        errors: ['Failed to parse response'],
      );
    }
  }

  static Future<ApiResponse<List<T>>> handleListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonData['data'] is List) {
          final List<T> items = (jsonData['data'] as List)
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();

          return ApiResponse<List<T>>(
            success: jsonData['success'] ?? true,
            message: jsonData['message'] ?? '',
            data: items,
            // Handle null errors properly
            errors: jsonData['errors'] != null 
                ? List<String>.from(jsonData['errors'])
                : null,
          );
        } else {
          return ApiResponse<List<T>>(
            success: false,
            message: 'Invalid response format',
            errors: ['Expected list data'],
          );
        }
      } else {
        return ApiResponse<List<T>>(
          success: false,
          message: jsonData['message'] ?? 'An error occurred',
          errors: jsonData['errors'] != null
              ? List<String>.from(jsonData['errors'])
              : null,
        );
      }
    } catch (e) {
      return ApiResponse<List<T>>(
        success: false,
        message: 'Network error: ${e.toString()}',
        errors: ['Failed to parse response'],
      );
    }
  }

  static Future<http.Response> get(String endpoint,
      {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders(requireAuth: requireAuth);

    print('=== API GET Request ===');
    print('URL: $url');
    print('Headers: $headers');

    try {
      final response = await http.get(url, headers: headers);

      print('=== API GET Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('=== API GET Error ===');
      print('Error: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders(requireAuth: requireAuth);

    print('=== API POST Request ===');
    print('URL: $url');
    print('Headers: $headers');
    print('Body: ${json.encode(body)}');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      print('=== API POST Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('=== API POST Error ===');
      print('Error: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body,
      {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders(requireAuth: requireAuth);

    try {
      return await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> delete(String endpoint,
      {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders(requireAuth: requireAuth);

    try {
      return await http.delete(url, headers: headers);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.StreamedResponse> postMultipart(
    String endpoint,
    Map<String, String> fields,
    Map<String, File> files,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getMultipartHeaders();

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      for (final entry in files.entries) {
        request.files.add(await http.MultipartFile.fromPath(
          entry.key,
          entry.value.path,
        ));
      }

      return await request.send();
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
