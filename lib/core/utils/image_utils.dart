import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';

class ImageUtils {
  /// Convert image file to base64 string
  /// Uses compute for heavy processing to avoid UI jank
  static Future<String> imageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return compute(_encodeBase64, bytes);
  }

  static String _encodeBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// Convert image file to base64 with data URI prefix
  /// Optimized for better performance
  static Future<String> imageToBase64DataUri(File imageFile) async {
    final base64String = await imageToBase64(imageFile);
    return 'data:image/jpeg;base64,$base64String';
  }

  /// Compress and resize image
  /// Uses isolate (compute) to avoid blocking the UI thread
  static Future<File> compressImage(
      File imageFile, {
        int maxWidth = 640,
        int quality = 85,
      }) async {
    final bytes = await imageFile.readAsBytes();

    // Perform heavy image processing in background isolate
    final compressedBytes = await compute(
      _compressImageInIsolate,
      _ImageCompressionParams(bytes, maxWidth, quality),
    );

    // Save to temporary file
    final tempDir = imageFile.parent.path;
    final tempPath = '$tempDir/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressedFile = File(tempPath);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  static Uint8List _compressImageInIsolate(_ImageCompressionParams params) {
    // Decode image
    final image = img.decodeImage(params.bytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize if needed
    final resized = image.width > params.maxWidth
        ? img.copyResize(image, width: params.maxWidth)
        : image;

    // Compress to JPEG
    return Uint8List.fromList(img.encodeJpg(resized, quality: params.quality));
  }

  /// Preprocess image for ML model (224x224, normalized)
  /// Uses isolate for CPU-intensive work
  static Future<List<List<List<double>>>> preprocessForML(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return compute(_preprocessInIsolate, bytes);
  }

  static List<List<List<double>>> _preprocessInIsolate(Uint8List bytes) {
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to 224x224
    final resized = img.copyResize(image, width: 224, height: 224);

    // Convert to normalized 3D array
    return List.generate(
      224,
          (y) => List.generate(
        224,
            (x) {
          final pixel = resized.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        },
      ),
    );
  }

  /// Get image file size in MB
  static Future<double> getImageSizeInMB(File imageFile) async {
    final bytes = await imageFile.length();
    return bytes / (1024 * 1024);
  }

  /// Check if image needs compression
  static Future<bool> needsCompression(
      File imageFile, {
        double maxSizeInMB = 2.0,
        int maxWidth = 1024,
      }) async {
    final sizeInMB = await getImageSizeInMB(imageFile);
    if (sizeInMB > maxSizeInMB) return true;

    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image != null && image.width > maxWidth) return true;

    return false;
  }
}

/// Helper class for passing parameters to isolate
class _ImageCompressionParams {
  final Uint8List bytes;
  final int maxWidth;
  final int quality;

  _ImageCompressionParams(this.bytes, this.maxWidth, this.quality);
}
