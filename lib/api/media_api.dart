import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart' as mime;
import 'package:logger/web.dart';

import 'base_api_client.dart';

/// API client for media upload operations
/// Supports uploading images/videos/documents via multipart/form-data
class MediaApi {
  /// Upload a media file to the backend
  ///
  /// [file] - The file to upload (required)
  /// [alt] - Short description for SEO/accessibility (optional but recommended)
  /// [caption] - Optional caption
  /// [onSendProgress] - Upload progress callback
  ///
  /// Returns a map with success status and data/error
  static Future<Map<String, dynamic>> upload({
    required File file,
    String? alt,
    String? caption,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    return BaseApiClient.makeRequest(
      operation: 'Media upload',
      request: () async {
        final fileName = file.path.split('/').last;

        // Infer content type, fallback to image/jpeg if unknown
        final detectedMime = mime.lookupMimeType(file.path) ?? 'image/jpeg';
        final typeParts = detectedMime.split('/');
        final mediaType = MediaType(
          typeParts.first,
          typeParts.length > 1 ? typeParts[1] : 'jpeg',
        );

        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: mediaType,
          ),
          if (alt != null && alt.trim().isNotEmpty) 'alt': alt.trim(),
          if (caption != null && caption.trim().isNotEmpty)
            'caption': caption.trim(),
        });

        Logger().d('Uploading media: name=$fileName, alt=${alt ?? ''}');
        Logger().w('Uploading media: formData=$formData');

        return BaseApiClient.dio.post(
          '/api/media',
          data: formData,
          onSendProgress: onSendProgress,
          options: Options(
            // Ensure multipart header overrides the default JSON header
            headers: {'Content-Type': 'multipart/form-data'},
          ),
        );
      },
    );
  }
}
