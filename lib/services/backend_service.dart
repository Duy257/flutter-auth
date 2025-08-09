import 'dart:io';
import '../api/api.dart';
import '../models/auth_models.dart';
import '../config/env_config.dart';

/// Backend service facade that provides backward compatibility
/// while delegating to the new modular API structure
class BackendService {
  /// Initialize the API client infrastructure
  static void initialize() {
    BaseApiClient.initialize();
  }

  /// Gửi OAuth token lên backend để verify và tạo session
  /// Delegates to AuthApi.authenticateWithOAuth
  static Future<OAuthResponse?> authenticateWithOAuth({
    required String tokenId,
    required String provider,
  }) async {
    return AuthApi.authenticateWithOAuth(tokenId: tokenId, provider: provider);
  }

  /// Gửi Google ID Token lên backend để verify và tạo session
  /// Delegates to AuthApi.verifyGoogleToken
  static Future<Map<String, dynamic>> verifyGoogleToken({
    required String idToken,
  }) async {
    return AuthApi.verifyGoogleToken(idToken: idToken);
  }

  /// Đăng ký tài khoản mới
  /// Delegates to CustomerApi.register
  static Future<Map<String, dynamic>> registerCustomer({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    return CustomerApi.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }

  /// Đăng nhập với email/password
  /// Delegates to CustomerApi.loginWithEmail
  static Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return CustomerApi.loginWithEmail(email: email, password: password);
  }

  /// Tạo category mới với name và image (optional)
  /// Delegates to CategoryApi.create
  static Future<Map<String, dynamic>> createCategory({
    required String name,
    File? imageFile,
  }) async {
    // If there is an image file, try uploading it first to get a URL
    if (imageFile != null) {
      final uploadResult = await MediaApi.upload(file: imageFile, alt: name);

      if (uploadResult['success'] == true) {
        final dynamic data = uploadResult['data'];
        String? mediaId;
        if (data is Map<String, dynamic>) {
          if (data['doc'] is Map<String, dynamic>) {
            mediaId = (data['doc'] as Map<String, dynamic>)['id'] as String?;
          } else {
            mediaId = data['id'] as String?;
          }
        }

        if (mediaId != null && mediaId.isNotEmpty) {
          // Prefer linking by media id when available
          return CategoryApi.create(name: name, imageId: mediaId);
        }

        // Fallback to using filename -> public URL if id is missing
        String? filename;
        if (data is Map<String, dynamic>) {
          if (data['doc'] is Map<String, dynamic>) {
            filename =
                (data['doc'] as Map<String, dynamic>)['filename'] as String?;
          } else {
            filename = data['filename'] as String?;
          }
        }
        if (filename != null && filename.isNotEmpty) {
          final baseUrl = EnvConfig.instance.baseUrl;
          final imageUrl = '$baseUrl/uploads/$filename';
          return CategoryApi.create(name: name, imageUrl: imageUrl);
        }
      }

      // If upload failed or no filename, fall back to original file upload path
      return CategoryApi.create(name: name, imageFile: imageFile);
    }

    // No image provided
    return CategoryApi.create(name: name);
  }
}
