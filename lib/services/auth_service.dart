import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';
import '../config/env_config.dart';
import '../constants/app_constants.dart';
import '../models/auth_models.dart';
import 'backend_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthResult {
  final bool success;
  final String? message;
  final dynamic data;
  final String? error;

  const AuthResult({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  factory AuthResult.success({String? message, dynamic data}) {
    return AuthResult(success: true, message: message, data: data);
  }

  factory AuthResult.failure({required String error}) {
    return AuthResult(success: false, error: error);
  }
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  bool _isGoogleSignInInitialized = false;
  OAuthResponse? _currentUser;

  // Getters
  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isGoogleSignInInitialized => _isGoogleSignInInitialized;
  OAuthResponse? get currentUser => _currentUser;

  void _setState(AuthState newState, {String? error}) {
    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;

    try {
      // Validate environment configuration
      final configErrors = EnvConfig.instance.validateConfiguration();
      if (configErrors.isNotEmpty) {
        debugPrint('Google Sign-In configuration errors:');
        for (final error in configErrors) {
          debugPrint('- $error');
        }
        throw Exception('Google Sign-In configuration is invalid');
      }

      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;

      if (EnvConfig.instance.enableLogging) {
        debugPrint('Google Sign-In initialized successfully');
      }
    } catch (e) {
      debugPrint('Failed to initialize Google Sign-In: $e');
      throw Exception('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setState(AuthState.loading);

      // Call backend API for login
      final result = await BackendService.loginWithEmail(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        _setState(AuthState.authenticated);
        return AuthResult.success(
          message: AppStrings.loginSuccess,
          data: result['data'],
        );
      } else {
        _setState(AuthState.error, error: result['error']);
        return AuthResult.failure(error: result['error']);
      }
    } catch (e) {
      _setState(AuthState.error, error: e.toString());
      return AuthResult.failure(error: e.toString());
    }
  }

  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      _setState(AuthState.loading);

      // Call backend API for registration
      final result = await BackendService.registerCustomer(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      if (result['success'] == true) {
        _setState(AuthState.authenticated);
        return AuthResult.success(
          message: 'Đăng ký thành công!',
          data: result['data'],
        );
      } else {
        _setState(AuthState.error, error: result['error']);
        return AuthResult.failure(error: result['error']);
      }
    } catch (e) {
      _setState(AuthState.error, error: e.toString());
      return AuthResult.failure(error: e.toString());
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      _setState(AuthState.loading);

      // Ensure Google Sign-In is initialized
      await initializeGoogleSignIn();

      // Check if platform supports authenticate
      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception(AppStrings.googleSignInNotSupported);
      }

      // Authenticate with Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: EnvConfig.instance.googleScopes,
      );
      Logger().i(googleUser);

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Check if we have the ID token
      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      // Send token to backend for verification and user creation
      final oauthResponse = await BackendService.authenticateWithOAuth(
        tokenId: googleAuth.idToken!,
        provider: 'google',
      );

      if (oauthResponse == null) {
        throw Exception('Failed to authenticate with backend');
      }

      // Store user data
      _currentUser = oauthResponse;
      _setState(AuthState.authenticated);

      return AuthResult.success(
        message:
            '${AppStrings.googleSignInSuccess} ${oauthResponse.user.name}!',
        data: oauthResponse,
      );
    } catch (e) {
      final errorMessage = '${AppStrings.googleSignInError}: $e';
      _setState(AuthState.error, error: errorMessage);
      return AuthResult.failure(error: errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      _setState(AuthState.loading);

      // Sign out from Google if signed in
      if (_isGoogleSignInInitialized) {
        await _googleSignIn.signOut();
      }

      // Clear user data
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setState(AuthState.error, error: e.toString());
    }
  }

  void clearError() {
    if (_state == AuthState.error) {
      _setState(AuthState.unauthenticated);
    }
  }

  void reset() {
    _setState(AuthState.initial);
  }
}
