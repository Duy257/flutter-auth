# Hướng dẫn cấu hình Environment Variables (.env)

## Tổng quan

File `.env` chứa các cấu hình nhạy cảm và environment-specific cho ứng dụng Flutter. File này không được commit vào Git để bảo mật.

## Bước 1: Tạo file .env

1. Copy file `.env.example` thành `.env`:
```bash
cp .env.example .env
```

2. Hoặc tạo file `.env` mới với nội dung từ template.

## Bước 2: Cấu hình Google Cloud Console

### 2.1 Tạo dự án Google Cloud

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo dự án mới hoặc chọn dự án hiện có
3. Bật Google Sign-In API:
   - Vào "APIs & Services" > "Library"
   - Tìm "Google Sign-In API" và bật

### 2.2 Tạo OAuth 2.0 Credentials

1. Vào "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth 2.0 Client ID"

#### Cho Android:
1. Chọn "Android"
2. Package name: `com.example.flutter_application_1`
3. SHA-1 certificate fingerprint:
   ```bash
   # Debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # Release keystore (production)
   keytool -list -v -keystore /path/to/your/release.keystore -alias your-alias
   ```
4. Copy Client ID vào `GOOGLE_ANDROID_CLIENT_ID`

#### Cho iOS:
1. Chọn "iOS"
2. Bundle ID: `com.example.flutterApplication1`
3. Copy Client ID vào `GOOGLE_IOS_CLIENT_ID`
4. Tạo Reversed Client ID:
   - Format: `com.googleusercontent.apps.{CLIENT_ID_WITHOUT_SUFFIX}`
   - Ví dụ: Nếu Client ID là `123456-abc.apps.googleusercontent.com`
   - Thì Reversed Client ID là: `com.googleusercontent.apps.123456-abc`

#### Cho Web (tùy chọn):
1. Chọn "Web application"
2. Copy Client ID vào `GOOGLE_WEB_CLIENT_ID`

## Bước 3: Cấu hình file .env

Mở file `.env` và điền các giá trị:

```env
# Thay thế bằng Client ID thực tế từ Google Cloud Console
GOOGLE_ANDROID_CLIENT_ID=123456789012-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=123456789012-yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_ID=123456789012-zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz.apps.googleusercontent.com

# Reversed Client ID cho iOS
GOOGLE_REVERSED_CLIENT_ID=com.googleusercontent.apps.123456789012-yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

# Scopes cần thiết
GOOGLE_SCOPES=email,profile

# App settings
APP_NAME=Flutter Login App
APP_VERSION=1.0.0
APP_ENVIRONMENT=development

# Debug settings
DEBUG_MODE=true
ENABLE_LOGGING=true
```

## Bước 4: Cấu hình platform-specific

### Android

1. Tải file `google-services.json` từ Firebase Console (nếu sử dụng Firebase)
2. Đặt vào `android/app/google-services.json`
3. Cập nhật `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

### iOS

1. Cập nhật `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID_HERE</string>
           </array>
       </dict>
   </array>
   ```

## Bước 5: Kiểm tra cấu hình

1. Chạy ứng dụng:
   ```bash
   flutter run
   ```

2. Kiểm tra console output để xem configuration có được load đúng không.

3. Test Google Sign-In trên thiết bị thật (emulator cần có Google Play Services).

## Troubleshooting

### Lỗi "Google Sign-In configuration errors"
- Kiểm tra file `.env` có tồn tại và có đúng format không
- Đảm bảo các Client ID được điền đầy đủ

### Lỗi "Failed to initialize Google Sign-In"
- Kiểm tra SHA-1 fingerprint có đúng không
- Đảm bảo package name/bundle ID khớp với cấu hình trên Google Cloud Console

### Lỗi "Sign-in cancelled" hoặc "Network error"
- Kiểm tra thiết bị có kết nối internet
- Đảm bảo Google Play Services được cài đặt (Android)
- Kiểm tra Client ID có đúng cho platform hiện tại

## Bảo mật

- **KHÔNG BAO GIỜ** commit file `.env` vào Git
- Sử dụng các file `.env` khác nhau cho các environment khác nhau
- Trong production, sử dụng release keystore và cập nhật SHA-1 fingerprint tương ứng

## Environment Variables Reference

| Variable | Mô tả | Bắt buộc |
|----------|-------|----------|
| `GOOGLE_ANDROID_CLIENT_ID` | OAuth Client ID cho Android | Có (Android) |
| `GOOGLE_IOS_CLIENT_ID` | OAuth Client ID cho iOS | Có (iOS) |
| `GOOGLE_WEB_CLIENT_ID` | OAuth Client ID cho Web | Không |
| `GOOGLE_REVERSED_CLIENT_ID` | Reversed Client ID cho iOS | Có (iOS) |
| `GOOGLE_SCOPES` | Scopes cần thiết (phân cách bằng dấu phẩy) | Có |
| `APP_NAME` | Tên ứng dụng | Không |
| `APP_VERSION` | Phiên bản ứng dụng | Không |
| `DEBUG_MODE` | Bật/tắt debug mode | Không |
| `ENABLE_LOGGING` | Bật/tắt logging | Không |
