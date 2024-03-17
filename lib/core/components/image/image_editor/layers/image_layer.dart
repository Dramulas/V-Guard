import 'package:flutter/material.dart';
import 'package:valorant/core/components/image/image_editor/data/layer.dart';
import 'package:valorant/core/components/image/image_editor/image_editor_plus.dart';
import 'package:valorant/core/components/image/image_editor/modules/image_layer_overlay.dart';

/// Image layer that can be used to add overlay images and drawings
class ImageLayer extends StatefulWidget {
  /// Image layer constructor
  const ImageLayer({
    required this.layerData,
    super.key,
    this.onUpdate,
    this.editable = false,
  });

  /// Image layer data
  final ImageLayerData layerData;

  /// On update callback
  final VoidCallback? onUpdate;

  /// Editable
  final bool editable;

  @override
  State<ImageLayer> createState() => _ImageLayerState();
}

class _ImageLayerState extends State<ImageLayer> {
  double initialSize = 0;
  double initialRotation = 0;

  @override
  Widget build(BuildContext context) {
    initialSize = widget.layerData.size;
    initialRotation = widget.layerData.rotation;

    return Positioned(
      left: widget.layerData.offset.dx,
      top: widget.layerData.offset.dy,
      child: GestureDetector(
        onTap: widget.editable
            ? () {
                showModalBottomSheet<dynamic>(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return ImageLayerOverlay(
                      index: layers.indexOf(widget.layerData),
                      layerData: widget.layerData,
                      onUpdate: () {
                        // ignore: prefer_null_aware_method_calls
                        if (widget.onUpdate != null) widget.onUpdate!();
                        setState(() {});
                      },
                    );
                  },
                );
              }
            : null,
        onScaleUpdate: widget.editable
            ? (detail) {
                if (detail.pointerCount == 1) {
                  widget.layerData.offset = Offset(
                    widget.layerData.offset.dx + detail.focalPointDelta.dx,
                    widget.layerData.offset.dy + detail.focalPointDelta.dy,
                  );
                } else if (detail.pointerCount == 2) {
                  widget.layerData.scale = detail.scale;
                }

                setState(() {});
              }
            : null,
        child: Transform(
          transform: Matrix4(
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            1,
            0,
            1 / widget.layerData.scale,
          ),
          child: SizedBox(
            width: widget.layerData.image.width.toDouble(),
            height: widget.layerData.image.height.toDouble(),
            child: Image.memory(widget.layerData.image.bytes),
          ),
        ),
      ),
    );
  }
}
