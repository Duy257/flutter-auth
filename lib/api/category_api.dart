import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'base_api_client.dart';

/// API client for category-related operations
/// Handles category creation and management
class CategoryApi {
  /// Create a new category with name and optional image
  ///
  /// [name] - Category name (required)
  /// [imageFile] - Image file for the category (optional)
  ///
  /// Returns a map with success status and data/error
  static Future<Map<String, dynamic>> create({
    required String name,
    File? imageFile,
    String? imageUrl,
    String? imageId,
  }) async {
    return BaseApiClient.makeRequest(
      operation: 'Category creation',
      request: () async {
        // If an image ID is provided (media relation), send JSON payload
        if (imageId != null && imageId.isNotEmpty) {
          final payload = {'name': name, 'img': imageId};
          Logger().d('Creating category with imageId: $imageId');
          return BaseApiClient.dio.post('/api/category', data: payload);
        }

        // If an image URL is provided, send JSON payload
        if (imageUrl != null && imageUrl.isNotEmpty) {
          final payload = {'name': name, 'imgUrl': imageUrl};
          Logger().d('Creating category with imageUrl: $imageUrl');
          return BaseApiClient.dio.post('/api/category', data: payload);
        }

        // Otherwise, fall back to multipart with file if provided
        if (imageFile != null) {
          final formData = FormData.fromMap({'name': name});
          formData.files.add(
            MapEntry(
              'img',
              await MultipartFile.fromFile(
                imageFile.path,
                filename: imageFile.path.split('/').last,
              ),
            ),
          );
          Logger().d(formData.fields);
          return BaseApiClient.dio.post('/api/category', data: formData);
        }

        // No image provided at all; send JSON with just the name
        return BaseApiClient.dio.post('/api/category', data: {'name': name});
      },
    );
  }
}
