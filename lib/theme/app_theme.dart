import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static const Color primaryColor = Colors.blue;
  static const Color primaryColorLight = Color(0xFF64B5F6);
  static const Color primaryColorDark = Color(0xFF1976D2);
  
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color borderColorFocused = primaryColor;
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: AppConstants.fontSizeTitle,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: AppConstants.fontSizeL,
    color: AppTheme.textSecondary,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: AppConstants.fontSizeL,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: AppConstants.fontSizeL,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle link = TextStyle(
    color: AppTheme.primaryColor,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle divider = TextStyle(
    color: AppTheme.textHint,
  );
}

class AppInputDecorations {
  static InputDecoration textField({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppTheme.borderColorFocused),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppTheme.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppTheme.errorColor),
      ),
    );
  }
}

class AppButtonStyles {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
    ),
    elevation: 2,
    minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
  );
  
  static ButtonStyle secondary = OutlinedButton.styleFrom(
    side: const BorderSide(color: AppTheme.borderColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
    ),
    minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
  );
  
  static ButtonStyle text = TextButton.styleFrom(
    foregroundColor: AppTheme.primaryColor,
  );
}
