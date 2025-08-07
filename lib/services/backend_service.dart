import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import '../models/auth_models.dart';

class BackendService {
  static const String _baseUrl = 'http://34.87.128.83:3000';
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Gửi OAuth token lên backend để verify và tạo session
  static Future<OAuthResponse?> authenticateWithOAuth({
    required String tokenId,
    required String provider,
  }) async {
    try {
      final request = OAuthRequest(tokenId: tokenId, provider: provider);
      Logger().i(request.toJson());
      final response = await _dio.post(
        '/auth/oauth/mobile',
        data: request.toJson(),
      );
      Logger().i(response.data);
      if (response.statusCode == 200) {
        return OAuthResponse.fromJson(response.data);
      } else {
        debugPrint('OAuth authentication failed: ${response.statusCode}');
        debugPrint('Response data: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      debugPrint('OAuth authentication DioException: ${e.message}');
      debugPrint('Error type: ${e.type}');
      if (e.response != null) {
        debugPrint('Response status: ${e.response?.statusCode}');
        debugPrint('Response data: ${e.response?.data}');
      }
      return null;
    } catch (e) {
      debugPrint('OAuth authentication error: $e');
      return null;
    }
  }

  /// Gửi Google ID Token lên backend để verify và tạo session
  static Future<Map<String, dynamic>> verifyGoogleToken({
    required String idToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data};
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      debugPrint('Backend verification DioException: ${e.message}');
      return {'success': false, 'error': 'Network error: ${e.message}'};
    } catch (e) {
      debugPrint('Backend verification error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  /// Đăng ký tài khoản mới
  static Future<Map<String, dynamic>> registerCustomer({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        '/api/customer',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'error': 'Registration failed'};
      }
    } on DioException catch (e) {
      debugPrint('Registration DioException: ${e.message}');
      if (e.response?.statusCode == 400) {
        return {'success': false, 'error': 'Email đã được sử dụng'};
      }
      return {'success': false, 'error': 'Network error: ${e.message}'};
    } catch (e) {
      debugPrint('Registration error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  /// Đăng nhập với email/password
  static Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/customer/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'error': 'Invalid credentials'};
      }
    } on DioException catch (e) {
      debugPrint('Login DioException: ${e.message}');
      if (e.response?.statusCode == 401) {
        return {'success': false, 'error': 'Email hoặc mật khẩu không đúng'};
      }
      return {'success': false, 'error': 'Network error: ${e.message}'};
    } catch (e) {
      debugPrint('Login error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}

/// Example backend response models
class AuthResponse {
  final String token;
  final User user;
  final DateTime expiresAt;

  AuthResponse({
    required this.token,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
    );
  }
}
