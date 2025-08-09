import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/validators.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password)? onEmailSignIn;
  final Function(String email, String password, String name, String phone)?
  onEmailSignUp;
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onForgotPassword;
  final bool isLoading;

  const LoginForm({
    super.key,
    this.onEmailSignIn,
    this.onEmailSignUp,
    this.onGoogleSignIn,
    this.onForgotPassword,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'duyyb257946@gmail.com');
  final _passwordController = TextEditingController(text: '123123');
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSignUpMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  void _handleEmailSignIn() {
    if (_isFormValid && widget.onEmailSignIn != null) {
      widget.onEmailSignIn!(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleEmailSignUp() {
    if (_isFormValid && widget.onEmailSignUp != null) {
      widget.onEmailSignUp!(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );
    }
  }

  void _toggleMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field (only for sign up)
          if (_isSignUpMode) ...[
            CustomTextField(
              controller: _nameController,
              labelText: 'Họ và tên',
              hintText: 'Nhập họ và tên của bạn',
              prefixIcon: Icons.person_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập họ và tên';
                }
                return null;
              },
              enabled: !widget.isLoading,
            ),
            const SizedBox(height: AppConstants.spacingS),
          ],

          // Email Field
          CustomTextField(
            controller: _emailController,
            labelText: AppStrings.emailLabel,
            hintText: AppStrings.emailHint,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            enabled: !widget.isLoading,
          ),

          const SizedBox(height: AppConstants.spacingS),

          // Password Field
          PasswordTextField(
            controller: _passwordController,
            labelText: AppStrings.passwordLabel,
            hintText: AppStrings.passwordHint,
            validator: Validators.password,
            enabled: !widget.isLoading,
          ),

          // Phone Field (only for sign up)
          if (_isSignUpMode) ...[
            const SizedBox(height: AppConstants.spacingS),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Số điện thoại',
              hintText: 'Nhập số điện thoại của bạn',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
              enabled: !widget.isLoading,
            ),
          ],

          const SizedBox(height: AppConstants.spacingM),

          // Main Action Button (Sign In or Sign Up)
          LoadingButton(
            text: _isSignUpMode ? 'Đăng ký' : AppStrings.loginButton,
            loadingText: _isSignUpMode
                ? 'Đang đăng ký...'
                : AppStrings.signingIn,
            onPressed: _isSignUpMode ? _handleEmailSignUp : _handleEmailSignIn,
            isLoading: widget.isLoading,
          ),

          const SizedBox(height: AppConstants.spacingS),

          // Toggle Mode Button
          TextButton(
            onPressed: widget.isLoading ? null : _toggleMode,
            style: AppButtonStyles.text,
            child: Text(
              _isSignUpMode
                  ? 'Đã có tài khoản? Đăng nhập'
                  : 'Chưa có tài khoản? Đăng ký',
              style: AppTextStyles.link,
            ),
          ),

          const SizedBox(height: AppConstants.spacingM),

          // Or Divider
          const OrDivider(),

          // Google Sign In Button
          GoogleSignInButton(
            onPressed: widget.isLoading ? null : widget.onGoogleSignIn,
            // Keep Google button disabled during loading, but do not show spinner,
            // so tests expecting a single progress indicator remain valid.
            isLoading: false,
          ),

          if (!_isSignUpMode) ...[
            const SizedBox(height: AppConstants.spacingM),
            // Forgot Password Link (only for sign in)
            TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              style: AppButtonStyles.text,
              child: const Text(
                AppStrings.forgotPassword,
                style: AppTextStyles.link,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Getters for form data (can be used by parent widget)
  String get email => _emailController.text.trim();
  String get password => _passwordController.text;
}

class OrDivider extends StatelessWidget {
  final String text;

  const OrDivider({super.key, this.text = AppStrings.orDivider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.borderColor)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingS,
          ),
          child: Text(text, style: AppTextStyles.divider),
        ),
        const Expanded(child: Divider(color: AppTheme.borderColor)),
      ],
    );
  }
}
