import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/env_config.dart';

/// Base API client that provides common functionality for all API modules
/// Includes Dio configuration, error handling, and response processing
abstract class BaseApiClient {
  static final String _baseUrl = EnvConfig.instance.baseUrl;
  static late final Dio _dio;
  
  /// Initialize the Dio instance with common configuration
  static void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    
    // Add interceptors for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }
  }
  
  /// Get the configured Dio instance
  static Dio get dio {
    return _dio;
  }
  
  /// Common error handling for API responses
  static Map<String, dynamic> handleError(DioException e, String operation) {
    debugPrint('$operation DioException: ${e.message}');
    debugPrint('Error type: ${e.type}');
    
    if (e.response != null) {
      debugPrint('Response status: ${e.response?.statusCode}');
      debugPrint('Response data: ${e.response?.data}');
      
      // Handle specific HTTP status codes
      switch (e.response?.statusCode) {
        case 400:
          return {
            'success': false,
            'error': e.response?.data['message'] ?? 'Bad request'
          };
        case 401:
          return {
            'success': false,
            'error': 'Unauthorized access'
          };
        case 403:
          return {
            'success': false,
            'error': 'Access forbidden'
          };
        case 404:
          return {
            'success': false,
            'error': 'Resource not found'
          };
        case 500:
          return {
            'success': false,
            'error': 'Internal server error'
          };
        default:
          return {
            'success': false,
            'error': 'Server error: ${e.response?.statusCode}'
          };
      }
    }
    
    // Handle network errors
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return {
          'success': false,
          'error': 'Connection timeout'
        };
      case DioExceptionType.receiveTimeout:
        return {
          'success': false,
          'error': 'Receive timeout'
        };
      case DioExceptionType.connectionError:
        return {
          'success': false,
          'error': 'Connection error'
        };
      default:
        return {
          'success': false,
          'error': 'Network error: ${e.message}'
        };
    }
  }
  
  /// Common success response processing
  static Map<String, dynamic> handleSuccess(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'data': response.data
      };
    } else {
      return {
        'success': false,
        'error': 'Unexpected status code: ${response.statusCode}'
      };
    }
  }
  
  /// Generic API call wrapper with error handling
  static Future<Map<String, dynamic>> makeRequest({
    required String operation,
    required Future<Response> Function() request,
  }) async {
    try {
      final response = await request();
      return handleSuccess(response);
    } on DioException catch (e) {
      return handleError(e, operation);
    } catch (e) {
      debugPrint('$operation error: $e');
      return {
        'success': false,
        'error': 'Unexpected error: $e'
      };
    }
  }
}
