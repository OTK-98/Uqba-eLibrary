// import 'package:flutter/material.dart';
// import 'package:gallery_picker/gallery_picker.dart';

// class GalleryHeroScreen extends StatelessWidget {
//   final MediaFile mediaFile;
//   final String tag;

//   const GalleryHeroScreen(
//       {required this.mediaFile, required this.tag, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: Hero(
//               tag: tag,
//               child: mediaFile.isImage
//                   ? (mediaFile.file != null
//                       ? Image.file(mediaFile.file!, fit: BoxFit.contain)
//                       : const Placeholder(
//                           fallbackHeight: 200, fallbackWidth: 200))
//                   : VideoProvider(media: mediaFile),
//             ),
//           ),
//           Positioned(
//             top: 40.0,
//             left: 16.0,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoProvider extends StatelessWidget {
//   final MediaFile media;

//   const VideoProvider({required this.media, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Provide a way to display video thumbnail or player
//     return Container(
//       // Placeholder for video representation
//       height: 200,
//       color: Colors.black,
//       child: Center(
//         child: Icon(
//           Icons.videocam,
//           color: Colors.white,
//           size: 50,
//         ),
//       ),
//     );
//   }
// }
