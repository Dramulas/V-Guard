import 'package:flutter/material.dart';
import 'package:valorant/core/components/image/image_editor/data/layer.dart';

/// Main layer
class BackgroundLayer extends StatefulWidget {
  /// Background layer constructor
  const BackgroundLayer({
    required this.layerData,
    super.key,
    this.onUpdate,
    this.editable = false,
  });

  /// Background layer data
  final BackgroundLayerData layerData;

  /// On update callback
  final VoidCallback? onUpdate;

  /// Editable
  final bool editable;

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.layerData.image.width.toDouble(),
      height: widget.layerData.image.height.toDouble(),
      // color: black,
      padding: EdgeInsets.zero,
      child: Image.memory(widget.layerData.image.bytes),
    );
  }
}
