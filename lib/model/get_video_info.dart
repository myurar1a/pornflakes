// ignore_for_file: non_constant_identifier_names

import 'dart:convert' as convert;
import 'package:html/parser.dart';
import 'package:pornflakes/model/freezed/flashvars.dart';
import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:pornflakes/model/get_body.dart';
import 'package:pornflakes/model/get_video_list.dart';

class GetVideoInfo {
  Future<VideoInfo> scraping(ListItem listItem) async {
    // 検索用定義
    late String start, end;
    late int startIndex, endIndex;

    // Pornhub の動画ページにアクセス
    final phRes = await GetBody().getRes(listItem.videoUrl, {});
    final phBody = await convert.utf8.decodeStream(phRes);
    final phDoc = parse(phBody);

    // Cookie をゴリ押しで取得する
    final phCookie = phRes.cookies.toString();
    final cookieStart = ['ua=', 'bs=', 'ss='];
    Map<String, String> cookie = {};
    for (int i = 0; i < cookieStart.length; i++) {
      if (phCookie.contains(cookieStart[i]) == true) {
        startIndex = phCookie.indexOf(cookieStart[i]);
        endIndex = phCookie.indexOf(';', startIndex + cookieStart[i].length);
        cookie[cookieStart[i].replaceAll('=', '')] =
            phCookie.substring(startIndex + cookieStart[i].length, endIndex);
      }
    }

    // hlsPage の URL を取得
    // player script の取得
    final playerScript = phDoc.querySelector('#player > script')!.text;

    // flashvars の取得
    // 動画の ID にあたる数字は3桁以上のものしか現存してないので、正規表現は3桁以上にしている
    // 正規表現が何をやってもうまくいかないのはなぜ... (とりあえず、playerScript から取得するので、気にする必要は無いが)
    start = ' = {';
    end = '};\n';
    startIndex = playerScript.indexOf(start);
    endIndex = playerScript.indexOf(end, startIndex + start.length);
    final String flashvarsRaw =
        '{${playerScript.substring(startIndex + start.length, endIndex)}}';

    final flashvars = Flashvars.fromJson(convert.jsonDecode(flashvarsRaw));

    // imageSrc の取得
    final imageSrc = flashvars.imageUrl;

    // hotspots の double 化
    late List<double>? hotspots;
    if (flashvars.hotspots.isNotEmpty) {
      hotspots = flashvars.hotspots.map((e) {
        if (e is String) {
          print('hotspots is List<String>');
          return double.parse(e);
        } else if (e is int) {
          print('hotspots is List<int>');
          return e.toDouble();
        } else {
          throw Exception('hotspot\'s values aren\'t String and int.');
        }
      }).toList();
    } else {
      hotspots = null;
    }

    // 再生可能な解像度の取得
    late List quality;
    if (flashvars.mediaDefinitions.isNotEmpty) {
      for (int i = 0; i < flashvars.mediaDefinitions.length; i++) {
        final value = flashvars.mediaDefinitions[i]['defaultQuality'];
        if (value is bool) {
          print('[$i] is bool');
        } else if (value is int) {
          quality = flashvars.mediaDefinitions[i]['quality'];
        } else {
          throw Exception(
              'mediaDefinitions\'s defaultQuality values aren\'t bool and int.');
        }
      }
    } else {
      throw Exception('mediaDefinitions is Empty.');
    }

    // videoUrl の取得
    /*
      --- 2021 Sep. ---
      最古の動画となる 518 の動画においても hls を利用している模様
      よって、現時点では hls 側の URL を取得できる media_1 を無条件で採用する
      ただし、media_0 と 1 の違いは最後の文字が p か a かのみであるため、両対応も視野に入れておく
      
      --- 2021 Nov. ---
      先月の中旬にフロントエンドアップデートがあり、全ての解像度の hlsUrl が flashvars に書かれるようになった。
      ただし、最後の media_(x) には従来と同じ統合リンクがある。
      mediaDefinitions には使えない mp4 が含まれており、この変数の長さが (x) と一致するので、応用できる。
      更なる応用で hlsUrl を取得する必要を無くすため、for文で処理する方法へ変更した。
    */

    // hlsInfo の取得
    List<Map<String, String>> hlsInfo = [];
    for (int i = 0; i < quality.length; i++) {
      start = 'var media_$i=';
      end = ';flashvars';
      startIndex = playerScript.indexOf(start);
      endIndex = playerScript.indexOf(end, startIndex + start.length);
      String media_x =
          playerScript.substring(startIndex + start.length, endIndex);

      // media_(x) の必要な変数名を順番で List に格納
      // split を行う場所を予め ',' に置き換えて複数箇所できるようにする
      final String media_xSplit =
          media_x.replaceAll(' + */', ',').replaceAll(' + /*', ',');
      List<String> mxVarsAll = media_xSplit.split(',').toList();
      List<String> mxVars = [];
      mxVarsAll.forEach((item) {
        if (!item.contains('+')) {
          mxVars.add(item);
        }
      });

      // media_(x) の変数名を順番通りに呼び出し、hlsPageUrl を生成
      String hlsUrl = '';
      for (int i2 = 0; i2 < mxVars.length; i2++) {
        start = 'var ${mxVars[i2]}=';
        end = ';';
        startIndex = playerScript.indexOf(start);
        endIndex = playerScript.indexOf(end, startIndex + start.length);
        hlsUrl = hlsUrl +
            playerScript
                .substring(startIndex + start.length, endIndex)
                .replaceAll('"', '')
                .replaceAll(' + ', '');
      }

      // hlsInfo へ quality と hlsUrl を統合
      // 1080p だけ順番に例外があるため、順序が合うように調整
      if (quality.length >= 4) {
        if (i == 0) {
          hlsInfo.add({'quality': '${quality[0]}p', 'hlsUrl': hlsUrl});
        } else {
          hlsInfo.add(
              {'quality': '${quality[quality.length - i]}p', 'hlsUrl': hlsUrl});
        }
      } else {
        hlsInfo.add({
          'quality': '${quality[quality.length - 1 - i]}p',
          'hlsUrl': hlsUrl
        });
      }
    }

/*
    // hlsPage から hlsjson をString型で取得
    final hlsjsonStr = await GetBody().getBody(hlsPageUrl, cookie);
*/
    // hlsInfoの取得
    /*
      現在、1440p の動画はプレミアム会員なら閲覧可能というようになっている。
      プレミアム会員の Cookie が設定されてない場合は、videoUrl に URL が記述されない。
      1440p の動画は 1080p までの動画とは別で hlsList の最後の要素として記述される。
      今後のアップデートを見据え、動画の解像度とURLを Map で hlsInfo を取得する。
    */
/*
    final List hlsList = convert.jsonDecode(hlsjsonStr);

    List<Map<String, String>> hlsInfo = [];
    for (int i = 0; i < hlsList.length; i++) {
      if (hlsList[i]['quality'] is String && hlsList[i]['videoUrl'] != '') {
        hlsInfo.add({
          'quality': hlsList[i]['quality'],
          'hlsUrl': hlsList[i]['videoUrl']
        });
      }
    }
*/
    /*
    処理の高速化に向け playerScript から情報が取得された時点で、
    Provider に変数を渡して、動画のロードを先にすることも検討中
    ただし、実装しても誤差の範囲ではあると思う
    */

    // 動画情報のスクレイピング
    final phvwrapElem = phDoc.querySelector('.video-wrapper')!;
    final channelIcon =
        phvwrapElem.querySelector('.userAvatar > img')!.attributes['data-src']!;
    final channelUrl = phvwrapElem
        .querySelector('.usernameBadgesWrapper > a')!
        .attributes['href']!;
    final channelVideoNum =
        phvwrapElem.querySelector('.userInfo > span:nth-child(3)')!.text;
    final channelSubscriberNum =
        phvwrapElem.querySelector('.userInfo > span:nth-child(7)')!.text;
    final sub = phvwrapElem
        .querySelector('.userActions > div > button')!
        .attributes['data-subscribe-url']!;
    final unsub = phvwrapElem
        .querySelector('.userActions > div > button')!
        .attributes['data-unsubscribe-url']!;
    final views = phvwrapElem.querySelector('.count')!.text;
    final forPublished = phvwrapElem.querySelector('.videoInfo')!.text;

    // Video Info JSON
    // imageUrl は flashvars にて取得済み
    final String infoJsonQuery =
        phDoc.querySelector('[type="application/ld+json"]')!.text;
    final Map<String, dynamic> infoJson = convert.jsonDecode(infoJsonQuery);
    final String uploadDate = infoJson['uploadDate'];

    // Tooltip JSON
    final String tooltipQuery = phvwrapElem
        .querySelector('.video-actions-menu > [type="text/javascript"]')!
        .text;
    final String tooltipQueryTrim =
        tooltipQuery.substring(32, tooltipQuery.length - 2);
    final Map<String, dynamic> tooltip = convert.jsonDecode(tooltipQueryTrim);
    final int votesUp = int.parse(tooltip['currentUp']);
    final int votesDown = int.parse(tooltip['currentDown']);
    final String votesUpUrl = tooltip['submitVote'];
    final String votesDownUrl = tooltip['submitVoteDown'];

    // Discription
    List<CategoryInfo> categoryList = [];
    final categoryElements =
        phvwrapElem.querySelectorAll('.categoriesWrapper > .item');
    for (final cateElem in categoryElements) {
      if (categoryElements != []) {
        final categoryHref = cateElem.attributes['href']!;
        categoryList.add(CategoryInfo(
            categoryName: cateElem.text, categoryHref: categoryHref));
      }
    }

    List<StarInfo> starList = [];
    final starElements =
        phvwrapElem.querySelectorAll('.pornstarsWrapper > .pstar-list-btn');
    for (final starElem in starElements) {
      if (starElements != []) {
        final starHref = starElem.attributes['href']!;
        final starSrc =
            starElem.querySelector('.avatar')!.attributes['data-src']!;
        starList.add(StarInfo(
            starName: starElem.text.trim(),
            starHref: starHref,
            starSrc: starSrc));
      }
    }
    List<ProductionInfo> productionList = [];
    final productionElements =
        phvwrapElem.querySelectorAll('.productionWrapper > .item');
    for (final prodElem in productionElements) {
      if (productionElements != []) {
        final productionHref = prodElem.attributes['href']!;
        productionList.add(ProductionInfo(
            productionName: prodElem.text, productionHref: productionHref));
      }
    }

    List<String> tagList = [];
    final tagElements = phvwrapElem.querySelectorAll('.tagsWrapper > .item');
    for (final tagElem in tagElements) {
      if (tagElements != []) {
        tagList.add(tagElem.text);
      }
    }

    // 関連動画のリストを取得
    final relatedVideoList =
        await VideoListScrape().getVideoList('#relatedVideosCenter', phBody);

    return VideoInfo(
      phUrl: listItem.videoUrl,
      title: listItem.title,
      channelName: listItem.channelName,
      channelIcon: channelIcon,
      channelUrl: channelUrl,
      channelVideoNum: channelVideoNum.substring(0, channelVideoNum.length - 4),
      channelSubscriberNum:
          channelSubscriberNum.substring(0, channelSubscriberNum.length - 4),
      sub: sub,
      unsub: unsub,
      views: views,
      forPublished: forPublished,
      uploadDate: uploadDate.substring(0, 10).replaceAll('-', '/'),
      imageSrc: imageSrc,
      goodRate: listItem.goodRate,
      votesUp: votesUp,
      votesDown: votesDown,
      votesUpUrl: votesUpUrl,
      votesDownUrl: votesDownUrl,
      hlsInfo: hlsInfo,
      hotspots: hotspots,
      stars: starList,
      category: categoryList,
      production: productionList,
      tags: tagList,
      relatedVideo: relatedVideoList,
    );
  }
}
