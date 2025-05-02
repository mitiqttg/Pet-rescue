import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerApp extends StatefulWidget {
  final String linkVideo;

  const VideoPlayerApp(
    {
      Key? key,
      required this.linkVideo,
    }
  ) : super(key: key);
  @override
  VideoPlayerAppState createState() => VideoPlayerAppState();
}

class VideoPlayerAppState extends State<VideoPlayerApp> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // VideoPlayerController.
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.linkVideo));

    _controller!.initialize();

    _controller!.play();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller!.dispose();
  }
}