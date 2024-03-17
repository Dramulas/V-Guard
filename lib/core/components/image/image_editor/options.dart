// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class OutputFormat {
  static const int

      /// get all layers in json
      json = 0x1;
  static const int heic = 0x2;
  static const int jpeg = 0x4;
  static const int png = 0x8;
  static const int webp = 0x10;
}

class AspectRatio {
  const AspectRatio({required this.title, this.ratio});
  final String title;
  final double? ratio;
}

class CropOption {
  const CropOption({
    this.reversible = true,
    this.ratios = const [
      AspectRatio(title: 'Freeform'),
      AspectRatio(title: '1:1', ratio: 1),
      AspectRatio(title: '4:3', ratio: 4 / 3),
      AspectRatio(title: '5:4', ratio: 5 / 4),
      AspectRatio(title: '7:5', ratio: 7 / 5),
      AspectRatio(title: '16:9', ratio: 16 / 9),
    ],
  });
  final bool reversible;

  /// List of availble ratios
  final List<AspectRatio> ratios;
}

class BlurOption {
  const BlurOption();
}

class BrushOption {
  const BrushOption({
    this.showBackground = true,
    this.translatable = false,
    this.colors = const [
      BrushColor(color: Colors.black, background: Colors.white),
      BrushColor(color: Colors.white),
      BrushColor(color: Colors.blue),
      BrushColor(color: Colors.green),
      BrushColor(color: Colors.pink),
      BrushColor(color: Colors.purple),
      BrushColor(color: Colors.brown),
      BrushColor(color: Colors.indigo),
    ],
  });

  /// show background image on draw screen
  final bool showBackground;

  /// User will able to move, zoom drawn image
  /// Note: Layer may not be placed precisely
  final bool translatable;
  final List<BrushColor> colors;
}

class BrushColor {
  const BrushColor({
    required this.color,
    this.background = Colors.black,
  });

  /// Color of brush
  final Color color;

  ///Background color while brush is active only  when showBackground is false
  final Color background;
}

class EmojiOption {
  const EmojiOption();
}

class FlipOption {
  const FlipOption();
}

class RotateOption {
  const RotateOption();
}

class TextOption {
  const TextOption();
}

class ImagePickerOption {
  const ImagePickerOption({
    this.pickFromGallery = false,
    this.captureFromCamera = false,
    this.maxLength = 99,
  });
  final bool pickFromGallery;
  final bool captureFromCamera;
  final int maxLength;
}
