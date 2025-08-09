import 'package:logger/web.dart';
import '../models/auth_models.dart';
import 'base_api_client.dart';

/// API client for authentication-related operations
/// Handles OAuth authentication and Google token verification
class AuthApi {
  /// Send OAuth token to backend for verification and session creation
  ///
  /// [tokenId] - The OAuth token ID from the provider
  /// [provider] - The OAuth provider name (e.g., 'google')
  ///
  /// Returns [OAuthResponse] on success, null on failure
  static Future<OAuthResponse?> authenticateWithOAuth({
    required String tokenId,
    required String provider,
  }) async {
    try {
      final request = OAuthRequest(tokenId: tokenId, provider: provider);
      Logger().i('OAuth request: ${request.toJson()}');

      final response = await BaseApiClient.dio.post(
        '/api/oauth/mobile',
        data: request.toJson(),
      );
      Logger().i('OAuth response: ${response.data}');

      if (response.statusCode == 200) {
        return OAuthResponse.fromJson(response.data);
      } else {
        Logger().w('OAuth authentication failed: ${response.statusCode}');
        Logger().w('Response data: ${response.data}');
        return null;
      }
    } catch (e) {
      Logger().e('OAuth authentication error: $e');
      return null;
    }
  }

  /// Send Google ID Token to backend for verification and session creation
  ///
  /// [idToken] - The Google ID token to verify
  ///
  /// Returns a map with success status and data/error
  static Future<Map<String, dynamic>> verifyGoogleToken({
    required String idToken,
  }) async {
    return BaseApiClient.makeRequest(
      operation: 'Google token verification',
      request: () => BaseApiClient.dio.post(
        '/api/auth/google',
        data: {'idToken': idToken},
      ),
    );
  }
}
