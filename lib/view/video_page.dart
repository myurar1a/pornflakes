import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view/video/chewie_option.dart';
import 'package:video_player/video_player.dart';
import 'package:pornflakes/model/freezed/video_info.dart';

class ChewiePlayer extends ConsumerStatefulWidget {
  final VideoInfo videoInfo;
  ChewiePlayer({Key? key, required this.videoInfo}) : super(key: key);

  @override
  _ChewiePlayerState createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends ConsumerState<ChewiePlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late double _aspectRatio;

  @override
  void initState() {
    super.initState();
    initializePlayer(widget.videoInfo);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Future<void> initializePlayer(VideoInfo videoInfo) async {
    _videoPlayerController =
        VideoPlayerController.network(videoInfo.hlsInfo[0]['hlsUrl']!);
    _aspectRatio = _videoPlayerController.value.aspectRatio;
    await _videoPlayerController.initialize();
    _createChewieController(videoInfo);
    setState(() {});
  }

  void _createChewieController(VideoInfo videoInfo) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Color.fromRGBO(255, 153, 0, 1.0),
        handleColor: Color.fromRGBO(255, 153, 0, 1.0),
      ),
      hotspots: videoInfo.hotspots,
      additionalOptions: (context) {
        return chewieOption(context);
      },
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _buildPlayer(),
          Expanded(
            child: _buildInfo(widget.videoInfo),
          ),
        ]),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 16 * 9,
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: _chewieController != null
              ? Chewie(controller: _chewieController!)
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 16 * 9,
                  child: Image.network(widget.videoInfo.imageSrc),
                ),
        ),
      ),
    ]);
  }
}
