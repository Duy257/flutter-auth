import '../constants/app_constants.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    
    if (!RegExp(AppConstants.emailRegexPattern).hasMatch(value)) {
      return AppStrings.emailInvalid;
    }
    
    return null;
  }
  
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    
    return null;
  }
  
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }
  
  static String? minLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    
    if (value.length < minLength) {
      return '$fieldName phải có ít nhất $minLength ký tự';
    }
    
    return null;
  }
  
  static String? maxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName không được vượt quá $maxLength ký tự';
    }
    
    return null;
  }
  
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    
    // Vietnamese phone number pattern
    if (!RegExp(r'^(\+84|84|0)[3|5|7|8|9][0-9]{8}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    
    return null;
  }
  
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    
    if (value != originalPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    
    return null;
  }
}
