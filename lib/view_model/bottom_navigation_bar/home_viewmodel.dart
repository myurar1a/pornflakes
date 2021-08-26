import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view_model/video_list_viewmodel.dart';
import 'package:pornflakes/model/freezed/list_item.dart';

const String homeRoot = 'https://jp.pornhub.com/recommended';

final homeListViewModelProvider =
    StateNotifierProvider<VideoListViewModel, ListItems>((ref) {
  final url = ref.watch(homeUrlProvider);
  return VideoListViewModel(url, '#recommendedListings');
});

final homeUrlProvider = StateNotifierProvider<UrlState, String>((ref) {
  final count = ref.watch(homeCounterProvider);
  print(count.toString());
  return UrlState(count);
});

final homeCounterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
}

class UrlState extends StateNotifier<String> {
  UrlState(this.count) : super(homeRoot) {
    getUrlAndParseId(count);
  }
  final int count;

  void getUrlAndParseId(int count) {
    if (count == 1) {
      state = homeRoot;
    } else {
      state = '$homeRoot?page=${count.toString()}';
    }
    print(state);
  }
}
