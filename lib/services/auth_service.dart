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

      return ApiService.handleResponse<LoginResponse>(
        response,
        (json) => LoginResponse.fromJson(json),
      );
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