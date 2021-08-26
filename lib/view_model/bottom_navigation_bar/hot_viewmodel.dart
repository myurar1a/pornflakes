import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view_model/video_list_viewmodel.dart';
import 'package:pornflakes/model/freezed/list_item.dart';

const String hotRoot = 'https://jp.pornhub.com/video?o=ht&cc=jp';

final hotListViewModelProvider =
    StateNotifierProvider<VideoListViewModel, ListItems>((ref) {
  final url = ref.watch(hotUrlProvider);
  return VideoListViewModel(url, '#videoCategory');
});

final hotUrlProvider = StateNotifierProvider<UrlState, String>((ref) {
  final count = ref.watch(hotCounterProvider);
  print(count.toString());
  return UrlState(count);
});

final hotCounterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
}

class UrlState extends StateNotifier<String> {
  UrlState(this.count) : super(hotRoot) {
    getUrlAndParseId(count);
  }
  final int count;

  void getUrlAndParseId(int count) {
    if (count == 1) {
      state = hotRoot;
    } else {
      state = '$hotRoot&page=${count.toString()}';
    }
    print(state);
  }
}
