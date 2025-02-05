import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Image utils.
class ImageUtils {
  /// Converts image to [Uint8List].
  static Future<Uint8List> convert(
    dynamic image, {
    String format = 'jpeg',
    int quality = 80,
    int? height,
    int? width,
    bool preserveExif = true,
  }) async {
    const formatMap = <String, CompressFormat>{
      'jpeg': CompressFormat.jpeg,
      'heic': CompressFormat.heic,
      'png': CompressFormat.png,
      'webp': CompressFormat.webp,
    };

    if (!formatMap.containsKey(format)) {
      throw Exception('Output format not supported by library.');
    }

    if (image is Uint8List) {
      final output = await FlutterImageCompress.compressWithList(
        image,
        quality: quality,
        format: formatMap[format]!,
        minHeight: height ?? 1080,
        minWidth: width ?? 1920,
        keepExif: preserveExif,
      );

      return output;
    } else if (image is String) {
      final output = await FlutterImageCompress.compressWithFile(
        image,
        quality: quality,
        format: formatMap[format]!,
        minHeight: height ?? 1080,
        minWidth: width ?? 1920,
        keepExif: preserveExif,
      );

      if (output == null) {
        throw Exception('Unable to compress image file');
      }

      return output;
    } else {
      throw Exception('Image must be a Uint8List or path.');
    }
  }

  /// Converts all images to [Uint8List].
  static Future<List<Uint8List>> convertAll(
    List<dynamic> images, {
    String format = 'jpeg',
    int quality = 80,
  }) async {
    final outputs = <Uint8List>[];

    for (final image in images) {
      outputs.add(
        await convert(
          image,
          format: format,
          quality: quality,
        ),
      );
    }

    return outputs;
  }
}
