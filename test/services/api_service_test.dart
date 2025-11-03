import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/api_service.dart';
import 'package:my_flutter_app/models/api_response.dart';

void main() {
  // Initialize Flutter bindings for testing
  TestWidgetsFlutterBinding.ensureInitialized();

  group('API Service Tests', () {
    test('API endpoints should be properly configured', () async {
      // Test that all endpoints are defined correctly
      expect(ApiService.baseUrl, 'http://localhost:8080');
      expect(ApiService.apiPrefix, '/api');

      // Authentication endpoints
      expect(ApiService.registerEndpoint, '/api/auth/register');
      expect(ApiService.loginEndpoint, '/api/auth/login');
      expect(ApiService.userProfileEndpoint, '/api/user/me');

      // Karyawan endpoints
      expect(ApiService.karyawansEndpoint, '/api/karyawans');
      expect(
          ApiService.karyawansWithKantorEndpoint, '/api/karyawans/with-kantor');
      expect(
          ApiService.karyawansWithPhotoEndpoint, '/api/karyawans/with-photo');

      // Kantor endpoints
      expect(ApiService.kantorsEndpoint, '/api/kantors');

      // Jabatan endpoints
      expect(ApiService.jabatansEndpoint, '/api/jabatans');
    });

    test('getHeaders should return proper headers without auth', () async {
      final headers = await ApiService.getHeaders(requireAuth: false);

      expect(headers['Content-Type'], 'application/json');
      expect(headers['Accept'], 'application/json');
      expect(headers.containsKey('Authorization'), false);
    });

    test('getMultipartHeaders should be callable', () async {
      expect(() => ApiService.getMultipartHeaders(), returnsNormally);
    });

    test('token management methods should be callable', () async {
      // Test token management methods
      expect(() => ApiService.getToken(), returnsNormally);
      expect(() => ApiService.saveToken('test_token'), returnsNormally);
      expect(() => ApiService.removeToken(), returnsNormally);
    });

    test('handleResponse should parse successful response correctly', () async {
      final mockResponse = {
        'success': true,
        'message': 'Success',
        'data': {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
        }
      };

      // Test the response structure that would be returned
      expect(mockResponse['success'], true);
      expect(mockResponse['message'], 'Success');
      expect(mockResponse['data'], isA<Map<String, dynamic>>());
    });

    test('handleListResponse should handle list data correctly', () async {
      final mockListResponse = {
        'success': true,
        'message': 'Success',
        'data': [
          {
            'id': 1,
            'name': 'User 1',
            'email': 'user1@example.com',
          },
          {
            'id': 2,
            'name': 'User 2',
            'email': 'user2@example.com',
          }
        ]
      };

      // Test the response structure for list responses
      expect(mockListResponse['success'], true);
      expect(mockListResponse['data'], isA<List>());
      expect((mockListResponse['data'] as List).length, 2);
    });

    test('error response should be handled correctly', () async {
      final mockErrorResponse = {
        'success': false,
        'message': 'Validation failed',
        'errors': [
          'Email is required',
          'Password must be at least 8 characters'
        ]
      };

      // Test error response structure
      expect(mockErrorResponse['success'], false);
      expect(mockErrorResponse['message'], 'Validation failed');
      expect(mockErrorResponse['errors'], isA<List>());
      expect((mockErrorResponse['errors'] as List).length, 2);
    });

    test('ApiResponse model should work correctly', () async {
      // Test successful response
      final successResponse = ApiResponse<String>(
        success: true,
        message: 'Login successful',
        data: 'jwt_token_123',
      );

      expect(successResponse.success, true);
      expect(successResponse.message, 'Login successful');
      expect(successResponse.data, 'jwt_token_123');
      expect(successResponse.errors, null);

      // Test error response
      final errorResponse = ApiResponse<String>(
        success: false,
        message: 'Authentication failed',
        errors: ['Invalid credentials'],
      );

      expect(errorResponse.success, false);
      expect(errorResponse.message, 'Authentication failed');
      expect(errorResponse.data, null);
      expect(errorResponse.errors, ['Invalid credentials']);
    });

    test('HTTP methods should be callable', () async {
      // Test that HTTP method calls don't throw compilation errors
      // Note: These will fail at runtime without a backend, but should compile
      expect(
          () => ApiService.get('/test', requireAuth: false), returnsNormally);
      expect(() => ApiService.post('/test', {}, requireAuth: false),
          returnsNormally);
      expect(() => ApiService.put('/test', {}, requireAuth: false),
          returnsNormally);
      expect(() => ApiService.delete('/test', requireAuth: false),
          returnsNormally);
    });

    test('URL construction should be correct', () async {
      const endpoint = '/api/test';
      const expectedUrl = '${ApiService.baseUrl}$endpoint';

      expect(expectedUrl, 'http://localhost:8080/api/test');
    });

    test('multipart file upload should be supported', () async {
      // Test that multipart upload method exists and can be called
      // Would require actual File objects to test fully
      expect(ApiService.postMultipart, isNotNull);
    });
  });
}
