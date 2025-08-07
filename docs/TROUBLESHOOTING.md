# Troubleshooting Google Sign-In

## Lỗi Environment Configuration

### ❌ "Google Sign-In configuration errors"

**Triệu chứng**: Console hiển thị lỗi configuration khi khởi động app

**Nguyên nhân**:
- File `.env` không tồn tại
- File `.env` thiếu thông tin bắt buộc
- Format sai trong file `.env`

**Giải pháp**:
1. Kiểm tra file `.env` có tồn tại:
   ```bash
   ls -la .env
   ```
2. Kiểm tra nội dung file `.env`:
   ```bash
   cat .env
   ```
3. Đảm bảo có đầy đủ các fields bắt buộc:
   ```env
   GOOGLE_ANDROID_CLIENT_ID=your_android_client_id
   GOOGLE_IOS_CLIENT_ID=your_ios_client_id
   GOOGLE_SCOPES=email,profile
   ```

### ❌ "Failed to initialize Google Sign-In"

**Triệu chứng**: App crash hoặc Google Sign-In không hoạt động

**Nguyên nhân**:
- Client ID không đúng
- SHA-1 fingerprint không khớp
- Package name/Bundle ID không khớp

**Giải pháp**:
1. Kiểm tra Client ID trong Google Cloud Console
2. Verify SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
3. Kiểm tra package name trong `android/app/build.gradle.kts`:
   ```kotlin
   applicationId = "com.example.flutter_application_1"
   ```

## Lỗi Google Cloud Console

### ❌ "Invalid package name"

**Triệu chứng**: Không thể tạo Android OAuth Client ID

**Nguyên nhân**: Package name không đúng format hoặc đã được sử dụng

**Giải pháp**:
1. Sử dụng format đúng: `com.company.appname`
2. Kiểm tra `applicationId` trong `android/app/build.gradle.kts`
3. Đảm bảo package name chưa được sử dụng trong project khác

### ❌ "Invalid SHA-1 certificate fingerprint"

**Triệu chứng**: Không thể tạo Android OAuth Client ID

**Nguyên nhân**: SHA-1 fingerprint sai format hoặc không đúng

**Giải pháp**:
1. Chạy lại command lấy SHA-1:
   ```bash
   # Debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # Release keystore
   keytool -list -v -keystore /path/to/release.keystore -alias your-alias
   ```
2. Copy chính xác dòng SHA1 (format: `AA:BB:CC:DD:...`)
3. Không copy thêm spaces hoặc ký tự khác

### ❌ "API not enabled"

**Triệu chứng**: Lỗi khi test Google Sign-In

**Nguyên nhân**: Google Sign-In API chưa được bật

**Giải pháp**:
1. Vào Google Cloud Console
2. "APIs & Services" > "Library"
3. Tìm "Google Sign-In API" hoặc "Google+ API"
4. Click "Enable"

## Lỗi Runtime

### ❌ "Sign-in cancelled"

**Triệu chứng**: User tap Google Sign-In nhưng không có gì xảy ra

**Nguyên nhân**:
- User hủy sign-in
- Google Play Services không có sẵn
- Network issue

**Giải pháp**:
1. Test trên thiết bị thật có Google Play Services
2. Kiểm tra kết nối internet
3. Thử sign-in lại

### ❌ "Network error"

**Triệu chứng**: Lỗi network khi sign-in

**Nguyên nhân**:
- Không có internet
- Firewall block
- Server Google tạm thời down

**Giải pháp**:
1. Kiểm tra kết nối internet
2. Thử trên network khác
3. Thử lại sau vài phút

### ❌ "Developer Error"

**Triệu chứng**: Popup "Developer Error" khi sign-in

**Nguyên nhân**:
- SHA-1 fingerprint không khớp
- Package name không khớp
- Client ID không đúng

**Giải pháp**:
1. Kiểm tra lại SHA-1 fingerprint
2. Verify package name
3. Đảm bảo sử dụng đúng Client ID cho platform

## Lỗi Platform-specific

### Android

#### ❌ "Google Play Services not available"

**Giải pháp**:
1. Cài đặt Google Play Services trên emulator
2. Update Google Play Services trên thiết bị thật
3. Sử dụng emulator có Google APIs

#### ❌ "Resolution required"

**Giải pháp**:
1. Đảm bảo app có permission cần thiết
2. User cần accept OAuth consent

### iOS

#### ❌ "Invalid bundle ID"

**Giải pháp**:
1. Kiểm tra Bundle ID trong Xcode project
2. Đảm bảo khớp với Google Cloud Console
3. Format đúng: `com.company.appname`

#### ❌ "URL scheme not configured"

**Giải pháp**:
1. Thêm Reversed Client ID vào `Info.plist`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

## Debug Commands

### Kiểm tra environment config:
```bash
flutter run --verbose
```

### Kiểm tra SHA-1:
```bash
# Debug
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1

# Release  
keytool -list -v -keystore /path/to/release.keystore -alias your-alias | grep SHA1
```

### Kiểm tra package name:
```bash
grep applicationId android/app/build.gradle.kts
```

### Kiểm tra bundle ID:
```bash
grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj
```

## Logs hữu ích

### Console output thành công:
```
I/flutter: === Environment Configuration ===
I/flutter: Google Sign-In Configured: true
I/flutter: Google Sign-In initialized successfully
```

### Console output lỗi:
```
I/flutter: Google Sign-In configuration errors:
I/flutter: - Google Sign-In client IDs are not configured
```

## Checklist Debug

- [ ] File `.env` tồn tại và có đúng format
- [ ] Tất cả required fields trong `.env` đã được điền
- [ ] Google Sign-In API đã được bật
- [ ] OAuth Consent Screen đã được cấu hình
- [ ] SHA-1 fingerprint đúng và khớp
- [ ] Package name/Bundle ID khớp giữa app và Google Cloud Console
- [ ] Test trên thiết bị thật có Google Play Services
- [ ] Network connection ổn định

## Liên hệ hỗ trợ

Nếu vẫn gặp vấn đề sau khi thử các giải pháp trên:

1. Kiểm tra [Google Sign-In Documentation](https://developers.google.com/identity/sign-in/android)
2. Tạo issue trên [Flutter Google Sign-In GitHub](https://github.com/flutter/packages/tree/main/packages/google_sign_in)
3. Hỏi trên [Stack Overflow](https://stackoverflow.com/questions/tagged/google-signin+flutter)
