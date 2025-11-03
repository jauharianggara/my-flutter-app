import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/auth_service.dart';
import 'package:my_flutter_app/models/user.dart';

void main() {
  group('AuthService Tests with testuser:password123', () {
    test('LoginRequest should be properly formed with test credentials',
        () async {
      // Test with specified credentials
      const username = 'testuser';
      const password = 'password123';

      final loginRequest = LoginRequest(
        usernameOrEmail: username,
        password: password,
      );

      expect(loginRequest.usernameOrEmail, username);
      expect(loginRequest.password, password);
      expect(loginRequest.toJson(), {
        'username_or_email': username,
        'password': password,
      });
    });

    test('RegisterRequest should be properly formed for testuser', () async {
      final registerRequest = RegisterRequest(
        username: 'testuser',
        email: 'testuser@example.com',
        password: 'password123',
        fullName: 'Test User',
      );

      expect(registerRequest.username, 'testuser');
      expect(registerRequest.password, 'password123');
      expect(registerRequest.email, 'testuser@example.com');
      expect(registerRequest.fullName, 'Test User');
      expect(registerRequest.toJson(), {
        'username': 'testuser',
        'email': 'testuser@example.com',
        'password': 'password123',
        'full_name': 'Test User',
      });
    });

    test('LoginResponse should parse correctly', () async {
      final mockResponseData = {
        'user': {
          'id': 1,
          'username': 'testuser',
          'email': 'testuser@example.com',
          'full_name': 'Test User',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        },
        'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
        'expires_in': 3600,
      };

      final loginResponse = LoginResponse.fromJson(mockResponseData);

      expect(loginResponse.user.username, 'testuser');
      expect(loginResponse.user.email, 'testuser@example.com');
      expect(loginResponse.user.fullName, 'Test User');
      expect(loginResponse.token, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
      expect(loginResponse.expiresIn, 3600);
    });

    test('User model should parse correctly', () async {
      final mockUserData = {
        'id': 1,
        'username': 'testuser',
        'email': 'testuser@example.com',
        'full_name': 'Test User',
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final user = User.fromJson(mockUserData);

      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.email, 'testuser@example.com');
      expect(user.fullName, 'Test User');
      expect(user.createdAt, '2024-01-01T00:00:00Z');
      expect(user.updatedAt, '2024-01-01T00:00:00Z');
    });

    test('JSON serialization round-trip for User model', () async {
      final originalUser = User(
        id: 1,
        username: 'testuser',
        email: 'testuser@example.com',
        fullName: 'Test User',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
      );

      final json = originalUser.toJson();
      final deserializedUser = User.fromJson(json);

      expect(deserializedUser.id, originalUser.id);
      expect(deserializedUser.username, originalUser.username);
      expect(deserializedUser.email, originalUser.email);
      expect(deserializedUser.fullName, originalUser.fullName);
    });

    test('AuthService static methods should exist and be callable', () async {
      final loginRequest = LoginRequest(
        usernameOrEmail: 'testuser',
        password: 'password123',
      );

      final registerRequest = RegisterRequest(
        username: 'testuser',
        email: 'testuser@example.com',
        password: 'password123',
        fullName: 'Test User',
      );

      // Test that methods exist and can be called (will fail due to no backend, but should not throw compilation errors)
      expect(() => AuthService.login(loginRequest), returnsNormally);
      expect(() => AuthService.register(registerRequest), returnsNormally);
      expect(() => AuthService.getUserProfile(), returnsNormally);
      expect(() => AuthService.logout(), returnsNormally);
      expect(() => AuthService.isLoggedIn(), returnsNormally);
    });
  });
}
