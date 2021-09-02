import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/view/plugin/popup_menu.dart';
import 'package:pornflakes/view_model/video_player_viewmodel.dart';

Widget videoTile(BuildContext context, WidgetRef ref, ListItem videoItem) {
  return GestureDetector(
    onTap: () {
      ref.read(phUrlProvider).state = videoItem.videoUrl;
      ref.read(videoTitleProvider).state = videoItem.title;
      /*
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return VideoPage();
        }),
      );
      */
      Navigator.pushNamed(context, '/video');
    },
    child: Column(children: <Widget>[
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
              padding: EdgeInsets.only(top: 3, left: 7.5, right: 18),
              child: Text(
                '${videoItem.title}',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
          '${videoItem.channel}・${videoItem.views} 回視聴・高評価 ${videoItem.goodRate}',
          style: TextStyle(
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
      ),
    ]),
  );
}

Widget loadingView() {
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

Widget errorView(String error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(error)],
    ),
  );
}
