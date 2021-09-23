import 'package:html/parser.dart';

import 'freezed/list_item.dart';

class VideoListScrape {
  Future<List<ListItem>> getVideoList(String parseId, String phBody) async {
    List<ListItem> newVideoList = [];

    // 動画リストのスクレイピング
    final elements =
        parse(phBody).querySelectorAll('$parseId > .pcVideoListItem');

    // 各動画情報の取得
    for (final elem in elements) {
      final videoTitle = elem.querySelector('.title')!;
      final channelName = elem.querySelector('.usernameWrap')!;
      final views = elem.querySelector('.views > var')!;
      final duration = elem.querySelector('.duration')!;
      final goodRate = elem.querySelector('.value')!;
      final thumbnail = elem.querySelector('.videoPreviewBg > img')!;
      final imageSrc = thumbnail.attributes['data-src']!;
      final mediabookUrl = thumbnail.attributes['data-mediabook']!;
      final videoaherf = elem.querySelector('a')!.attributes['href']!;
      final videoUrl = 'https://jp.pornhub.com$videoaherf';

      // nullable から non-nullable へ変換し、リストへ追加
      newVideoList.add(ListItem(
          title: videoTitle.text.trim(),
          channelName: channelName.text.trim(),
          views: views.text,
          duration: duration.text,
          goodRate: goodRate.text,
          imageSrc: imageSrc,
          mediabookUrl: mediabookUrl,
          videoUrl: videoUrl));
    }
    return newVideoList;
  }
}
