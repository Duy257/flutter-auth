import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'constants/app_constants.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';
import 'screens/user_profile_screen.dart';
import 'models/auth_models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      await _authService.initializeGoogleSignIn();
    } catch (e) {
      debugPrint('Failed to initialize services: $e');
    }
  }

  Future<void> _handleEmailSignIn(String email, String password) async {
    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    if (mounted) {
      if (result.success) {
        // Navigate to user profile screen or main app
        _showMessage(result.message ?? 'Đăng nhập thành công!', result.success);
      } else {
        _showMessage(
          result.message ?? result.error ?? 'Unknown error',
          result.success,
        );
      }
    }
  }

  Future<void> _handleEmailSignUp(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final result = await _authService.registerWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    if (mounted) {
      if (result.success) {
        // Navigate to user profile screen or main app
        _showMessage(result.message ?? 'Đăng ký thành công!', result.success);
      } else {
        _showMessage(
          result.message ?? result.error ?? 'Unknown error',
          result.success,
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final result = await _authService.signInWithGoogle();
    Logger().i(result.data);

    if (mounted) {
      if (result.success && result.data is OAuthResponse) {
        // Navigate to user profile screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                UserProfileScreen(userResponse: result.data as OAuthResponse),
          ),
        );
      } else {
        _showMessage(
          result.message ?? result.error ?? 'Unknown error',
          result.success,
        );
      }
    }
  }

  void _handleForgotPassword() {
    _showMessage(AppStrings.forgotPasswordNotImplemented, false);
  }

  void _showMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess
            ? AppTheme.successColor
            : AppTheme.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: ListenableBuilder(
            listenable: _authService,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const LoginHeader(),

                  // Form
                  LoginForm(
                    onEmailSignIn: _handleEmailSignIn,
                    onEmailSignUp: _handleEmailSignUp,
                    onGoogleSignIn: _handleGoogleSignIn,
                    onForgotPassword: _handleForgotPassword,
                    isLoading: _authService.isLoading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
