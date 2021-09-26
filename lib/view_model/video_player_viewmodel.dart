import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/model/get_video_info.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/model/freezed/video_info.dart';

final videoInfoViewModelProvider = FutureProvider<VideoInfo>((ref) async {
  return await GetVideoInfo().scraping(
      ref.watch(phUrlProvider).state, ref.watch(listItemProvider).state);
});

final phUrlProvider = StateProvider<String>((ref) => 'PronHub_URL');
final listItemProvider = StateProvider<ListItem>((ref) => ListItem(
      title: '',
      channelName: '',
      views: '',
      duration: '',
      goodRate: '',
      imageSrc: '',
      mediabookUrl: '',
      videoUrl: '',
    ));
final videoInfoProvider = StateProvider<VideoInfo>((ref) => VideoInfo(
      phUrl: '',
      title: '',
      channelName: '',
      channelIcon: '',
      channelUrl: '',
      channelVideoNum: '',
      channelSubscriberNum: '',
      sub: '',
      unsub: '',
      views: '',
      forPublished: '',
      uploadDate: '',
      imageSrc: '',
      goodRate: '',
      votesUp: 0,
      votesDown: 0,
      votesUpUrl: '',
      votesDownUrl: '',
      hlsInfo: {
        0: {'': ''}
      },
      hotspots: null,
      stars: [],
      category: [],
      production: [],
      tags: [],
      relatedVideo: [],
    ));
