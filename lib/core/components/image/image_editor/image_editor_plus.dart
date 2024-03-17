import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valorant/core/components/image/image_editor/data/image_item.dart';
import 'package:valorant/core/components/image/image_editor/data/layer.dart';
import 'package:valorant/core/components/image/image_editor/layers_viewer.dart';
import 'package:valorant/core/components/image/image_editor/loading_screen.dart';
import 'package:valorant/core/components/image/image_editor/options.dart' as o;
import 'package:valorant/core/components/image/image_editor/utils.dart';

/// viewport size
late Size viewportSize;

/// viewport ratio
double viewportRatio = 1;

///Layers
List<Layer> layers = [];
Map<String, String> _translations = {};

/// Image editor with limited options
String i18n(String sourceString) =>
    _translations[sourceString.toLowerCase()] ?? sourceString;

/// Image editor with all option available
class ImageEditor extends StatefulWidget {
  /// Creates a new image editor.
  const ImageEditor({
    super.key,
    this.image,
    this.outputFormat = o.OutputFormat.jpeg,
    this.cropOption = const o.CropOption(),
    this.brushOption = const o.BrushOption(),
  });

  /// The image to edit.
  final dynamic image;

  /// The output format of the image.
  final int outputFormat;

  /// The crop option.
  final o.CropOption? cropOption;

  /// The brush option.
  final o.BrushOption? brushOption;

  /// Called when the image is edited.

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  ImageItem currentImage = ImageItem();

  @override
  void dispose() {
    layers.clear();
    super.dispose();
  }

  SizedBox checkButton() {
    return SizedBox(
      child: SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              icon: const Icon(Icons.check),
              onPressed: () async {
                // resetTransformation();

                loadingScreen.show();

                if ((widget.outputFormat & 0x1) == o.OutputFormat.json) {
                  final json = layers.map((e) => e.toJson()).toList();

                  if ((widget.outputFormat & 0xFE) > 0) {
                    final editedImageBytes =
                        await getMergedImage(widget.outputFormat & 0xFE);

                    json.insert(0, {
                      'type': 'MergedLayer',
                      'image': editedImageBytes,
                    });
                  }

                  loadingScreen.hide();

                  if (mounted) Navigator.pop(context, json);
                } else {
                  final editedImageBytes =
                      await getMergedImage(widget.outputFormat & 0xFE);

                  loadingScreen.hide();

                  if (mounted) {
                    Navigator.pop(context, editedImageBytes);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.image != null) {
      loadImage(widget.image);
    }
    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;

  double x = 0;
  double y = 0;
  double z = 0;

  double widthRatio = 1;
  double heightRatio = 1;
  double pixelRatio = 1;

  /// obtain image Uint8List by merging layers
  Future<Uint8List?> getMergedImage([int format = o.OutputFormat.png]) async {
    Uint8List? image;

    if (layers.length == 1 && layers.first is BackgroundLayerData) {
      image = (layers.first as BackgroundLayerData).image.bytes;
    } else if (layers.length == 1 && layers.first is ImageLayerData) {
      image = (layers.first as ImageLayerData).image.bytes;
    } else {}

    // conversion for non-png
    if (image != null &&
        (format == o.OutputFormat.heic ||
            format == o.OutputFormat.jpeg ||
            format == o.OutputFormat.webp)) {
      final formats = {
        o.OutputFormat.heic: 'heic',
        o.OutputFormat.jpeg: 'jpeg',
        o.OutputFormat.webp: 'webp',
      };

      image = await ImageUtils.convert(image, format: formats[format]!);
    }

    return image;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();
  @override
  Widget build(BuildContext context) {
    viewportSize = MediaQuery.of(context).size;
    pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      key: scaffoldGlobalKey,
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      appBar: AppBar(
        title: Text(i18n('Image Editor')),
        actions: [checkButton()],
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTapDown: (d) => _doubleTapDetails = d,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                panEnabled: false, // Set it to false
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2,
                onInteractionEnd: (details) {},
                child: SizedBox(
                  height: currentImage.height / pixelRatio,
                  width: currentImage.width / pixelRatio,
                  child: LayersViewer(
                    layers: layers,
                    onUpdate: () {
                      setState(() {});
                    },
                    editable: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        // color: Colors.black45,
        alignment: Alignment.bottomCenter,
        height: 86 + MediaQuery.of(context).padding.bottom,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          //   boxShadow: [
          //     BoxShadow(blurRadius: 1),
          //   ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.cropOption != null)
                  BottomButton(
                    icon: Icons.crop,
                    text: i18n('Crop'),
                    onTap: () async {
                      LoadingScreen(scaffoldGlobalKey).show();
                      final mergedImage = await getMergedImage();
                      LoadingScreen(scaffoldGlobalKey).hide();

                      if (!mounted) return;

                      final croppedImage = await Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (context) => ImageCropper(
                            image: mergedImage!,
                            availableRatios: widget.cropOption!.ratios,
                          ),
                        ),
                      );

                      if (croppedImage == null) return;

                      await currentImage.load(croppedImage);
                      setState(() {});
                    },
                  ),
                if (widget.brushOption != null)
                  BottomButton(
                    icon: Icons.edit,
                    text: i18n('Brush'),
                    onTap: () async {
                      if (widget.brushOption!.translatable) {
                        final drawing = await Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (context) => ImageEditorDrawing(
                              image: currentImage,
                            ),
                          ),
                        );

                        if (drawing != null) {
                          layers.add(
                            ImageLayerData(
                              image: ImageItem(drawing),
                              offset: Offset(
                                -currentImage.width / 4,
                                -currentImage.height / 4,
                              ),
                            ),
                          );

                          setState(() {});
                        }
                      } else {
                        LoadingScreen(scaffoldGlobalKey).show();
                        final mergedImage = await getMergedImage();
                        LoadingScreen(scaffoldGlobalKey).hide();

                        if (!mounted) return;

                        final drawing = await Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (context) => ImageEditorDrawing(
                              image: ImageItem(mergedImage),
                            ),
                          ),
                        );

                        if (drawing != null) {
                          await currentImage.load(drawing);

                          setState(() {});
                        }
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  Future<void> loadImage(dynamic imageFile) async {
    await currentImage.load(imageFile);

    layers
      ..clear()
      ..add(
        BackgroundLayerData(
          image: currentImage,
        ),
      );

    setState(() {});
  }
}

/// Button used in bottomNavigationBar in ImageEditor
class BottomButton extends StatelessWidget {
  /// Creates a new bottom button.
  const BottomButton({
    required this.icon,
    required this.text,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  /// Called when the button is tapped.
  final VoidCallback? onTap;

  /// Called when the button is long pressed.
  final VoidCallback? onLongPress;

  /// The icon of the button.
  final IconData icon;

  /// The text of the button.
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(height: 8),
            Text(
              i18n(text),
            ),
          ],
        ),
      ),
    );
  }
}

/// Crop given image with various aspect ratios
class ImageCropper extends StatefulWidget {
  /// Creates a new image cropper.
  const ImageCropper({
    required this.image,
    super.key,
    this.availableRatios = const [
      o.AspectRatio(title: 'Freeform'),
      o.AspectRatio(title: '1:1', ratio: 1),
      o.AspectRatio(title: '4:3', ratio: 4 / 3),
      o.AspectRatio(title: '5:4', ratio: 5 / 4),
      o.AspectRatio(title: '7:5', ratio: 7 / 5),
      o.AspectRatio(title: '16:9', ratio: 16 / 9),
    ],
  });

  /// The image to crop.
  final Uint8List image;

  /// Available aspect ratios to crop image
  final List<o.AspectRatio> availableRatios;

  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final GlobalKey<ExtendedImageEditorState> _controller =
      GlobalKey<ExtendedImageEditorState>();

  double? currentRatio;
  bool isLandscape = true;
  int rotateAngle = 0;

  double? get aspectRatio => currentRatio == null
      ? null
      : isLandscape
          ? currentRatio!
          : (1 / currentRatio!);

  @override
  void initState() {
    if (widget.availableRatios.isNotEmpty) {
      currentRatio = widget.availableRatios.first.ratio;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.currentState != null) {
      // _controller.currentState?.
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.check),
            onPressed: () async {
              loadingScreen.show();
              final state = _controller.currentState;

              if (state == null || state.getCropRect() == null) {
                loadingScreen.hide();
                Navigator.pop(context);
              }

              final data = await cropImageWithThread(
                imageBytes: state!.rawImageData,
                rect: state.getCropRect()!,
              );
              loadingScreen.hide();

              if (mounted) Navigator.pop(context, data);
            },
          ),
        ],
      ),
      body: ColoredBox(
        color: Colors.black,
        child: ExtendedImage.memory(
          widget.image,
          cacheRawData: true,
          fit: BoxFit.contain,
          extendedImageEditorKey: _controller,
          mode: ExtendedImageMode.editor,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              cropAspectRatio: aspectRatio,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (currentRatio != null && currentRatio != 1)
                        IconButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          icon: Icon(
                            Icons.portrait,
                            color: isLandscape ? Colors.grey : Colors.white,
                          ),
                          onPressed: () {
                            isLandscape = false;

                            setState(() {});
                          },
                        ),
                      if (currentRatio != null && currentRatio != 1)
                        IconButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          icon: Icon(
                            Icons.landscape,
                            color: isLandscape ? Colors.white : Colors.grey,
                          ),
                          onPressed: () {
                            isLandscape = true;

                            setState(() {});
                          },
                        ),
                      for (final ratio in widget.availableRatios)
                        TextButton(
                          onPressed: () {
                            currentRatio = ratio.ratio;

                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              i18n(ratio.title),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> cropImageWithThread({
    required Uint8List imageBytes,
    required Rect rect,
  }) async {
    final cropTask = img.Command()
      ..decodeImage(imageBytes)
      ..copyCrop(
        x: rect.topLeft.dx.ceil(),
        y: rect.topLeft.dy.ceil(),
        height: rect.height.ceil(),
        width: rect.width.ceil(),
      );

    final encodeTask = img.Command()
      ..subCommand = cropTask
      ..encodeJpg();

    return encodeTask.getBytesThread();
  }
}

/// Show image drawing surface over image
class ImageEditorDrawing extends StatefulWidget {
  /// Creates a new image editor drawing surface.
  const ImageEditorDrawing({
    required this.image,
    super.key,
  });

  /// The image to draw on.
  final ImageItem image;

  @override
  State<ImageEditorDrawing> createState() => _ImageEditorDrawingState();
}

class _ImageEditorDrawingState extends State<ImageEditorDrawing> {
  final _imageKey = GlobalKey<ImagePainterState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.check),
            onPressed: () async {
              loadingScreen.show();
              final image = await _imageKey.currentState?.exportImage();
              loadingScreen.hide();

              if (mounted) Navigator.pop(context, image);
            },
          ),
        ],
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                    ),
              ),
          iconTheme: Theme.of(context).iconTheme,
          popupMenuTheme: Theme.of(context).popupMenuTheme,
        ),
        child: ImagePainter.memory(
          widget.image.bytes,
          scalable: true,
          undoIcon: const Icon(Icons.undo),
          brushIcon: Icon(
            Icons.brush,
            color: Theme.of(context).iconTheme.color,
          ),
          clearAllIcon: const Icon(Icons.delete),
          key: _imageKey,
          controlsAtTop: false,
          initialColor: Colors.red,
          initialStrokeWidth: 5,
          unselectedColor: Theme.of(context).iconTheme.color,
          selectedColor: Theme.of(context).iconTheme.color,
          optionColor: Theme.of(context).iconTheme.color,
          controlsBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
