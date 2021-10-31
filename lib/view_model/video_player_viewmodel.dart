import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/model/get_video_info.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/model/freezed/video_info.dart';
import 'package:miniplayer/miniplayer.dart';

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => (MiniplayerController()),
);

final selectedVideoItemProvider = StateProvider<ListItem?>((ref) => null);

final selectedVideoInfoProvider = FutureProvider<VideoInfo>((ref) async {
  return await GetVideoInfo()
      .scraping(ref.watch(selectedVideoItemProvider).state!);
});
