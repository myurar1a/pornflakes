import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/view/video/video_info.dart';
import 'package:pornflakes/view/video_page.dart';
import 'package:pornflakes/view/widgets/async_value_widget.dart';
import 'package:pornflakes/view_model/video_player_viewmodel.dart';

class MiniPlayerWidget extends StatelessWidget {
  static const double _playerMinHeight = 60.0;

  final ListItem? videoItem;
  final MiniplayerController miniPlayerController;
  MiniPlayerWidget(this.videoItem, this.miniPlayerController);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Offstage(
          offstage: videoItem == null,
          child: Miniplayer(
            controller: miniPlayerController,
            minHeight: _playerMinHeight,
            maxHeight: MediaQuery.of(context).size.height,
            builder: (height, percentage) {
              if (videoItem == null) {
                return const SizedBox.shrink();
              }
              return ref.watch(selectedVideoInfoProvider).when(
                data: (videoInfo) {
                  Widget chewiePlayer = ChewiePlayer(videoInfo: videoInfo);
                  if (height <= _playerMinHeight + 10.0) {
                    return layout(context, ref, videoItem!, chewiePlayer);
                  } else {
                    return Scaffold(
                      body: SafeArea(
                        child: Column(children: [
                          chewiePlayer(),
                          Expanded(
                            child: buildInfo(context, ref, videoInfo),
                          ),
                        ]),
                      ),
                    );
                  }
                },
                loading: (previous) {
                  if (height <= _playerMinHeight + 10.0) {
                    return layout(context, ref, videoItem!, null);
                  } else {
                    return videoLoadingView(context);
                  }
                },
                error: (error, stacktrace, _) {
                  if (height <= _playerMinHeight + 10.0) {
                    return layout(context, ref, videoItem!, null);
                  } else {
                    return errorView(error.toString());
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget layout(BuildContext context, WidgetRef ref, ListItem videoItem,
      Widget? chewiePlayer) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(children: [
        Row(children: [
          // データ取得時かロード時かの判定
          // SizedBox を拡大表示等に連動できれば最高なんやが...
          (chewiePlayer != null)
              ? SizedBox(
                  child: chewiePlayer,
                  height: _playerMinHeight - 2,
                  width: (_playerMinHeight - 2) / 9 * 16,
                )
              : SizedBox(
                  child: Image.network(videoItem.imageSrc),
                  height: _playerMinHeight - 2,
                  width: (_playerMinHeight - 2) / 9 * 16,
                ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    '${videoItem.title}',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${videoItem.channelName}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {
              ref.read(selectedVideoItemProvider).state = null;
            },
            icon: Icon(Icons.close),
          ),
        ]),
        LinearProgressIndicator(
          minHeight: 2.0,
          value: 0.4,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        )
      ]),
    );
  }
}

class OldMiniPlayerWidget extends StatelessWidget {
  static const double _playerMinHeight = 60.0;

  final ListItem? videoItem;
  final MiniplayerController miniPlayerController;
  OldMiniPlayerWidget(this.videoItem, this.miniPlayerController);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Offstage(
          offstage: videoItem == null,
          child: Miniplayer(
            controller: miniPlayerController,
            minHeight: _playerMinHeight,
            maxHeight: MediaQuery.of(context).size.height,
            builder: (height, percentage) {
              if (videoItem == null) {
                return const SizedBox.shrink();
              }
              if (height <= _playerMinHeight + 10.0) {
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(children: [
                    Row(children: [
                      SizedBox(
                        child: Image.network(videoItem!.imageSrc),
                        height: _playerMinHeight - 2,
                        width: (_playerMinHeight - 2) / 9 * 16,
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '${videoItem!.title}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${videoItem!.channelName}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.play_arrow),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(selectedVideoItemProvider).state = null;
                        },
                        icon: Icon(Icons.close),
                      ),
                    ]),
                    LinearProgressIndicator(
                      minHeight: 2.0,
                      value: 0.4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    )
                  ]),
                );
              } else {
                return ref.watch(selectedVideoInfoProvider).when(
                      data: (videoInfo) => VideoPage(videoInfo: videoInfo),
                      loading: (previous) => videoLoadingView(context),
                      error: (error, stacktrace, _) =>
                          errorView(error.toString()),
                    );
              }
            },
          ),
        );
      },
    );
  }
}
