import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Perfect extends StatefulWidget {
  const Perfect({Key? key}) : super(key: key);

  @override
  State<Perfect> createState() => _PerfectState();
}

class _PerfectState extends State<Perfect> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/dark.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: VideoPlayer(_controller),
        ),
      ],
    );
  }
}
