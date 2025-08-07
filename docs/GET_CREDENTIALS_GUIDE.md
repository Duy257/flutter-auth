# Hướng dẫn lấy thông tin cho file .env

## Tổng quan

File này hướng dẫn chi tiết cách lấy tất cả thông tin cần thiết để điền vào file `.env` cho Google Sign-In.

## Bước 1: Tạo dự án Google Cloud

### 1.1 Truy cập Google Cloud Console

1. Mở trình duyệt và truy cập: https://console.cloud.google.com/
2. Đăng nhập bằng tài khoản Google của bạn

### 1.2 Tạo dự án mới

1. Click vào dropdown "Select a project" ở góc trên bên trái
2. Click "New Project"
3. Nhập tên dự án (ví dụ: "Flutter Login App")
4. Chọn Organization (nếu có)
5. Click "Create"

### 1.3 Bật Google Sign-In API

1. Trong Google Cloud Console, vào "APIs & Services" > "Library"
2. Tìm kiếm "Google Sign-In API" hoặc "Google+ API"
3. Click vào API và nhấn "Enable"

## Bước 2: Tạo OAuth 2.0 Credentials

### 2.1 Cấu hình OAuth Consent Screen

1. Vào "APIs & Services" > "OAuth consent screen"
2. Chọn "External" (cho ứng dụng công khai) hoặc "Internal" (cho tổ chức)
3. Điền thông tin:
   - **App name**: Flutter Login App
   - **User support email**: email của bạn
   - **Developer contact information**: email của bạn
4. Click "Save and Continue"
5. Ở phần "Scopes", click "Add or Remove Scopes"
6. Thêm các scopes cần thiết:
   - `../auth/userinfo.email`
   - `../auth/userinfo.profile`
   - `openid`
7. Click "Save and Continue"
8. Ở phần "Test users" (nếu chọn External), thêm email test
9. Click "Save and Continue"

### 2.2 Tạo Android OAuth Client ID

1. Vào "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth 2.0 Client ID"
3. Chọn "Android"
4. Điền thông tin:
   - **Name**: Flutter App Android
   - **Package name**: `com.example.flutter_application_1`
   - **SHA-1 certificate fingerprint**: (xem bước 2.3)

### 2.3 Lấy SHA-1 Certificate Fingerprint

#### Cho Debug (Development):

```bash
# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Windows
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### Cho Release (Production):

```bash
keytool -list -v -keystore /path/to/your/release.keystore -alias your-alias-name
```

**Lưu ý**: Copy dòng SHA1 fingerprint (dạng: `AA:BB:CC:DD:...`)

### 2.4 Hoàn thành tạo Android Client ID

1. Paste SHA-1 fingerprint vào ô "SHA-1 certificate fingerprint"
2. Click "Create"
3. **Copy Client ID** (dạng: `123456789012-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com`)
4. Paste vào file `.env` ở dòng `GOOGLE_ANDROID_CLIENT_ID`

### 2.5 Tạo iOS OAuth Client ID

1. Click "Create Credentials" > "OAuth 2.0 Client ID"
2. Chọn "iOS"
3. Điền thông tin:
   - **Name**: Flutter App iOS
   - **Bundle ID**: `com.example.flutterApplication1`
4. Click "Create"
5. **Copy Client ID**
6. Paste vào file `.env` ở dòng `GOOGLE_IOS_CLIENT_ID`

### 2.6 Tạo Web OAuth Client ID (Tùy chọn)

1. Click "Create Credentials" > "OAuth 2.0 Client ID"
2. Chọn "Web application"
3. Điền thông tin:
   - **Name**: Flutter App Web
   - **Authorized JavaScript origins**: `http://localhost:3000` (cho development)
   - **Authorized redirect URIs**: `http://localhost:3000/auth/callback`
4. Click "Create"
5. **Copy Client ID**
6. Paste vào file `.env` ở dòng `GOOGLE_WEB_CLIENT_ID`

## Bước 3: Tạo Reversed Client ID cho iOS

### 3.1 Từ iOS Client ID

Nếu iOS Client ID của bạn là:

```
123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com
```

Thì Reversed Client ID sẽ là:

```
com.googleusercontent.apps.123456789012-abcdefghijklmnopqrstuvwxyz123456
```

### 3.2 Công thức

```
com.googleusercontent.apps.{PHẦN_TRƯỚC_DẤU_CHẤM_ĐẦU_TIÊN}
```

Paste vào file `.env` ở dòng `GOOGLE_REVERSED_CLIENT_ID`

## Bước 4: Cấu hình Firebase (Tùy chọn)

### 4.1 Tạo Firebase Project

1. Truy cập: https://console.firebase.google.com/
2. Click "Add project"
3. Chọn Google Cloud project đã tạo ở bước 1
4. Bật Google Analytics (tùy chọn)
5. Click "Create project"

### 4.2 Thêm Android App

1. Click "Add app" > Android icon
2. Điền:
   - **Package name**: `com.example.flutter_application_1`
   - **App nickname**: Flutter Login App
   - **SHA-1**: (cùng SHA-1 đã dùng ở bước 2.3)
3. Click "Register app"
4. **Download `google-services.json`**
5. Đặt file vào `android/app/google-services.json`

### 4.3 Thêm iOS App

1. Click "Add app" > iOS icon
2. Điền:
   - **Bundle ID**: `com.example.flutterApplication1`
   - **App nickname**: Flutter Login App
3. Click "Register app"
4. **Download `GoogleService-Info.plist`**
5. Đặt file vào `ios/Runner/GoogleService-Info.plist`

### 4.4 Lấy Firebase Configuration

1. Vào "Project settings" (icon bánh răng)
2. Scroll xuống phần "Your apps"
3. Copy các thông tin:
   - **Project ID**: paste vào `FIREBASE_PROJECT_ID`
   - **API Key**: paste vào `FIREBASE_API_KEY`
   - **App ID**: paste vào `FIREBASE_APP_ID`

## Bước 5: Điền thông tin vào file .env

Mở file `.env` và điền các thông tin đã lấy được:

```env
# Google Sign-In Configuration
GOOGLE_ANDROID_CLIENT_ID=123456789012-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=123456789012-yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_ID=123456789012-zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz.apps.googleusercontent.com
GOOGLE_SERVER_CLIENT_ID=123456789012-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.apps.googleusercontent.com
GOOGLE_REVERSED_CLIENT_ID=com.googleusercontent.apps.123456789012-yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

# Scopes (thường không cần thay đổi)
GOOGLE_SCOPES=email,profile

# App Configuration
APP_NAME=Flutter Login App
APP_VERSION=1.0.0
APP_ENVIRONMENT=development

# Firebase Configuration (nếu sử dụng)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
FIREBASE_APP_ID=1:123456789012:android:xxxxxxxxxxxxxxxxxxxxxxxx

# Debug Settings
DEBUG_MODE=true
ENABLE_LOGGING=true
```

## Bước 6: Kiểm tra cấu hình

1. Lưu file `.env`
2. Chạy ứng dụng:
   ```bash
   flutter run
   ```
3. Kiểm tra console output để xem có thông báo lỗi không
4. Nếu thấy "Google Sign-In initialized successfully" là thành công

## Troubleshooting

### Lỗi "Invalid package name"

- Đảm bảo package name trong Google Cloud Console khớp với `applicationId` trong `android/app/build.gradle.kts`

### Lỗi "Invalid SHA-1"

- Kiểm tra lại SHA-1 fingerprint
- Đảm bảo sử dụng đúng keystore (debug cho development, release cho production)

### Lỗi "Invalid bundle ID"

- Đảm bảo bundle ID trong Google Cloud Console khớp với `PRODUCT_BUNDLE_IDENTIFIER` trong iOS

### Lỗi "API not enabled"

- Đảm bảo đã bật Google Sign-In API trong Google Cloud Console

## Checklist hoàn thành

- [ ] Tạo Google Cloud Project
- [ ] Bật Google Sign-In API
- [ ] Cấu hình OAuth Consent Screen
- [ ] Tạo Android OAuth Client ID
- [ ] Lấy SHA-1 certificate fingerprint
- [ ] Tạo iOS OAuth Client ID
- [ ] Tính toán Reversed Client ID
- [ ] Tạo Web OAuth Client ID (tùy chọn)
- [ ] Cấu hình Firebase (tùy chọn)
- [ ] Download google-services.json và GoogleService-Info.plist
- [ ] Điền tất cả thông tin vào file .env
- [ ] Test ứng dụng

## Lưu ý bảo mật

- **KHÔNG BAO GIỜ** commit file `.env` vào Git
- Sử dụng các Client ID khác nhau cho development và production
- Thường xuyên rotate credentials trong production
- Chỉ thêm domain/package name tin cậy vào OAuth configuration

## Liên kết hữu ích

- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Sign-In Documentation](https://developers.google.com/identity/sign-in/android)
- [Flutter Google Sign-In Plugin](https://pub.dev/packages/google_sign_in)
