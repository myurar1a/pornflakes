import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:pornflakes/view_model/bottom_navigation_bar/search_viewmodel.dart';
import 'package:pornflakes/view_model/video_player_viewmodel.dart';

List<Widget> buildDescription(WidgetRef ref, VideoInfo videoInfo) {
  return [
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
      child: Text('タグ', style: TextStyle(fontSize: 14, color: Colors.grey)),
    ),
    _descriptions(ref, videoInfo.tags, false),
  ];
}

Widget _descriptions(WidgetRef ref, List infoList, bool href) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [
      for (int i = 0; i < infoList.length; i++)
        Padding(
          padding: EdgeInsets.only(right: 6),
          child: OutlinedButton(
            child: (href == true)
                ? Text('${infoList[i]["name"]}')
                : Text('${infoList[i]}'),
            style: OutlinedButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.only(left: 6, right: 6)),
            onPressed: () {
              if (href == true) {
                ref.read(selectedVideoItemProvider).state = null;
                //ref.read(searchWordProvider).state = '${infoList[i]["categoryHref"]}';
              } else {
                ref.read(selectedVideoItemProvider).state = null;
                ref.read(searchWordProvider).state = '${infoList[i]}';
              }
            },
          ),
        ),
    ]),
  );
}
