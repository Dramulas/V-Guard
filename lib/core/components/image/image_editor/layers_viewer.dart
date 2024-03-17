// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:valorant/core/components/image/image_editor/data/layer.dart';
import 'package:valorant/core/components/image/image_editor/layers/background_layer.dart';
import 'package:valorant/core/components/image/image_editor/layers/image_layer.dart';

/// View stacked layers (unbounded height, width)
class LayersViewer extends StatelessWidget {
  const LayersViewer({
    required this.layers,
    required this.editable,
    super.key,
    this.onUpdate,
  });
  final List<Layer> layers;
  final void Function()? onUpdate;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: layers.map((layerItem) {
        // Background layer
        if (layerItem is BackgroundLayerData) {
          return BackgroundLayer(
            layerData: layerItem,
            onUpdate: onUpdate,
            editable: editable,
          );
        }

        // Image layer
        if (layerItem is ImageLayerData) {
          return ImageLayer(
            layerData: layerItem,
            onUpdate: onUpdate,
            editable: editable,
          );
        }

        // Blank layer
        return Container();
      }).toList(),
    );
  }
}
