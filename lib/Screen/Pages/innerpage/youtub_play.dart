import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final String videoUrl;

  const VideoPlay({super.key, required this.videoUrl});

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;
  bool _isButtonVisible = false;
  Timer? _timer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(title: Text('Video Play')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isButtonVisible = true;
            });
            _timer = Timer(const Duration(seconds: 5), () {
              setState(() {
                _isButtonVisible = false;
              });
            });
          },
          child: Stack(
            children: [
              if (!_isInitialized)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
              if (_isButtonVisible)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromARGB(112, 158, 158, 158),
                      onPressed: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
