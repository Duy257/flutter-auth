# Hướng dẫn cấu hình Google Sign In

## Cấu hình cho Android

1. **Tạo dự án trên Google Cloud Console:**
   - Truy cập [Google Cloud Console](https://console.cloud.google.com/)
   - Tạo dự án mới hoặc chọn dự án hiện có
   - Bật Google Sign-In API

2. **Tạo OAuth 2.0 Client ID:**
   - Vào "APIs & Services" > "Credentials"
   - Tạo "OAuth 2.0 Client ID" cho Android
   - Package name: `com.example.flutter_application_1`
   - SHA-1 certificate fingerprint: Lấy từ debug keystore

3. **Lấy SHA-1 fingerprint:**
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

4. **Tải file google-services.json:**
   - Tải file `google-services.json` từ Firebase Console
   - Đặt file vào thư mục `android/app/`

5. **Cập nhật build.gradle:**
   - Thêm vào `android/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services") version "4.4.0" apply false
   }
   ```
   
   - Thêm vào `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

## Cấu hình cho iOS

1. **Tạo OAuth 2.0 Client ID cho iOS:**
   - Tạo "OAuth 2.0 Client ID" cho iOS
   - Bundle ID: `com.example.flutterApplication1`

2. **Cập nhật Info.plist:**
   - Thêm URL scheme vào `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

## Sử dụng

Sau khi cấu hình xong, bạn có thể chạy ứng dụng:

```bash
flutter pub get
flutter run
```

## Lưu ý

- Để test Google Sign In, bạn cần chạy trên thiết bị thật hoặc emulator có Google Play Services
- Đảm bảo rằng email test đã được thêm vào danh sách test users trong Google Cloud Console
- Trong môi trường production, cần cấu hình release keystore và cập nhật SHA-1 fingerprint tương ứng
