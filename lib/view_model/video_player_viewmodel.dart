import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/model/get_video_info.dart';

import 'package:pornflakes/model/freezed/video_info.dart';

final videoInfoViewModelProvider = FutureProvider<VideoInfo>((ref) async {
  return await GetVideoInfo().scraping(
      ref.watch(phUrlProvider).state, ref.watch(videoTitleProvider).state);
});

final phUrlProvider = StateProvider<String>((ref) => 'PronHub_URL');
final videoTitleProvider = StateProvider<String>((ref) => 'PronHub_Title');
final videoInfoProvider = StateProvider<VideoInfo>((ref) => VideoInfo(
      phUrl: '',
      tzUrl: '',
      title: null,
      channelName: null,
      channelImage: null,
      channelUrl: null,
      channelVideoNum: null,
      channelSubscriberNum: null,
      sub: null,
      unsub: null,
      views: null,
      forPublished: null,
      uploadDate: '',
      imageSrc: '',
      goodRate: null,
      votesUp: 0,
      votesDown: 0,
      hlsUrl: '',
      hlsQuality: [],
      relatedVideo: [],
      stars: [],
      category: [],
      production: [],
      tags: [],
      hotspots: null,
    ));
