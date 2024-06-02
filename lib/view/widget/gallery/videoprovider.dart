import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends StatefulWidget {
  final File? file;
  final String? url;
  final bool autoPlay;

  const VideoProvider({
    this.file,
    this.url,
    this.autoPlay = false,
    Key? key,
  }) : super(key: key);

  @override
  VideoProviderState createState() => VideoProviderState();
}

class VideoProviderState extends State<VideoProvider> {
  late VideoPlayerController _controller;
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
      _controller = VideoPlayerController.file(widget.file!);
    } else if (widget.url != null) {
      _controller = VideoPlayerController.network(widget.url!);
    } else {
      return;
    }

    _controller.initialize().then((_) {
      setState(() {
        _isControllerInitialized = true;
        if (widget.autoPlay) {
          play();
        }
      });
    });

    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        setState(() {
          _sliderValue = _controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  void play() {
    setState(() {
      _controller.play();
      _isPlaying = true;
    });
  }

  void pause() {
    setState(() {
      _controller.pause();
      _isPlaying = false;
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _controller.seekTo(Duration(seconds: value.toInt()));
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSliderVisibility,
      child: _isControllerInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(_controller),
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
                                  _formatDuration(_controller.value.position),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _sliderValue,
                                    min: 0.0,
                                    max: _controller.value.duration.inSeconds
                                        .toDouble(),
                                    onChanged: _onSliderChanged,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_controller.value.duration),
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
    _controller.dispose();
    super.dispose();
  }
}
