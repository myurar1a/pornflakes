import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view_model/video_list_viewmodel.dart';
import 'package:pornflakes/model/freezed/list_item.dart';

const String searchRoot = 'https://jp.pornhub.com/video/search?search=';

final searchListViewModelProvider =
    StateNotifierProvider<VideoListViewModel, ListItems>((ref) {
  final url = ref.watch(searchUrlProvider);
  return VideoListViewModel(url, '#videoSearchResult');
});

final searchUrlProvider = StateNotifierProvider<UrlState, String>((ref) {
  final word = ref.watch(searchWordProvider).state;
  final count = ref.watch(searchCounterProvider);
  return UrlState(word, count);
});

final searchCounterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

final searchWordProvider = StateProvider<String>((ref) => '');

class Counter extends StateNotifier<int> {
  Counter() : super(1);
  void increment() => state++;
}

class UrlState extends StateNotifier<String> {
  UrlState(this.word, this.count) : super(searchRoot) {
    getUrlAndParseId(word, count);
  }
  final String word;
  final int count;

  void getUrlAndParseId(String word, int count) {
    if (count == 1) {
      state = '$searchRoot$word';
    } else {
      state = '$searchRoot$word&page=${count.toString()}';
    }
    print(state);
  }
}
