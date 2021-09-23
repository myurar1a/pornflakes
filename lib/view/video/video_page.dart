import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view_model/bottom_navigation_bar/search_viewmodel.dart';
import 'package:video_player/video_player.dart';

import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:pornflakes/view/video/user_page.dart';
import 'package:pornflakes/view/video/video_page_function.dart';
import 'package:pornflakes/view_model/video_player_viewmodel.dart';
import 'package:pornflakes/view/video_list.dart';

class VideoPage extends ConsumerStatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late double _aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _videoInfo(),
      ),
    );
  }

  // videoInfo の取得 (ページに入る前に URL と タイトル のステートを変更を
  // しているので、videoInfo の更新が入っているはず)
  Widget _videoInfo() {
    final state = ref.watch(videoInfoViewModelProvider);
    return state.when(
      data: (videoInfo) {
        return _videoPage(videoInfo); // ウィジェット編集のため、一時的に変更中
      },
      loading: () => _loadingView(),
      error: (error, _) => _errorView(error.toString()),
    );
  }

  Future<void> playhls(String hlsUrl, List<double>? hotspots) async {
    _videoPlayerController = VideoPlayerController.network(hlsUrl);
    _aspectRatio = _videoPlayerController.value.aspectRatio;
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Color.fromRGBO(255, 153, 0, 1.0),
          handleColor: Color.fromRGBO(255, 153, 0, 1.0),
        ),
        hotspots: hotspots,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
                onTap: () => print('Quality Selected'),
                iconData: Icons.settings,
                title: 'Quality'),
          ];
        });
    return Future.value('プレイヤーの準備が完了しました');
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Widget _videoPage(VideoInfo videoInfo) {
    return FutureBuilder(
        future: playhls(videoInfo.hlsUrl, videoInfo.hotspots),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              _buildPlayer(),
              Expanded(child: _buildInfo(videoInfo)),
            ]);
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return _nextLoadingView();
          }
          if (snapshot.hasError) {
            return _errorView(snapshot.error.toString());
          } else {
            return _errorView('Snapshot doesn\'t have data.');
          }
        });
  }

  Widget _buildPlayer() {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 16 * 9,
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: Chewie(controller: _chewieController),
        ),
        /*FittedBox(
          fit: BoxFit.contain,
          child: Chewie(controller: _chewieController),
        ),*/
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
              Text(
                'ここにカテゴリーなどのボタンを配置\n利用頻度が低いことから、検索機能を優先して実装する予定です。値の取得自体はしているため、早い段階での実装が可能です。\n',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('タグ',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (int i = 0; i < videoInfo.tags.length; i++)
                    Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: OutlinedButton(
                        child: Text('${videoInfo.tags[i]}'),
                        style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.only(left: 6, right: 6)),
                        onPressed: () {
                          ref.read(searchWordProvider).state =
                              '${videoInfo.tags[i]}';
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ]),
              ),
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

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _nextLoadingView() {
    return Center(
      child: Column(children: [
        Stack(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 16 * 9,
            child: Container(
              color: Colors.black,
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(backgroundColor: Colors.black),
              ),
            ),
          ),
        ]),
        Flexible(
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
      ]),
    );
  }

  Widget _errorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(error)],
      ),
    );
  }
}
