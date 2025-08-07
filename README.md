# Flutter Login App

Ứng dụng Flutter với màn hình đăng nhập bao gồm:

- Đăng nhập bằng email và mật khẩu
- Đăng nhập bằng Google Sign-In
- Giao diện đẹp và thân thiện với người dùng

## Tính năng

### 🔐 Đăng nhập Email/Mật khẩu

- Validation email và mật khẩu
- Hiển thị/ẩn mật khẩu
- Loading state khi đăng nhập

### 🔍 Đăng nhập Google

- Sử dụng Google Sign-In API v7.1.1
- Xử lý lỗi và exception
- Hiển thị thông tin người dùng sau khi đăng nhập

### 🎨 Giao diện

- Material Design 3
- Responsive design
- Smooth animations
- Dark/Light theme support

## Cài đặt

1. Clone repository:

```bash
git clone <repository-url>
cd flutter_application_1
```

2. Cài đặt dependencies:

```bash
flutter pub get
```

3. Cấu hình Environment Variables:

```bash
# Copy file template
cp .env.example .env

# Chỉnh sửa file .env với các giá trị thực tế
# Xem hướng dẫn chi tiết trong ENV_SETUP_GUIDE.md
```

4. Chạy ứng dụng:

```bash
flutter run
```

## Cấu hình Google Sign-In

### 📚 Tài liệu hướng dẫn

Xem thư mục [docs/](docs/) để có hướng dẫn chi tiết:

- **[docs/QUICK_START_CREDENTIALS.md](docs/QUICK_START_CREDENTIALS.md)** - Hướng dẫn nhanh (5 phút)
- **[docs/GET_CREDENTIALS_GUIDE.md](docs/GET_CREDENTIALS_GUIDE.md)** - Hướng dẫn chi tiết từng bước
- **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Giải quyết lỗi thường gặp

### ⚡ Quick Setup

1. **Lấy credentials**: Xem [docs/GET_CREDENTIALS_GUIDE.md](docs/GET_CREDENTIALS_GUIDE.md)
2. **Cấu hình Environment**: Xem [ENV_SETUP_GUIDE.md](ENV_SETUP_GUIDE.md)
3. **Cấu hình Platform**: Xem [GOOGLE_SIGNIN_SETUP.md](GOOGLE_SIGNIN_SETUP.md)

## Cấu trúc dự án

```
lib/
├── main.dart           # Entry point của ứng dụng
└── login_screen.dart   # Màn hình đăng nhập
```

## Dependencies

- `flutter`: SDK Flutter
- `google_sign_in: ^7.1.1`: Google Sign-In plugin
- `flutter_dotenv: ^5.2.1`: Environment variables management

## Hướng dẫn phát triển

### Thêm tính năng mới

1. Tạo file dart mới trong thư mục `lib/`
2. Import vào `main.dart` nếu cần
3. Cập nhật navigation nếu có

### Testing

```bash
flutter test
```

### Build APK

```bash
flutter build apk --release
```

## Lưu ý

- Để test Google Sign-In, cần chạy trên thiết bị thật hoặc emulator có Google Play Services
- Cần cấu hình OAuth 2.0 credentials trên Google Cloud Console
- Trong môi trường production, cần cấu hình release keystore

## Liên hệ

Nếu có vấn đề gì, vui lòng tạo issue hoặc liên hệ qua email.
