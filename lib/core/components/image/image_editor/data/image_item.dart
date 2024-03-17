// ignore_for_file: prefer_constructors_over_static_methods

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Image item
class ImageItem {
  /// Creates a new image item
  ImageItem([dynamic img]) {
    if (img != null) load(img);
  }

  /// Image width
  int width = 300;

  /// Image height
  int height = 300;

  /// Image bytes
  Uint8List bytes = Uint8List.fromList([]);

  /// Image loader
  Completer<dynamic> loader = Completer();

  /// Image load future
  Future<dynamic> load(dynamic imageFile) async {
    loader = Completer();

    if (imageFile is ImageItem) {
      height = imageFile.height;
      width = imageFile.width;

      bytes = imageFile.bytes;
      loader.complete(true);
    } else {
      bytes = imageFile is Uint8List ? imageFile : await imageFile as Uint8List;
      final decodedImage = await decodeImageFromList(bytes);

      // image was decoded
      // print(['height', viewportSize.height, decodedImage.height]);
      // print(['width', viewportSize.width, decodedImage.width]);

      height = decodedImage.height;
      width = decodedImage.width;

      loader.complete(decodedImage);
    }

    return true;
  }

  ///from json
  static ImageItem fromJson(Map<dynamic, dynamic> json) {
    final image = ImageItem(json['image'])
      ..width = json['width'] as int
      ..height = json['height'] as int;

    return image;
  }

  ///to json
  Map<dynamic, dynamic> toJson() {
    return {
      'height': height,
      'width': width,
      'bytes': bytes,
    };
  }
}
