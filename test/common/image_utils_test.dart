import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/common/image_utils.dart';

void main() {
  group('ImageUtils Tests', () {
    test('should validate correct MIME types', () {
      expect(ImageUtils.getMimeType('jpg'), equals('image/jpeg'));
      expect(ImageUtils.getMimeType('jpeg'), equals('image/jpeg'));
      expect(ImageUtils.getMimeType('png'), equals('image/png'));
      expect(ImageUtils.getMimeType('gif'), equals('image/gif'));
      expect(ImageUtils.getMimeType('webp'), equals('image/webp'));
    });

    test('should check if file is image based on extension', () {
      expect(ImageUtils.isImageFile('test.jpg'), isTrue);
      expect(ImageUtils.isImageFile('test.jpeg'), isTrue);
      expect(ImageUtils.isImageFile('test.png'), isTrue);
      expect(ImageUtils.isImageFile('test.gif'), isTrue);
      expect(ImageUtils.isImageFile('test.webp'), isTrue);
      expect(ImageUtils.isImageFile('test.pdf'), isFalse);
      expect(ImageUtils.isImageFile('test.txt'), isFalse);
    });

    test('should format file size correctly', () {
      expect(ImageUtils.formatFileSize(500), equals('500 B'));
      expect(ImageUtils.formatFileSize(1024), equals('1.0 KB'));
      expect(ImageUtils.formatFileSize(1024 * 1024), equals('1.0 MB'));
      expect(ImageUtils.formatFileSize(2 * 1024 * 1024), equals('2.0 MB'));
    });

    test('should have correct allowed extensions', () {
      expect(ImageUtils.allowedExtensions, contains('jpg'));
      expect(ImageUtils.allowedExtensions, contains('jpeg'));
      expect(ImageUtils.allowedExtensions, contains('png'));
      expect(ImageUtils.allowedExtensions, contains('gif'));
      expect(ImageUtils.allowedExtensions, contains('webp'));
      expect(ImageUtils.allowedExtensions.length, equals(5));
    });

    test('should have correct max file size', () {
      expect(ImageUtils.maxFileSize, equals(5 * 1024 * 1024)); // 5MB
    });
  });
} 