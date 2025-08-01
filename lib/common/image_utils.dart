import 'dart:io';
import 'package:dio/dio.dart';

class ImageUtils {
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

  /// Validates if the image file is acceptable for upload
  static Future<Map<String, dynamic>> validateImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      
      // Check if file exists
      if (!await file.exists()) {
        return {
          'isValid': false,
          'error': 'Image file not found'
        };
      }

      // Check file size
      final fileSize = await file.length();
      if (fileSize > maxFileSize) {
        return {
          'isValid': false,
          'error': 'Image file too large. Maximum size is ${maxFileSize ~/ (1024 * 1024)}MB'
        };
      }

      // Check file extension
      String fileName = imagePath.split('/').last;
      String fileExtension = fileName.split('.').last.toLowerCase();
      
      if (!allowedExtensions.contains(fileExtension)) {
        return {
          'isValid': false,
          'error': 'Invalid file type. Allowed types: ${allowedExtensions.join(', ').toUpperCase()}'
        };
      }

      return {
        'isValid': true,
        'fileName': fileName,
        'fileExtension': fileExtension,
        'fileSize': fileSize,
        'mimeType': getMimeType(fileExtension)
      };
    } catch (e) {
      return {
        'isValid': false,
        'error': 'Error validating image file: $e'
      };
    }
  }

  /// Gets the MIME type based on file extension
  static String getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }

  /// Creates FormData for image upload with proper validation
  static Future<FormData?> createImageFormData(String imagePath, String fieldName) async {
    final validation = await validateImageFile(imagePath);
    
    if (!validation['isValid']) {
      throw Exception(validation['error']);
    }

    return FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        imagePath,
        filename: validation['fileName'],
        contentType: DioMediaType.parse(validation['mimeType']),
      ),
    });
  }

  /// Formats file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Checks if file is an image based on extension
  static bool isImageFile(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }
} 