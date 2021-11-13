import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:pornflakes/view/video/info_widgets/icon_functions.dart';
import 'package:pornflakes/view/video/info_widgets/description.dart';
import 'package:pornflakes/view/video/user_page.dart';
import 'package:pornflakes/view/video_tile.dart';

Widget buildInfo(BuildContext context, WidgetRef ref, VideoInfo videoInfo) {
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
          children: buildDescription(ref, videoInfo)),

      // アイコンボタン機能の表示
      Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: functionsWidget(context, videoInfo),
      ),

      Divider(height: 0),

      // 投稿者表示
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

      // 関連動画のリスト表示 (上限あり)
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
