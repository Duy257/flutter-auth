### Hướng dẫn Upload Media (Flutter + Dio)

API này cho phép frontend upload ảnh/video/tài liệu vào collection `media`. File được lưu local dưới thư mục `uploads/` và public qua `GET /uploads/:filename`.

- **Base URL**: domain của backend (ví dụ: `http://localhost:3000` hoặc domain deploy)
- **Endpoint upload**: `POST /api/media`
- **Xác thực**: Không yêu cầu (đang mở public cho create/read)
- **Content-Type**: `multipart/form-data`

### Định dạng và giới hạn

- **Giới hạn dung lượng**: 5MB
- **MIME types hỗ trợ**:
  - Ảnh: `image/jpeg`, `image/jpg`, `image/png`, `image/gif`, `image/webp`, `image/svg+xml`
  - Video: `video/mp4`, `video/webm`, `video/ogg`
  - Tài liệu: `application/pdf`, `application/msword`, `application/vnd.openxmlformats-officedocument.wordprocessingml.document`, `application/vnd.ms-excel`, `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
  - Nén: `application/zip`, `application/x-rar-compressed`

### Trường form cần gửi

- **file** (bắt buộc): nội dung file nhị phân
- **alt** (bắt buộc): mô tả ngắn cho SEO/accessibility
- **caption** (tùy chọn): chú thích ngắn

Lưu ý: backend hiện đánh dấu `alt` là bắt buộc. Dù có logic tự sinh từ tên file ở hook, validation có thể chạy trước hook này, vì vậy frontend nên luôn gửi `alt` để tránh lỗi 400.

Trường `type` (image/video/document/other) sẽ được backend tự xác định dựa trên `mimeType` của file.

### Response

Thành công trả về `201` với document media vừa tạo. Trường quan trọng:

- `id`, `filename`, `mimeType`, `filesize`, có thể có `width`/`height` với ảnh
- `alt`, `caption`, `type`
- `createdAt`, `updatedAt`

Tạo URL public để hiển thị/download:

- `publicUrl = BASE_URL + '/uploads/' + filename`

Ví dụ: nếu `filename` là `photo-1712345678.webp` thì có thể truy cập: `GET /uploads/photo-1712345678.webp`.

### Ví dụ Flutter (Dio)

Thêm dependencies trong `pubspec.yaml` nếu chưa có:

```yaml
dependencies:
  dio: ^5.7.0
  http_parser: ^4.0.2
  path: ^1.9.0
```

Hàm upload mẫu:

```dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class MediaUploadResponse {
  final String id;
  final String filename;
  final String mimeType;
  final String? alt;
  final String type;
  final String publicUrl;

  MediaUploadResponse({
    required this.id,
    required this.filename,
    required this.mimeType,
    required this.type,
    required this.publicUrl,
    this.alt,
  });

  factory MediaUploadResponse.fromJson(Map<String, dynamic> json, String baseUrl) {
    final filename = json['filename'] as String;
    return MediaUploadResponse(
      id: json['id'] as String,
      filename: filename,
      mimeType: json['mimeType'] as String,
      type: (json['type'] as String?) ?? 'other',
      alt: json['alt'] as String?,
      publicUrl: '$baseUrl/uploads/$filename',
    );
  }
}

class MediaApi {
  final Dio _dio;
  final String baseUrl; // e.g., http://localhost:3000

  MediaApi(this.baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
        ));

  Future<MediaUploadResponse> uploadFile({
    required File file,
    String? alt,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final filePath = file.path;
    final fileName = p.basename(filePath);

    // Try to infer a reasonable content type; you may set it explicitly
    // (e.g., MediaType('image', 'jpeg')) if you know the type.
    final ext = p.extension(fileName).toLowerCase().replaceAll('.', '');
    MediaType? mediaType;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        mediaType = MediaType('image', 'jpeg');
        break;
      case 'png':
        mediaType = MediaType('image', 'png');
        break;
      case 'webp':
        mediaType = MediaType('image', 'webp');
        break;
      case 'gif':
        mediaType = MediaType('image', 'gif');
        break;
      case 'svg':
        mediaType = MediaType('image', 'svg+xml');
        break;
      case 'mp4':
        mediaType = MediaType('video', 'mp4');
        break;
      case 'webm':
        mediaType = MediaType('video', 'webm');
        break;
      case 'ogg':
        mediaType = MediaType('video', 'ogg');
        break;
      case 'pdf':
        mediaType = MediaType('application', 'pdf');
        break;
      case 'doc':
        mediaType = MediaType('application', 'msword');
        break;
      case 'docx':
        mediaType = MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
        break;
      case 'xls':
        mediaType = MediaType('application', 'vnd.ms-excel');
        break;
      case 'xlsx':
        mediaType = MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        break;
      case 'zip':
        mediaType = MediaType('application', 'zip');
        break;
      case 'rar':
        mediaType = MediaType('application', 'x-rar-compressed');
        break;
    }

    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      ),
      if (alt != null && alt.trim().isNotEmpty) 'alt': alt.trim(),
      // 'caption': 'optional caption'
    });

    final response = await _dio.post(
      '/api/media',
      data: form,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          // No auth header needed currently; add Bearer token here if you secure the endpoint later
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return MediaUploadResponse.fromJson(data, baseUrl);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Upload failed with status: ${response.statusCode}',
    );
  }
}
```

Cách sử dụng:

```dart
final api = MediaApi('http://localhost:3000');
final file = File('/path/to/image.jpg');

final uploaded = await api.uploadFile(
  file: file,
  alt: 'Ảnh sản phẩm áo thun trắng',
  onSendProgress: (sent, total) {
    if (total > 0) {
      final percent = (sent / total * 100).toStringAsFixed(0);
      print('Uploading... $percent%');
    }
  },
);

print('File URL: ${uploaded.publicUrl}');
```

### Lỗi thường gặp

- `413 Payload Too Large`: file vượt quá 5MB
- `400/415`: loại file không được hỗ trợ
- `500`: lỗi máy chủ

### Ghi chú

- Endpoint upload hiện đang mở (không cần auth). Nếu sau này bật bảo mật, cần gửi header `Authorization: Bearer <token>`.
- Server có logic tự sinh `alt`/`caption` từ tên file, nhưng do `alt` đang là bắt buộc ở bước validate, hãy luôn gửi `alt` từ phía client.
