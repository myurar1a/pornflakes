import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pornflakes/model/freezed/video_info.dart';

Widget functionsWidget(BuildContext context, VideoInfo videoInfo) {
  return Row(children: [
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
            child: Text('${videoInfo.votesUp}', style: TextStyle(fontSize: 12)),
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
            child:
                Text('${videoInfo.votesDown}', style: TextStyle(fontSize: 12)),
          ),
        ]),
      ),
    ),
    Expanded(
      child: TextButton(
        onPressed: () => copyUrl(context, videoInfo.phUrl, 'リンクをコピーしました'),
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
  ]);
}

void like() {
  print('高評価ボタンはいつか実装させます...');
}

void dislike() {
  print('低評価ボタンはいつか実装させます...');
}

Future<void> copyUrl(BuildContext context, String url, String text) async {
  await Clipboard.setData(ClipboardData(text: url));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
    ),
  );
}

void download() {
  print('ダウンロード機能はいつか必ず実装させます...');
}

void save() {
  print('ライブラリ機能実装時に保存機能も実装させます...');
}
