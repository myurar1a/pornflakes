import 'dart:convert' as convert;
import 'package:html/parser.dart';
import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:pornflakes/model/get_body.dart';

class GetVideoInfo {
  Future<VideoInfo> scraping(String phUrl, String rawTitle) async {
    // 最優先で hlsUrl の取得を行う
    // viewkey の取得
    final findviewkey = phUrl.indexOf('viewkey=');
    final viewkey = phUrl.substring(findviewkey + 8, phUrl.length);
    final title = Uri.encodeFull(Uri.encodeFull(rawTitle))
        .replaceAll('%2520', '-')
        .replaceAll('/', '-');

    // Thumbzilla のリンクを作成
    final tzUrl = 'https://www.thumbzilla.com/video/$viewkey/$title';
    print(tzUrl);

    // ここから Thumbziila にて m3u8 取得
    final tzRes = await GetBody().getRes(tzUrl, null);
    final tzBody = await convert.utf8.decodeStream(tzRes);
    final queryscript =
        parse(tzBody).querySelector('body > script:nth-child(11)');

    // Cookie をゴリ押しで取得する
    final tzCookie = tzRes.cookies.toString();
    final cookieStart = ['ua=', 'bs=', 'ss='];
    final tzCookieValue = [];
    for (int i = 0; i < cookieStart.length; i++) {
      if (tzCookie.contains(cookieStart[i]) == true) {
        final startIndex = tzCookie.indexOf(cookieStart[i]);
        final endIndex =
            tzCookie.indexOf(';', startIndex + cookieStart[i].length);
        tzCookieValue.add(
            tzCookie.substring(startIndex + cookieStart[i].length, endIndex));
      }
    }
    final List<List<String>> cookie = [
      ['ua', tzCookieValue[0]],
      ['platform', 'pc'],
      ['bs', tzCookieValue[1]],
      ['ss', tzCookieValue[2]]
    ];

    // hlsPage の URL を取得
    var hlsPageUrlRaw;
    if (queryscript != null) {
      final start = '"hls","quality":[],"videoUrl":"';
      final end = '","remote"';

      if (queryscript.text.contains(start) == true) {
        final startIndex = queryscript.text.indexOf(start);
        final endIndex =
            queryscript.text.indexOf(end, startIndex + start.length);
        hlsPageUrlRaw =
            queryscript.text.substring(startIndex + start.length, endIndex);
      }
    }

    // URL の修正
    final hlsPageUrl = hlsPageUrlRaw.replaceAll('\\', '');

    // hlsPage から hlsjson をString型で取得
    final hlsjsonStr = await GetBody().getBody(hlsPageUrl, cookie);

    // hlsUrl の取得
    final List hlsList = convert.jsonDecode(hlsjsonStr);
    final String hlsUrlRaw = hlsList[hlsList.length - 1]['videoUrl'];
    final String hlsUrl = hlsUrlRaw.replaceAll('\\', '');
    print(hlsUrl);

    // 解像度の種類リスト
    final List hlsQuality = hlsList[hlsList.length - 1]['quality'];

    // Pronhub の動画ページから VideoInfo を取得
    const rootUrl = 'https://jp.pornhub.com';
    final phBody = await GetBody().getBody(phUrl, null);
    final phElements = parse(phBody).querySelector('.video-wrapper');
    if (phElements != null) {
      final videoTitle = phElements.querySelector('.inlineFree');
      final channelName = phElements.querySelector('.usernameBadgesWrapper');
      final channelImage =
          phElements.querySelector('.userAvatar > img')!.attributes['data-src'];
      final channelUrl = phElements
          .querySelector('.usernameBadgesWrapper > a')!
          .attributes['href'];
      final channelVideoNum =
          phElements.querySelector('.userInfo > span:nth-child(3)');
      final channelSubscriberNum =
          phElements.querySelector('.userInfo > span:nth-child(7)');
      final sub = phElements
          .querySelector('.userActions > div > button')!
          .attributes['data-subscribe-url'];
      final unsub = phElements
          .querySelector('.userActions > div > button')!
          .attributes['data-unsubscribe-url'];
      final views = phElements.querySelector('.count');
      final duration = phElements.querySelector('.videoInfo');
      final goodRate = phElements.querySelector('.ratingPercent');

      List<List<String?>> categoryList = [];
      final categoryElements =
          parse(phBody).querySelectorAll('.categoriesWrapper > .item');
      for (final cateElem in categoryElements) {
        if (categoryElements != []) {
          final categoryHref = cateElem.attributes['href'];
          categoryList.add([cateElem.text, '$rootUrl$categoryHref']);
        }
      }
      List<List<String?>> starList = [];
      final starElements =
          parse(phBody).querySelectorAll('.pornstarsWrapper > .pstar-list-btn');
      for (final starElem in starElements) {
        if (starElements != []) {
          final starHref = starElem.attributes['href'];
          final starSrc =
              starElem.querySelector('.avatar')!.attributes['data-src'];
          starList.add([starElem.text.trim(), '$rootUrl$starHref', starSrc]);
        }
      }
      List<List<String?>> productionList = [];
      final productionElements =
          parse(phBody).querySelectorAll('.productionWrapper > .item');
      for (final prodElem in productionElements) {
        if (productionElements != []) {
          final productionHref = prodElem.attributes['href'];
          productionList.add([prodElem.text, '$rootUrl$productionHref']);
        }
      }

      List<String?> tagList = [];
      final tagElements =
          parse(phBody).querySelectorAll('.tagsWrapper > .item');
      for (final tagElem in tagElements) {
        if (tagElements != []) {
          tagList.add(tagElem.text);
        }
      }

/*
      List<List<String?>> tagList = [];
      final tagElements =
          parse(phBody).querySelectorAll('.tagsWrapper > .item');
      for (final tagElem in tagElements) {
        if (tagElements != []) {
          final tagHref = tagElem.attributes['href'];
          tagList.add([tagElem.text, '$rootUrl$tagHref']);
        }
      }
*/

      // サムネイルとアップロード日を取得
      final nailStart = '"thumbnailUrl": "';
      final nailStartIndex = phBody.indexOf(nailStart);
      final nailEndIndex =
          phBody.indexOf('",', nailStartIndex + nailStart.length);
      final String thumbnailSrc =
          phBody.substring(nailStartIndex + nailStart.length, nailEndIndex);

      final upStart = '"uploadDate": "';
      final upStartIndex = phBody.indexOf(upStart);
      final upEndIndex = phBody.indexOf('T', upStartIndex + upStart.length);
      final String uploadDateBar =
          phBody.substring(upStartIndex + upStart.length, upEndIndex);
      final String uploadDate = uploadDateBar.replaceAll('-', '/');

      // 関連の動画を取得
      List<ListItem> relatedVideoList = [];
      final relatedElements = parse(phBody)
          .querySelectorAll('#relatedVideosCenter > .pcVideoListItem');
      for (final elem in relatedElements) {
        final videoTitle = elem.querySelector('.title')!;
        final channelName = elem.querySelector('.usernameWrap')!;
        final views = elem.querySelector('.views > var')!;
        final duration = elem.querySelector('.duration')!;
        final goodRate = elem.querySelector('.value')!;
        final imageSrc =
            elem.querySelector('.videoPreviewBg > img')!.attributes['data-src'];
        final mediabookUrl = elem
            .querySelector('.videoPreviewBg > img')!
            .attributes['data-mediabook'];
        final videoaherf = elem.querySelector('a')!.attributes['href'];
        final videoUrl = '$rootUrl$videoaherf';

        // nullable から non-nullable へ変換し、リストへ追加
        if ((imageSrc != null) &&
            (mediabookUrl != null) &&
            (videoaherf != null)) {
          relatedVideoList.add(ListItem(
              title: videoTitle.text.trim(),
              channel: channelName.text.trim(),
              views: views.text,
              duration: duration.text,
              goodRate: goodRate.text,
              imageSrc: imageSrc,
              mediabookUrl: mediabookUrl,
              videoUrl: videoUrl));
        } else {
          print('Error. thumbnail or thumbnail_video or video_url is empty.');
        }
      }

      // Thumbzilla の動画ページから VideoInfo を取得
      late int votesUp, votesDown;
      final votesUpRaw = parse(tzBody).querySelector('.votesUp')?.text;
      final votesDownRaw = parse(tzBody).querySelector('.votesDown')?.text;
      if (votesUpRaw != null && votesDownRaw != null) {
        final votesUpStr = votesUpRaw.replaceAll(',', '');
        final votesDownStr = votesDownRaw.replaceAll(',', '');
        votesUp = int.parse(votesUpStr);
        votesDown = int.parse(votesDownStr);
      }

      return VideoInfo(
          phUrl: phUrl,
          tzUrl: tzUrl,
          title: videoTitle?.text,
          channelName: channelName?.text,
          channelImage: channelImage,
          channelUrl: channelUrl,
          channelVideoNum: channelVideoNum?.text
              .substring(0, channelVideoNum.text.length - 4),
          channelSubscriberNum: channelSubscriberNum?.text
              .substring(0, channelSubscriberNum.text.length - 4),
          sub: sub,
          unsub: unsub,
          views: views?.text,
          forPublished: duration?.text,
          uploadDate: uploadDate,
          imageSrc: thumbnailSrc,
          goodRate: goodRate?.text,
          votesUp: votesUp,
          votesDown: votesDown,
          hlsUrl: hlsUrl,
          hlsQuality: hlsQuality,
          relatedVideo: relatedVideoList,
          stars: starList,
          category: categoryList,
          production: productionList,
          tags: tagList);
    } else {
      throw Exception('Elements is null');
    }
  }
}
