import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/model/get_body.dart';
import 'package:pornflakes/model/get_video_list.dart';

class VideoListViewModel extends StateNotifier<ListItems> {
  final String url, parseId;
  VideoListViewModel(this.url, this.parseId)
      : super(const ListItems(items: [])) {
    fetchVideoList(url, parseId);
  }

  Future<void> fetchVideoList(String url, String parseId) async {
    if (state.items == []) {
      state = state.copyWith(isLoading: true, error: null, init: true);
    } else {
      state = state.copyWith(isLoading: true, error: null, init: false);
    } // この条件は追加ロード時はロード画面を表示させないため
    try {
      final phBody = await GetBody().getBody(url, null);
      final newVideoList =
          await VideoListScrape().getVideoList(url, parseId, phBody);
      state = state.copyWith(
          items: [...state.items, ...newVideoList],
          isLoading: false,
          error: null,
          init: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
