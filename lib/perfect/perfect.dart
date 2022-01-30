import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class Perfect extends StatefulWidget {
  const Perfect({Key? key}) : super(key: key);

  @override
  State<Perfect> createState() => _PerfectState();
}

final player = AudioPlayer()..setAsset('assets/song.mp3');

final VideoPlayerController controller = VideoPlayerController.network(
    'https://pharaoh.ru/local/templates/main/video/dark.mp4')
  ..setLooping(true);

final Future videoFuture = controller.initialize();

class _PerfectState extends State<Perfect> {
  @override
  void initState() {
    super.initState();
    controller.play();
    if (!player.playing) {
      player.play();
      player.setVolume(0.1);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: FutureBuilder(
        future: videoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          } else {
            print(controller.value.isPlaying);
            return Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    clipBehavior: Clip.hardEdge,
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/logo-text.png',
                        height: 150,
                      ),
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 210,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
