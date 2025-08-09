# Hướng dẫn Flutter: Tạo Category với Name và Image

## Tổng quan

Tài liệu này hướng dẫn cách tạo category mới từ Flutter app với hai trường cơ bản:

- **name**: Tên danh mục (bắt buộc)
- **img**: Hình ảnh đại diện (tùy chọn)

## Dependencies

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  image_picker: ^1.0.4
  path: ^1.8.3
  mime: ^1.0.4

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Chạy lệnh để cài đặt dependencies:

```bash
flutter pub get
```

## Permissions

### Android

Thêm vào `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS

Thêm vào `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photo library to select images</string>
```

## API Endpoint

### URL

```
POST /api/category
```

### Content-Type

```
multipart/form-data
```

### Request Body

- **name** (string, required): Tên danh mục
  - Tối thiểu: 2 ký tự
  - Tối đa: 100 ký tự
  - Phải unique
- **img** (file, optional): File hình ảnh
  - Định dạng hỗ trợ: JPEG, PNG, GIF, WebP, SVG
  - Kích thước tối đa: 5MB

## Implementation

### 1. Service Class

Tạo file `lib/services/category_service.dart`:

```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'dart:convert';

class CategoryService {
  static const String baseUrl = 'YOUR_API_BASE_URL'; // Thay bằng URL thực tế

  static Future<Map<String, dynamic>> createCategory({
    required String name,
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/category');
      final request = http.MultipartRequest('POST', uri);

      // Thêm tên danh mục
      request.fields['name'] = name;

      // Thêm hình ảnh nếu có
      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path);
        final multipartFile = await http.MultipartFile.fromPath(
          'img',
          imageFile.path,
          contentType: mimeType != null ?
            http_parser.MediaType.parse(mimeType) : null,
        );
        request.files.add(multipartFile);
      }

      // Gửi request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['errors']?[0]?['message'] ??
          'HTTP error! status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }
}
```

### 2. Model Class

Tạo file `lib/models/category.dart`:

```dart
class Category {
  final String id;
  final String name;
  final String? slug;
  final CategoryImage? img;
  final String? parent;
  final bool isFeature;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.img,
    this.parent,
    required this.isFeature,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      img: json['img'] != null ? CategoryImage.fromJson(json['img']) : null,
      parent: json['parent'],
      isFeature: json['isFeature'] ?? false,
      metaTitle: json['metaTitle'],
      metaDescription: json['metaDescription'],
      metaKeywords: json['metaKeywords'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CategoryImage {
  final String id;
  final String url;
  final String filename;
  final String mimeType;
  final int filesize;
  final int? width;
  final int? height;
  final String? alt;

  CategoryImage({
    required this.id,
    required this.url,
    required this.filename,
    required this.mimeType,
    required this.filesize,
    this.width,
    this.height,
    this.alt,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      id: json['id'],
      url: json['url'],
      filename: json['filename'],
      mimeType: json['mimeType'],
      filesize: json['filesize'],
      width: json['width'],
      height: json['height'],
      alt: json['alt'],
    );
  }
}
```

### 3. Response Format

#### Success Response (201 Created)

```json
{
  "message": "Category created successfully.",
  "doc": {
    "id": "67890abcdef123456789",
    "name": "Electronics",
    "slug": "electronics",
    "img": {
      "id": "12345abcdef67890123",
      "url": "/uploads/electronics-1234567890.jpg",
      "filename": "electronics.jpg",
      "mimeType": "image/jpeg",
      "filesize": 245760,
      "width": 800,
      "height": 600,
      "alt": "Electronics category image"
    },
    "parent": null,
    "isFeature": false,
    "metaTitle": "Electronics",
    "metaDescription": null,
    "metaKeywords": null,
    "createdAt": "2024-01-15T10:30:00.000Z",
    "updatedAt": "2024-01-15T10:30:00.000Z"
  }
}
```

#### Error Response (400 Bad Request)

```json
{
  "errors": [
    {
      "message": "Category name must be at least 2 characters",
      "field": "name"
    }
  ]
}
```

## Flutter Widget Example

### 4. Category Create Form Widget

Tạo file `lib/widgets/category_create_form.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryCreateForm extends StatefulWidget {
  final Function(Category)? onSuccess;
  final Function(String)? onError;

  const CategoryCreateForm({
    Key? key,
    this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<CategoryCreateForm> createState() => _CategoryCreateFormState();
}

class _CategoryCreateFormState extends State<CategoryCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Chọn hình ảnh từ gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      widget.onError?.call('Error selecting image: $e');
    }
  }

  // Chụp ảnh từ camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      widget.onError?.call('Error taking photo: $e');
    }
  }

  // Hiển thị dialog chọn nguồn ảnh
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('From Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Xóa hình ảnh đã chọn
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Xử lý submit form
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await CategoryService.createCategory(
        name: _nameController.text.trim(),
        imageFile: _selectedImage,
      );

      // Parse response
      final category = Category.fromJson(result['doc']);

      // Reset form
      _nameController.clear();
      setState(() {
        _selectedImage = null;
      });

      widget.onSuccess?.call(category);
    } catch (e) {
      widget.onError?.call(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tên danh mục
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name *',
              hintText: 'Enter category name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter category name';
              }
              if (value.trim().length < 2) {
                return 'Category name must be at least 2 characters';
              }
              if (value.trim().length > 100) {
                return 'Category name must not exceed 100 characters';
              }
              return null;
            },
            enabled: !_isLoading,
          ),

          const SizedBox(height: 16),

          // Hình ảnh
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              if (_selectedImage != null) ...[
                // Hiển thị ảnh đã chọn
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _showImageSourceDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text('Change'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _isLoading ? null : _removeImage,
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove'),
                    ),
                  ],
                ),
              ] else ...[
                // Nút chọn ảnh
                InkWell(
                  onTap: _isLoading ? null : _showImageSourceDialog,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Select Image',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Nút submit
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Creating...'),
                    ],
                  )
                : const Text(
                    'Create Category',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
```

### 5. Usage Example

Tạo file `lib/screens/category_create_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../widgets/category_create_form.dart';
import '../models/category.dart';

class CategoryCreateScreen extends StatelessWidget {
  const CategoryCreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CategoryCreateForm(
          onSuccess: (Category category) {
            // Hiển thị thông báo thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Category "${category.name}" created successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            // Quay lại màn hình trước
            Navigator.pop(context, category);
          },
          onError: (String error) {
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### 6. Navigation Example

Để điều hướng đến màn hình tạo category:

```dart
// Từ màn hình khác
ElevatedButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryCreateScreen(),
      ),
    );

    if (result != null && result is Category) {
      // Xử lý khi tạo category thành công
      print('Created category: ${result.name}');
    }
  },
  child: const Text('Create Category'),
)
```

## Validation Rules

### Name Field

- **Required**: Bắt buộc phải có
- **Min length**: 2 ký tự
- **Max length**: 100 ký tự
- **Unique**: Không được trùng với category khác
- **Auto-generated slug**: Slug sẽ được tự động tạo từ name

### Image Field

- **Optional**: Không bắt buộc
- **File types**: JPEG, PNG, GIF, WebP, SVG
- **Max size**: 5MB
- **Auto-upload**: File sẽ được upload vào collection `media`

## Error Handling

### Common Errors

1. **Validation Error (400)**

   ```json
   {
     "errors": [
       {
         "message": "Category name must be at least 2 characters",
         "field": "name"
       }
     ]
   }
   ```

2. **Duplicate Name (400)**

   ```json
   {
     "errors": [
       {
         "message": "Category with this name already exists",
         "field": "name"
       }
     ]
   }
   ```

3. **File Too Large (413)**

   ```json
   {
     "errors": [
       {
         "message": "File size exceeds 5MB limit",
         "field": "img"
       }
     ]
   }
   ```

4. **Invalid File Type (400)**
   ```json
   {
     "errors": [
       {
         "message": "Invalid file type. Only images are allowed",
         "field": "img"
       }
     ]
   }
   ```

## Best Practices

1. **Validation phía client**: Validate input trước khi gửi request
2. **Image optimization**: Resize và compress ảnh trước khi upload
3. **Loading state**: Hiển thị trạng thái loading khi đang xử lý
4. **Error handling**: Xử lý và hiển thị lỗi một cách user-friendly
5. **File size check**: Kiểm tra kích thước file trước khi upload
6. **Reset form**: Reset form sau khi tạo thành công
7. **Permission handling**: Xử lý quyền camera và storage một cách graceful

## Notes

- Slug sẽ được tự động generate từ name
- Image sẽ được lưu trong collection `media` và reference vào category
- URL hình ảnh có thể truy cập qua `/uploads/filename.ext`
- Category mới tạo sẽ có `isFeature: false` và `parent: null` mặc định
- Cần thêm import `http_parser` trong CategoryService: `import 'package:http_parser/http_parser.dart' as http_parser;`
