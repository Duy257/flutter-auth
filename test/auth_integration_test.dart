import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/auth_models.dart';
import 'package:flutter_application_1/services/backend_service.dart';
import 'package:flutter_application_1/config/env_config.dart';

void main() {
  setUpAll(() async {
    // Initialize environment config for tests
    await EnvConfig.initialize();
    // Initialize the backend service for tests
    BackendService.initialize();
  });
  group('Auth Models Tests', () {
    test('OAuthResponse should parse JSON correctly', () {
      final json = {
        'message': 'OAuth login successful',
        'user': {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'avatar': 'https://example.com/avatar.jpg',
          'role': 'user',
        },
        'token': 'jwt_token_123',
        'exp': 1755368420,
      };

      final response = OAuthResponse.fromJson(json);

      expect(response.message, 'OAuth login successful');
      expect(response.user.id, '123');
      expect(response.user.name, 'John Doe');
      expect(response.user.email, 'john@example.com');
      expect(response.user.avatar, 'https://example.com/avatar.jpg');
      expect(response.user.role, 'user');
      expect(response.token, 'jwt_token_123');
      expect(response.exp, 1755368420);
    });

    test('UserInfo should handle missing avatar', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'admin',
      };

      final user = UserInfo.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.avatar, null);
      expect(user.role, 'admin');
    });

    test('OAuthRequest should serialize to JSON correctly', () {
      final request = OAuthRequest(
        tokenId: 'google_token_123',
        provider: 'google',
      );

      final json = request.toJson();

      expect(json['tokenId'], 'google_token_123');
      expect(json['provider'], 'google');
    });
  });

  group('Backend Service Tests', () {
    test(
      'authenticateWithOAuth should handle network errors gracefully',
      () async {
        // This test will fail because localhost:4000 is not running
        // but it demonstrates how the Dio error handling works
        final result = await BackendService.authenticateWithOAuth(
          tokenId: 'test_token',
          provider: 'google',
        );

        expect(
          result,
          null,
        ); // Should return null on DioException/network error
      },
    );
  });
}
