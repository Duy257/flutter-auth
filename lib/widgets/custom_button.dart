import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final Widget? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? double.infinity;
    final buttonHeight = height ?? AppConstants.buttonHeight;

    Widget child = isLoading
        ? SizedBox(
            height: AppConstants.iconSizeS,
            width: AppConstants.iconSizeS,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary ? Colors.white : AppTheme.primaryColor,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppConstants.spacingXS),
              ],
              Text(
                text,
                style: type == ButtonType.primary
                    ? AppTextStyles.button.copyWith(color: Colors.white)
                    : AppTextStyles.buttonSecondary,
              ),
            ],
          );

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: _buildButton(child),
    );
  }

  Widget _buildButton(Widget child) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: AppButtonStyles.primary,
          child: child,
        );
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: AppButtonStyles.secondary,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: AppButtonStyles.text,
          child: child,
        );
    }
  }
}

enum ButtonType {
  primary,
  secondary,
  text,
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Đăng nhập với Google',
      onPressed: onPressed,
      isLoading: isLoading,
      type: ButtonType.secondary,
      icon: _buildGoogleIcon(),
    );
  }

  Widget _buildGoogleIcon() {
    return Image.asset(
      'assets/images/google_logo.png',
      height: AppConstants.iconSizeM,
      width: AppConstants.iconSizeM,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.g_mobiledata,
          size: AppConstants.iconSizeM,
          color: Colors.red,
        );
      },
    );
  }
}

class LoadingButton extends StatelessWidget {
  final String text;
  final String loadingText;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;

  const LoadingButton({
    super.key,
    required this.text,
    this.loadingText = 'Đang xử lý...',
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: isLoading ? loadingText : text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: type,
    );
  }
}
