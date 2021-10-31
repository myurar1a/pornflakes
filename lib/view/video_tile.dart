import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/view/widgets/popup_menu.dart';
import 'package:pornflakes/view_model/video_player_viewmodel.dart';

Widget videoTile(BuildContext context, WidgetRef ref, ListItem videoItem) {
  return GestureDetector(
    onTap: () {
      ref.read(selectedVideoItemProvider).state = videoItem;
      ref
          .read(miniPlayerControllerProvider)
          .state
          .animateToHeight(state: PanelState.MAX);
    },
    child: Column(children: <Widget>[
      // build VideoTile
      Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 16 * 9,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.network('${videoItem.imageSrc}'),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Container(
                  color: Colors.black54,
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    '${videoItem.duration}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
      Stack(children: <Widget>[
        Flex(direction: Axis.horizontal, children: <Widget>[
          Flexible(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 5, left: 7.5, right: 18, bottom: 5),
              child: Text(
                '${videoItem.title}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14.0),
              ),
            ),
          ),
        ]),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(top: 3.25, right: 3.25),
            child: Align(
              alignment: Alignment.topRight,
              child: videoItemMenu(),
            ),
          ),
        ),
      ]),
      Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 7.5, bottom: 15),
        child: Text(
          '${videoItem.channelName}・${videoItem.views} 回視聴・高評価 ${videoItem.goodRate}',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12.0),
        ),
      ),
    ]),
  );
}
