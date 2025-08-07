# Documentation - Flutter Login App

## 📚 Tổng quan

Thư mục này chứa tất cả tài liệu hướng dẫn cho việc cấu hình và sử dụng Flutter Login App với Google Sign-In.

## 📋 Danh sách tài liệu

### 🚀 Quick Start
- **[QUICK_START_CREDENTIALS.md](QUICK_START_CREDENTIALS.md)** - Hướng dẫn nhanh lấy credentials (5 phút)

### 📖 Hướng dẫn chi tiết  
- **[GET_CREDENTIALS_GUIDE.md](GET_CREDENTIALS_GUIDE.md)** - Hướng dẫn chi tiết từng bước lấy thông tin cho .env

### 🔧 Troubleshooting
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Giải quyết các lỗi thường gặp

### 📁 Các file khác
- **[../ENV_SETUP_GUIDE.md](../ENV_SETUP_GUIDE.md)** - Hướng dẫn cấu hình environment variables
- **[../GOOGLE_SIGNIN_SETUP.md](../GOOGLE_SIGNIN_SETUP.md)** - Hướng dẫn cấu hình platform-specific

## 🎯 Workflow khuyến nghị

### Cho người mới bắt đầu:
1. Đọc [GET_CREDENTIALS_GUIDE.md](GET_CREDENTIALS_GUIDE.md) - Hướng dẫn chi tiết
2. Theo dõi [ENV_SETUP_GUIDE.md](../ENV_SETUP_GUIDE.md) - Cấu hình .env
3. Nếu gặp lỗi → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### Cho người có kinh nghiệm:
1. Đọc [QUICK_START_CREDENTIALS.md](QUICK_START_CREDENTIALS.md) - Quick start
2. Nếu gặp lỗi → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## 🔍 Tìm kiếm nhanh

### Tôi cần...

| Nhu cầu | File tài liệu |
|---------|---------------|
| Lấy Google Client ID | [GET_CREDENTIALS_GUIDE.md](GET_CREDENTIALS_GUIDE.md) |
| Lấy SHA-1 fingerprint | [QUICK_START_CREDENTIALS.md](QUICK_START_CREDENTIALS.md) |
| Cấu hình file .env | [ENV_SETUP_GUIDE.md](../ENV_SETUP_GUIDE.md) |
| Sửa lỗi "Developer Error" | [TROUBLESHOOTING.md](TROUBLESHOOTING.md) |
| Sửa lỗi "Invalid package name" | [TROUBLESHOOTING.md](TROUBLESHOOTING.md) |
| Cấu hình Android/iOS | [GOOGLE_SIGNIN_SETUP.md](../GOOGLE_SIGNIN_SETUP.md) |

### Lỗi thường gặp

| Lỗi | Giải pháp |
|-----|-----------|
| "Google Sign-In configuration errors" | [TROUBLESHOOTING.md#-google-sign-in-configuration-errors](TROUBLESHOOTING.md) |
| "Failed to initialize Google Sign-In" | [TROUBLESHOOTING.md#-failed-to-initialize-google-sign-in](TROUBLESHOOTING.md) |
| "Invalid package name" | [TROUBLESHOOTING.md#-invalid-package-name](TROUBLESHOOTING.md) |
| "Developer Error" | [TROUBLESHOOTING.md#-developer-error](TROUBLESHOOTING.md) |

## ⚡ Commands hữu ích

### Lấy SHA-1 fingerprint:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Copy .env template:
```bash
cp .env.example .env
```

### Chạy app với verbose logging:
```bash
flutter run --verbose
```

### Kiểm tra package name:
```bash
grep applicationId android/app/build.gradle.kts
```

## 📱 Platform-specific

### Android
- Package name: `com.example.flutter_application_1`
- SHA-1 fingerprint cần thiết
- Google Play Services required

### iOS  
- Bundle ID: `com.example.flutterApplication1`
- Reversed Client ID cần thiết
- URL scheme configuration

### Web
- JavaScript origins configuration
- Redirect URIs setup

## 🔗 Liên kết ngoài

### Google Documentation
- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Sign-In for Android](https://developers.google.com/identity/sign-in/android)
- [Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios)

### Flutter Resources
- [Google Sign-In Plugin](https://pub.dev/packages/google_sign_in)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

### Community Support
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- [Google Sign-In Plugin Issues](https://github.com/flutter/packages/issues)

## 📝 Đóng góp

Nếu bạn tìm thấy lỗi trong tài liệu hoặc muốn cải thiện:

1. Tạo issue để báo cáo lỗi
2. Submit pull request với cải thiện
3. Chia sẻ feedback qua email

## 📄 License

Tài liệu này được phân phối dưới MIT License - xem file [LICENSE](../LICENSE) để biết thêm chi tiết.

---

**💡 Tip**: Bookmark trang này để dễ dàng truy cập các hướng dẫn khi cần!
