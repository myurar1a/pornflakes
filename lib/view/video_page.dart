import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view_model/bottom_navigation_bar/search_viewmodel.dart';
import 'package:pornflakes/view_model/video_player_viewmodel.dart';
import 'package:video_player/video_player.dart';

import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:pornflakes/view/video/user_page.dart';
import 'package:pornflakes/view/video/video_page_function.dart';
import 'package:pornflakes/view/video_tile.dart';

class VideoPage extends ConsumerStatefulWidget {
  final VideoInfo videoInfo;
  VideoPage({Key? key, required this.videoInfo}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
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
        return <OptionItem>[
          OptionItem(
            onTap: () => print('Planned for implementation...'),
            iconData: Icons.settings,
            title: 'Quality',
          ),
        ];
      },
    );
  }

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

  Widget _buildPlayer() {
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

  Widget _buildInfo(VideoInfo videoInfo) {
    return SingleChildScrollView(
      child: Column(children: [
        ExpansionTile(
            title: Text('${videoInfo.title}',
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 2),
            subtitle: Text(
              '${videoInfo.views} 回視聴・${videoInfo.forPublished}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            childrenPadding: EdgeInsets.only(right: 15, left: 15, bottom: 12),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '公開日：${videoInfo.uploadDate}\n',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ),
              /*
              Align(
                alignment: Alignment.centerLeft,
                child: Text('カテゴリー',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              buildDiscription(videoInfo.category),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('キャスト',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              (videoInfo.stars.length != 0)
                  ? buildDiscription(videoInfo.stars)
                  : Container(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('製作',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              (videoInfo.production.length != 0)
                  ? buildDiscription(videoInfo.production)
                  : Container(),
              */
              Align(
                alignment: Alignment.centerLeft,
                child: Text('タグ',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              buildTags(videoInfo.tags),
            ]),
        Padding(
          padding: EdgeInsets.only(top: 6, bottom: 6),
          child: Row(children: [
            Expanded(
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Column(children: [
                  Icon(Icons.thumb_up),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text('${videoInfo.votesUp}',
                        style: TextStyle(fontSize: 12)),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Column(children: [
                  Icon(Icons.thumb_down),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text('${videoInfo.votesDown}',
                        style: TextStyle(fontSize: 12)),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => _copyUrl(videoInfo.phUrl, 'リンクをコピーしました'),
                style: TextButton.styleFrom(
                    primary: Colors.grey,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Column(children: [
                  Icon(Icons.content_copy),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text('コピー', style: TextStyle(fontSize: 12)),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Column(children: [
                  Icon(Icons.download),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text('ダウンロード', style: TextStyle(fontSize: 12)),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Column(children: [
                  Icon(Icons.library_add),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text('保存', style: TextStyle(fontSize: 12)),
                  ),
                ]),
              ),
            ),
          ]),
        ),
        Divider(height: 0),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              '${videoInfo.channelIcon}',
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            '${videoInfo.channelName}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'チャンネル登録者数 ${videoInfo.channelSubscriberNum}',
            style: TextStyle(fontSize: 12),
          ),
          trailing: TextButton(
            onPressed: null,
            child: Text(
              'チャンネル登録',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Divider(height: 0),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: videoInfo.relatedVideo.length,
          itemBuilder: (BuildContext context, int index) =>
              videoTile(context, ref, videoInfo.relatedVideo[index]),
        ),
      ]),
    );
  }

  void _copyUrl(String url, String text) {
    IconFunction().copy(url);
    _showToast(text);
  }

  void _showToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget buildDiscription(List cateList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (int i = 0; i < cateList.length; i++)
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: OutlinedButton(
              child: Text('${cateList[i]["categoryName"]}'),
              style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.only(left: 6, right: 6)),
              onPressed: () {
                ref.read(selectedVideoItemProvider).state = null;
                //ref.read(searchWordProvider).state = '${cateList[i]["categoryHref"]}';
              },
            ),
          ),
      ]),
    );
  }

  Widget buildTags(List tagList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (int i = 0; i < tagList.length; i++)
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: OutlinedButton(
              child: Text('${tagList[i]}'),
              style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.only(left: 6, right: 6)),
              onPressed: () {
                ref.read(selectedVideoItemProvider).state = null;
                ref.read(searchWordProvider).state = '${tagList[i]}';
              },
            ),
          ),
      ]),
    );
  }
}
