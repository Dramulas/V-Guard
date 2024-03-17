// ignore: lines_longer_than_80_chars
// ignore_for_file: public_member_api_docs,, prefer_constructors_over_static_methods

import 'package:flutter/material.dart';
import 'package:valorant/core/components/image/image_editor/data/image_item.dart';

/// Layer class with some common properties
class Layer {
  /// Creates a new layer
  Layer({
    this.offset = const Offset(64, 64),
    this.opacity = 1,
    this.rotation = 0,
    this.scale = 1,
  });

  /// Layer offset
  Offset offset;

  /// Layer opacity
  late double rotation;

  /// Layer scale
  late double scale;

  /// Layer opacity
  late double opacity;

  /// Copy from json
  void copyFrom(Map<dynamic, dynamic> json) {
    // ignore: avoid_dynamic_calls
    offset = Offset(json['offset'][0] as double, json['offset'][1] as double);
    opacity = json['opacity'] as double;
    rotation = json['rotation'] as double;
    scale = json['scale'] as double;
  }

  /// From json
  static Layer fromJson(Map<dynamic, dynamic> json) {
    switch (json['type']) {
      case 'BackgroundLayer':
        return BackgroundLayerData.fromJson(json);
      case 'EmojiLayer':
        return EmojiLayerData.fromJson(json);
      case 'ImageLayer':
        return ImageLayerData.fromJson(json);
      case 'LinkLayer':
        return LinkLayerData.fromJson(json);
      case 'TextLayer':
        return TextLayerData.fromJson(json);
      case 'BackgroundBlurLayer':
        return BackgroundBlurLayerData.fromJson(json);
      default:
        return Layer();
    }
  }

  /// To json
  Map<dynamic, dynamic> toJson() {
    return {
      'offset': [offset.dx, offset.dy],
      'opacity': opacity,
      'rotation': rotation,
      'scale': scale,
    };
  }
}

/// Background layer
class BackgroundLayerData extends Layer {
  /// Background layer constructor
  BackgroundLayerData({
    required this.image,
  });

  /// Background image
  ImageItem image;

  /// From json
  static BackgroundLayerData fromJson(Map<dynamic, dynamic> json) {
    return BackgroundLayerData(
      image: ImageItem.fromJson(json['image'] as Map<dynamic, dynamic>),
    );
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'type': 'BackgroundLayer',
      'image': image.toJson(),
    };
  }
}

class EmojiLayerData extends Layer {
  EmojiLayerData({
    this.text = '',
    this.size = 64,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });
  String text;
  double size;

  static EmojiLayerData fromJson(Map<dynamic, dynamic> json) {
    final layer = EmojiLayerData(
      text: json['text'] as String,
      size: json['size'] as double,
    )..copyFrom(json);
    return layer;
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'type': 'EmojiLayer',
      'text': text,
      'size': size,
      ...super.toJson(),
    };
  }
}

class ImageLayerData extends Layer {
  ImageLayerData({
    required this.image,
    this.size = 64,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });
  ImageItem image;
  double size;

  static ImageLayerData fromJson(Map<dynamic, dynamic> json) {
    final layer = ImageLayerData(
      image: ImageItem.fromJson(json['image'] as Map<dynamic, dynamic>),
      size: json['size'] as double,
    )..copyFrom(json);
    return layer;
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'type': 'ImageLayer',
      'image': image.toJson(),
      'size': size,
      ...super.toJson(),
    };
  }
}

class TextLayerData extends Layer {
  TextLayerData({
    required this.text,
    this.size = 64,
    this.color = Colors.white,
    this.background = Colors.transparent,
    this.backgroundOpacity = 0,
    this.align = TextAlign.left,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });
  String text;
  double size;
  Color color;
  Color background;
  double backgroundOpacity;
  TextAlign align;

  static TextLayerData fromJson(Map<dynamic, dynamic> json) {
    final layer = TextLayerData(
      text: json['text'] as String,
      size: json['size'] as double,
      color: Color(json['color'] as int),
      background: Color(json['background'] as int),
      backgroundOpacity: json['backgroundOpacity'] as double,
      align: TextAlign.values.firstWhere((e) => e.name == json['align']),
    )..copyFrom(json);
    return layer;
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'type': 'TextLayer',
      'text': text,
      'size': size,
      'color': color.value,
      'background': background.value,
      'backgroundOpacity': backgroundOpacity,
      'align': align.name,
      ...super.toJson(),
    };
  }
}

class LinkLayerData extends Layer {
  LinkLayerData({
    required this.text,
    this.size = 64,
    this.color = Colors.white,
    this.background = Colors.transparent,
    this.backgroundOpacity = 0,
    this.align = TextAlign.left,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });
  String text;
  double size;
  Color color;
  Color background;
  double backgroundOpacity;
  TextAlign align;

  static LinkLayerData fromJson(Map<dynamic, dynamic> json) {
    final layer = LinkLayerData(
      text: json['text'] as String,
      size: json['size'] as double,
      color: Color(json['color'] as int),
      background: Color(json['background'] as int),
      backgroundOpacity: json['backgroundOpacity'] as double,
      align: TextAlign.values.firstWhere((e) => e.name == json['align']),
    )..copyFrom(json);
    return layer;
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'type': 'LinkLayer',
      'text': text,
      'size': size,
      'color': color.value,
      'background': background.value,
      'backgroundOpacity': backgroundOpacity,
      'align': align.name,
      ...super.toJson(),
    };
  }
}

class BackgroundBlurLayerData extends Layer {
  BackgroundBlurLayerData({
    required this.color,
    required this.radius,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });
  Color color;
  double radius;

  static BackgroundBlurLayerData fromJson(Map<dynamic, dynamic> json) {
    final layer = BackgroundBlurLayerData(
      color: Color(json['color'] as int),
      radius: json['radius'] as double,
    )..copyFrom(json);
    return layer;
  }

  @override
  Map<dynamic, dynamic> toJson() {
    return {
      'type': 'BackgroundBlurLayer',
      'color': color.value,
      'radius': radius,
      ...super.toJson(),
    };
  }
}
