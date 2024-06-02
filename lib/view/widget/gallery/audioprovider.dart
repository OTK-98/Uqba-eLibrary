// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class AudioProvider extends StatefulWidget {
//   final File? file;
//   final String? url;
//   final bool autoPlay;

//   const AudioProvider({
//     this.file,
//     this.url,
//     this.autoPlay = false,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _AudioProviderState createState() => _AudioProviderState();
// }

// class _AudioProviderState extends State<AudioProvider> {
//   late AudioPlayer _audioPlayer;
//   bool _isPlayerInitialized = false;
//   bool _isPlaying = false;
//   Duration _duration = Duration();
//   Duration _position = Duration();

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _initializePlayer();
//   }

//   void _initializePlayer() async {
//     if (widget.file != null) {
//       await _audioPlayer.setFilePath(widget.file!.path);
//     } else if (widget.url != null) {
//       await _audioPlayer.setUrl(widget.url!);
//     } else {
//       return;
//     }

//     _audioPlayer.onDurationChanged.listen((duration) {
//       setState(() {
//         _duration = duration;
//       });
//     });

//     _audioPlayer.onAudioPositionChanged.listen((position) {
//       setState(() {
//         _position = position;
//       });
//     });

//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         _isPlaying = state == PlayerState.PLAYING;
//       });
//     });

//     setState(() {
//       _isPlayerInitialized = true;
//       if (widget.autoPlay) {
//         _audioPlayer.play(widget.url!);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isPlayerInitialized
//         ? Column(
//             children: [
//               Slider(
//                 value: _position.inSeconds.toDouble(),
//                 min: 0.0,
//                 max: _duration.inSeconds.toDouble(),
//                 onChanged: (value) {
//                   _audioPlayer.seek(Duration(seconds: value.toInt()));
//                 },
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       _audioPlayer.resume();
//                     },
//                     icon: Icon(Icons.play_arrow),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       _audioPlayer.pause();
//                     },
//                     icon: Icon(Icons.pause),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       _audioPlayer.stop();
//                     },
//                     icon: Icon(Icons.stop),
//                   ),
//                 ],
//               ),
//             ],
//           )
//         : Center(child: CircularProgressIndicator());
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }
