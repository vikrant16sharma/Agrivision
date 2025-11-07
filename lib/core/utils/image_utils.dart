import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:convert';

class ImageUtils {
  /// Convert image file to base64 string
  static Future<String> imageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  /// Convert image file to base64 with data URI prefix
  static Future<String> imageToBase64DataUri(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64String = base64Encode(bytes);
    return 'data:image/jpeg;base64,$base64String';
  }

  /// Compress and resize image
  static Future<File> compressImage(
      File imageFile, {
        int maxWidth = 640,
        int quality = 85,
      }) async {
    // Read image
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize if needed
    final resized = image.width > maxWidth
        ? img.copyResize(image, width: maxWidth)
        : image;

    // Compress
    final compressed = img.encodeJpg(resized, quality: quality);

    // Save to temporary file
    final tempPath = '${imageFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressedFile = File(tempPath);
    await compressedFile.writeAsBytes(compressed);

    return compressedFile;
  }

  /// Preprocess image for ML model (224x224, normalized)
  static Future<List<List<List<double>>>> preprocessForML(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to 224x224
    final resized = img.copyResize(image, width: 224, height: 224);

    // Convert to normalized 3D array
    final imageArray = List.generate(
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

    return imageArray;
  }
}