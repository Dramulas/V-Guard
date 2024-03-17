import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

/// Image slider
class ImageSlider extends StatelessWidget {
  /// Image slider constructor
  ImageSlider({super.key});

  /// Images before
  final List<String> imagesBefore = [
    //flutter image
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
  ];

  /// Images after
  final List<String> imagesAfter = [
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
    'https://storage.googleapis.com/cms-storage-bucket/3461c6a5b33c339001c5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotoğraflar',
        ),
        const SizedBox(height: 12),
        const Text(
          'Öncesi',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: context.size!.width * 0.2,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: imagesBefore.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    showImageInFullScreen(context, imagesBefore, index: index);
                  },
                  child: SizedBox(
                    width: context.size!.width * 0.2,
                    child: Image.network(imagesBefore[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Sonrası',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: context.size!.width * 0.2,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: imagesAfter.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    showImageInFullScreen(context, imagesAfter, index: index);
                  },
                  child: SizedBox(
                    width: context.size!.width * 0.2,
                    child: Image.network(imagesAfter[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Show image in full screen
void showImageInFullScreen(
  BuildContext context,
  List<String> images, {
  int? index,
}) {
  final controller = PageController(initialPage: index ?? 0);
  showDialog<dynamic>(
    useSafeArea: false,
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Item Detail",
          ),
        ),
        body: PageView.builder(
          controller: controller,
          itemCount: images.length,
          allowImplicitScrolling: true,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Center(
                  child: PinchZoom(
                    child: Image.network(
                      images[index],
                      frameBuilder: (
                        BuildContext context,
                        Widget child,
                        int? frame,
                        bool wasSynchronouslyLoaded,
                      ) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 36,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${index + 1}/${images.length}',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
