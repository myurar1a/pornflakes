import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/view/video_page.dart';
import 'package:pornflakes/view/widgets/future_widget.dart';
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
