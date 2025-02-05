import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../../models/map_model/map_model.dart';

class MapsDetailScreen extends StatefulWidget {
  const MapsDetailScreen({
    super.key,
    required this.map,
  });

  final Maps map;

  @override
  State<MapsDetailScreen> createState() => _MapsDetialScreenState();
}

class _MapsDetialScreenState extends State<MapsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.map.displayName!,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 10,
              ),
              child: Hero(
                tag: widget.map.uuid!,
                child: CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: widget.map.splash!,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "MiniMap",
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 120),
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 10,
              ),
              child: widget.map.displayIcon != null
                  ? InteractiveViewer(
                      panEnabled: false, // Set it to false to prevent panning.
                      boundaryMargin: EdgeInsets.all(80),
                      minScale: 0.5,
                      maxScale: 4,
                      child: ExtendedImage.network(
                        widget.map.displayIcon!,
                        key: UniqueKey(),
                        fit: BoxFit.fill,
                        enableLoadState: true,
                        mode: ExtendedImageMode.gesture,
                        onDoubleTap: (state) {
                          final pointerDownPosition = state.pointerDownPosition;
                          final begin = state.gestureDetails?.totalScale;
                          double end;

                          if (begin == 1.0) {
                            end = 2;
                          } else {
                            end = 1.0;
                          }

                          state.handleDoubleTap(
                            scale: end,
                            doubleTapPosition: pointerDownPosition,
                          );
                        },
                      ),
                    )
                  : const Text("No MiniMap"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
