import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view_model/video_list_viewmodel.dart';
import 'package:pornflakes/model/freezed/list_item.dart';

const String popularRoot = 'https://jp.pornhub.com/video?o=mv&cc=jp';

final popularListViewModelProvider =
    StateNotifierProvider<VideoListViewModel, ListItems>((ref) {
  final url = ref.watch(popularUrlProvider);
  return VideoListViewModel(url, '#videoCategory');
});

final popularUrlProvider = StateNotifierProvider<UrlState, String>((ref) {
  final count = ref.watch(popularCounterProvider);
  print(count.toString());
  return UrlState(count);
});

final popularCounterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
}

class UrlState extends StateNotifier<String> {
  UrlState(this.count) : super(popularRoot) {
    getUrlAndParseId(count);
  }
  final int count;

  void getUrlAndParseId(int count) {
    if (count == 1) {
      state = popularRoot;
    } else {
      state = '$popularRoot&page=${count.toString()}';
    }
    print(state);
  }
}
