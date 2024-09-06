import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends StatefulWidget {
  final File? file;
  final String? url;
  final bool autoPlay;
  final Duration? initialPosition; // Add this parameter

  const VideoProvider({
    this.file,
    this.url,
    this.autoPlay = false,
    this.initialPosition, // Add this parameter
    Key? key,
  }) : super(key: key);

  @override
  VideoProviderState createState() => VideoProviderState();
}

class VideoProviderState extends State<VideoProvider> {
  late VideoPlayerController controller;
  bool _isControllerInitialized = false;
  bool _isPlaying = false;
  bool _showSlider = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.file != null) {
      controller = VideoPlayerController.file(widget.file!);
    } else if (widget.url != null) {
      controller = VideoPlayerController.network(widget.url!);
    } else {
      return;
    }

    controller.initialize().then((_) {
      setState(() {
        _isControllerInitialized = true;
        if (widget.initialPosition != null) {
          controller
              .seekTo(widget.initialPosition!); // Seek to initial position
        }
        if (widget.autoPlay) {
          play();
        }
      });
    });

    controller.addListener(() {
      if (controller.value.isInitialized) {
        setState(() {
          _sliderValue = controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  void play() {
    setState(() {
      controller.play();
      _isPlaying = true;
    });
  }

  void pause() {
    setState(() {
      controller.pause();
      _isPlaying = false;
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      controller.seekTo(Duration(seconds: value.toInt()));
    });
  }

  void _toggleSliderVisibility() {
    setState(() {
      _showSlider = !_showSlider;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void _enterFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.fullscreen_exit),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context); // Exit full screen
                },
                child: Icon(Icons.screen_rotation),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      // Restore video playback state when returning from fullscreen
      if (_isPlaying) {
        play();
      } else {
        pause();
      }
    });

    // Pause the video when entering fullscreen mode
    pause();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSliderVisibility,
      child: _isControllerInitialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(controller),
                  if (!widget.autoPlay && !_showSlider)
                    Center(
                      child: IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlaying ? pause() : play();
                          });
                        },
                      ),
                    ),
                  if (_showSlider)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(controller.value.position),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _sliderValue,
                                    min: 0.0,
                                    max: controller.value.duration.inSeconds
                                        .toDouble(),
                                    onChanged: _onSliderChanged,
                                  ),
                                ),
                                Text(
                                  _formatDuration(controller.value.duration),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
