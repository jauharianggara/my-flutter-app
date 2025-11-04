import 'dart:convert';
import '../models/user.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class AuthService {
  static Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await ApiService.post(
        ApiService.loginEndpoint,
        request.toJson(),
        requireAuth: false,
      );

      // Custom parsing for login response because backend structure is different
      final body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'] as Map<String, dynamic>;

          // Extract nested data and create LoginResponse
          final loginResponse = LoginResponse(
            user: User.fromJson(data['user'] as Map<String, dynamic>),
            token: data['token'] as String,
            expiresIn: data['expires_in'] as int,
          );

          return ApiResponse<LoginResponse>(
            success: true,
            message: jsonData['message'] ?? 'Login successful',
            data: loginResponse,
            // Handle null errors properly
            errors: jsonData['errors'] != null
                ? List<String>.from(jsonData['errors'])
                : null,
          );
        } else {
          return ApiResponse<LoginResponse>(
            success: false,
            message: jsonData['message'] ?? 'Login failed',
            // Handle null errors properly
            errors: jsonData['errors'] != null
                ? List<String>.from(jsonData['errors'])
                : ['Login failed'],
          );
        }
      } else {
        return ApiResponse<LoginResponse>(
          success: false,
          message: jsonData['message'] ?? 'Login failed',
          // Handle null errors properly
          errors: jsonData['errors'] != null
              ? List<String>.from(jsonData['errors'])
              : ['Login failed'],
        );
      }
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Login failed: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<User>> register(RegisterRequest request) async {
    try {
      final response = await ApiService.post(
        ApiService.registerEndpoint,
        request.toJson(),
        requireAuth: false,
      );

      return ApiService.handleResponse<User>(
        response,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Registration failed: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<ApiResponse<User>> getUserProfile() async {
    try {
      final response = await ApiService.get(ApiService.userProfileEndpoint);

      return ApiService.handleResponse<User>(
        response,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to get user profile: ${e.toString()}',
        errors: ['Network error'],
      );
    }
  }

  static Future<void> logout() async {
    await ApiService.removeToken();
  }

  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}
