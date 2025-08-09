import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';

import '../api/media_api.dart';
import '../config/env_config.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _altController = TextEditingController();

  File? _selectedFile;
  String? _uploadedImageUrl;
  double? _progress01;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _altController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _errorMessage = null;
    });

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
    );
    if (picked == null) return;

    final File file = File(picked.path);
    final String fileName = picked.name;
    final String defaultAlt = fileName
        .replaceAll(RegExp(r'\.[^.]*$'), '')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .trim();

    setState(() {
      _selectedFile = file;
      _uploadedImageUrl = null;
      if (_altController.text.trim().isEmpty) {
        _altController.text = defaultAlt;
      }
    });
  }

  Future<void> _upload() async {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'Vui lòng chọn ảnh trước.';
      });
      return;
    }

    final String alt = _altController.text.trim();
    if (alt.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập mô tả (alt).';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _progress01 = 0;
      _errorMessage = null;
      _uploadedImageUrl = null;
    });

    final result = await MediaApi.upload(
      file: _selectedFile!,
      alt: alt,
      onSendProgress: (sent, total) {
        if (total > 0) {
          setState(() {
            _progress01 = sent / total;
          });
        }
      },
    );

    if (!mounted) return;

    if (result['success'] == true) {
      final data = result['data']['doc'] as Map<String, dynamic>?;
      final filename = data?['filename'] as String?;

      if (filename != null && filename.isNotEmpty) {
        final baseUrl = EnvConfig.instance.baseUrl;
        final imageUrl = '$baseUrl/uploads/$filename';
        setState(() {
          _uploadedImageUrl = imageUrl;
          _isUploading = false;
          _progress01 = null;
        });
      } else {
        setState(() {
          _errorMessage = 'Upload thành công nhưng thiếu tên file từ server.';
          _isUploading = false;
          _progress01 = null;
        });
      }
    } else {
      final errorText = (result['error'] as String?) ?? 'Upload thất bại.';
      setState(() {
        _errorMessage = errorText;
        _isUploading = false;
        _progress01 = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Ảnh')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Chọn từ thư viện'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Chụp ảnh'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _altController,
              enabled: !_isUploading,
              decoration: const InputDecoration(
                labelText: 'Mô tả (alt) – bắt buộc',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedFile != null) ...[
              Text(
                'Xem trước (local):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedFile!,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _upload,
              icon: const Icon(Icons.cloud_upload_outlined),
              label: Text(_isUploading ? 'Đang upload...' : 'Upload'),
            ),
            if (_isUploading && _progress01 != null) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: _progress01!.clamp(0, 1)),
              const SizedBox(height: 8),
              Text('${((_progress01 ?? 0) * 100).toStringAsFixed(0)}%'),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            if (_uploadedImageUrl != null) ...[
              Text(
                'Ảnh sau khi upload (server):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _uploadedImageUrl!,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                _uploadedImageUrl!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
