import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? logo;

  const LoginHeader({
    super.key,
    this.title = AppStrings.loginTitle,
    this.subtitle = AppStrings.loginSubtitle,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppConstants.spacingXXL),
        
        // Logo
        logo ?? const Icon(
          Icons.lock_outline,
          size: AppConstants.iconSizeXL,
          color: AppTheme.primaryColor,
        ),
        
        const SizedBox(height: AppConstants.spacingM),
        
        // Title
        Text(
          title,
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.spacingXS),
        
        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.spacingXL),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  final String text;

  const OrDivider({
    super.key,
    this.text = AppStrings.orDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: AppTheme.borderColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingS),
            child: Text(
              text,
              style: AppTextStyles.divider,
            ),
          ),
          const Expanded(
            child: Divider(color: AppTheme.borderColor),
          ),
        ],
      ),
    );
  }
}
