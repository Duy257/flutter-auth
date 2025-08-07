class AppConstants {
  // Spacing
  static const double spacingXS = 8.0;
  static const double spacingS = 16.0;
  static const double spacingM = 24.0;
  static const double spacingL = 32.0;
  static const double spacingXL = 48.0;
  static const double spacingXXL = 60.0;

  // Border Radius
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;

  // Button Heights
  static const double buttonHeight = 50.0;
  static const double buttonHeightS = 40.0;

  // Icon Sizes
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 80.0;

  // Font Sizes
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeTitle = 32.0;

  // Animation Durations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const String emailRegexPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Delays
  static const Duration simulatedLoginDelay = Duration(seconds: 2);
}

class AppStrings {
  // Login Screen
  static const String loginTitle = 'Đăng nhập';
  static const String loginSubtitle = 'Chào mừng bạn trở lại!';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Nhập email của bạn';
  static const String passwordLabel = 'Mật khẩu';
  static const String passwordHint = 'Nhập mật khẩu của bạn';
  static const String loginButton = 'Đăng nhập';
  static const String googleSignInButton = 'Đăng nhập với Google';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String orDivider = 'hoặc';

  // Validation Messages
  static const String emailRequired = 'Vui lòng nhập email';
  static const String emailInvalid = 'Email không hợp lệ';
  static const String passwordRequired = 'Vui lòng nhập mật khẩu';
  static const String passwordTooShort = 'Mật khẩu phải có ít nhất 6 ký tự';

  // Success Messages
  static const String loginSuccess = 'Đăng nhập thành công!';
  static const String googleSignInSuccess = 'Chào mừng';

  // Error Messages
  static const String googleSignInError = 'Lỗi đăng nhập Google';
  static const String googleSignInNotSupported = 'Google Sign In không được hỗ trợ trên platform này';
  static const String forgotPasswordNotImplemented = 'Tính năng quên mật khẩu sẽ được phát triển';

  // Loading Messages
  static const String signingIn = 'Đang đăng nhập...';
  static const String initializing = 'Đang khởi tạo...';
}

class AppAssets {
  static const String googleLogo = 'assets/images/google_logo.png';
}
