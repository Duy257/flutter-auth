import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'base_api_client.dart';

/// API client for customer-related operations
/// Handles customer registration and email/password authentication
class CustomerApi {
  /// Register a new customer account
  /// 
  /// [email] - Customer email address
  /// [password] - Customer password
  /// [name] - Customer full name
  /// [phone] - Customer phone number
  /// 
  /// Returns a map with success status and data/error
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    return BaseApiClient.makeRequest(
      operation: 'Customer registration',
      request: () => BaseApiClient.dio.post(
        '/api/customer',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        },
      ),
    );
  }

  /// Login with email and password
  /// 
  /// [email] - Customer email address
  /// [password] - Customer password
  /// 
  /// Returns a map with success status and data/error
  static Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    Logger().d('Login attempt for email: $email');
    
    return BaseApiClient.makeRequest(
      operation: 'Email login',
      request: () => BaseApiClient.dio.post(
        '/api/customer/login',
        data: {
          'email': email,
          'password': password,
        },
      ),
    );
  }
}
