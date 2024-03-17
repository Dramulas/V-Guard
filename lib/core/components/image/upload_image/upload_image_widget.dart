// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:valorant/core/components/image/image_editor/image_editor_plus.dart';
// import 'package:valorant/core/components/svg/svg_asset.dart';
// import 'package:valorant/core/constants/asset_names.dart';
// import 'package:valorant/core/extensions/context_extensions.dart';
// import 'package:valorant/core/init/language/language_constant.dart';
// import 'package:valorant/core/theme/color_constants.dart';
// import 'package:valorant/values/styles.dart';

// /// Upload image widget.
// class UploadImageWidget extends StatefulWidget {
//   /// Creates a new upload image widget.
//   const UploadImageWidget({required this.hint, super.key});

//   /// The hint.
//   final String hint;

//   @override
//   State<UploadImageWidget> createState() => _UploadImageWidgetState();
// }

// class _UploadImageWidgetState extends State<UploadImageWidget> {
//   final ImagePicker _picker = ImagePicker();

//   final _imageList = <File>[];

//   void _handleDoubleTap() {
//     if (_transformationController.value != Matrix4.identity()) {
//       _transformationController.value = Matrix4.identity();
//     } else {
//       final position = _doubleTapDetails.localPosition;
//       // For a 3x zoom
//       _transformationController.value = Matrix4.identity()
//         ..translate(-position.dx * 2, -position.dy * 2)
//         ..scale(3.0);
//       // Fox a 2x zoom
//       // ..translate(-position.dx, -position.dy)
//       // ..scale(2.0);
//     }
//   }

//   final _transformationController = TransformationController();
//   final _doubleTapDetails = TapDownDetails();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Text(
//             widget.hint,
//           ),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(
//             backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? ColorConstants.cardColorDark
//                 : ColorConstants.thirdTextColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: const BorderSide(
//                 color: ColorConstants.mainColor,
//               ),
//             ),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.5),
//           ),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   translation(context).uploadPhoto,
//                   style: AppTextStyle.h5Med,
//                 ),
//                 const SvgAsset(assetName: AssetName.download),
//               ],
//             ),
//           ),
//           onPressed: () {
//             selectImageBottomSheet(context);
//           },
//         ),
//         ListView(
//           padding: const EdgeInsets.only(top: 12),
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             for (var i = 0; i < _imageList.length; i++)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     _imageList[i].absolute.uri.pathSegments.last,
//                     style: AppTextStyle.h5Reg.copyWith(
//                       color: ColorConstants.secondTextColor,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   leading: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       image: DecorationImage(
//                         image: MemoryImage(
//                           _imageList[i].readAsBytesSync(),
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     width: context
//                         .dynamicWidth(0.175), // adjust this value as needed
//                     child: GestureDetector(
//                       onTap: () {
//                         //make it full screen
//                         displayImageInFullScreen(context, i);
//                       },
//                     ),
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Theme.of(context).brightness == Brightness.dark
//                               ? ColorConstants.cardColorDark
//                               : const Color(0xFFEFEEEE),
//                         ),
//                         child: IconButton(
//                           onPressed: () async {
//                             final editedImage = await Navigator.push(
//                               context,
//                               MaterialPageRoute<dynamic>(
//                                 builder: (context) => ImageEditor(
//                                   image: _imageList[i].readAsBytesSync(),
//                                 ),
//                               ),
//                             );
//                             if (editedImage == null) return;

//                             setState(() {
//                               _imageList[i].writeAsBytesSync(
//                                 editedImage as Uint8List,
//                               );
//                             });
//                           },
//                           icon: const Icon(Icons.edit),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Theme.of(context).brightness == Brightness.dark
//                               ? ColorConstants.cardColorDark
//                               : const Color(0xFFEFEEEE),
//                         ),
//                         child: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _imageList.removeAt(i);
//                             });
//                           },
//                           icon: const Icon(Icons.delete),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }

//   void displayImageInFullScreen(BuildContext context, int i) {
//     showDialog<dynamic>(
//       useSafeArea: false,
//       context: context,
//       builder: (context) {
//         return Dialog.fullscreen(
//           child: Scaffold(
//             appBar: AppBar(
//               title: Text(_imageList[i].path.split('/').last),
//               centerTitle: true,
//             ),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: GestureDetector(
//                     onDoubleTap: _handleDoubleTap,
//                     child: InteractiveViewer(
//                       transformationController: _transformationController,
//                       panEnabled: false, // Set it to false
//                       boundaryMargin: const EdgeInsets.all(100),
//                       minScale: 0.5,
//                       maxScale: 2,
//                       onInteractionEnd: (details) {},
//                       child: Image.memory(
//                         _imageList[i].readAsBytesSync(),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void selectImageBottomSheet(BuildContext context) {
//     showModalBottomSheet<dynamic>(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       elevation: 0,
//       showDragHandle: true,
//       context: context,
//       builder: (context) {
//         return ListView(
//           padding: const EdgeInsets.only(bottom: 50),
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             ListTile(
//               tileColor: Theme.of(context).scaffoldBackgroundColor,
//               minVerticalPadding: 0,
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               leading: SvgPicture.asset(
//                 'assets/icons/camera.svg',
//                 colorFilter: ColorFilter.mode(
//                   Theme.of(context).primaryColorLight,
//                   BlendMode.srcATop,
//                 ),
//               ),
//               title: Text(translation(context).openTheCamera),
//               onTap: () async {
//                 try {
//                   Navigator.pop(context);
//                   final image = await _picker.pickImage(
//                     source: ImageSource.camera,
//                     imageQuality: 50,
//                   );
//                   await saveToTempDirectory(File(image!.path));
//                 } catch (e) {
//                   debugPrint(e.toString());
//                 }
//               },
//             ),
//             const Divider(),
//             ListTile(
//               tileColor: Theme.of(context).scaffoldBackgroundColor,
//               minVerticalPadding: 0,
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               leading: SvgPicture.asset(
//                 'assets/icons/folderWithFiles.svg',
//                 colorFilter: ColorFilter.mode(
//                   Theme.of(context).primaryColorLight,
//                   BlendMode.srcATop,
//                 ),
//               ),
//               title: Text(translation(context).selectFromGallery),
//               onTap: () async {
//                 try {
//                   Navigator.pop(context);
//                   final image = await _picker.pickImage(
//                     source: ImageSource.gallery,
//                   );
//                   await saveToTempDirectory(File(image!.path));
//                 } catch (e) {
//                   debugPrint(e.toString());
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> saveToTempDirectory(File file) async {
//     try {
//       setState(() {
//         _imageList.add(file);
//       });
//     } catch (e) {
//       debugPrint('Error saving file to temp directory: $e');
//     }
//   }
// }
