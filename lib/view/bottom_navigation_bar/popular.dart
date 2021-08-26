import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/view/bottom_navigation_bar/video_list.dart';
import 'package:pornflakes/view/plugin/last_indicator.dart';
import 'package:pornflakes/view_model/bottom_navigation_bar/popular_viewmodel.dart';

class PopularListView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _buildList(context, ref),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
    final state = ref.watch(popularListViewModelProvider);
    late List<ListItem> videoList;
    if (!state.isLoading) {
      videoList = ref.read(popularListViewModelProvider).items;
    }
    return RefreshIndicator(
        onRefresh: () async => ref.refresh(popularListViewModelProvider),
        child: state.isLoading
            ? loadingView()
            : ListView.builder(
                itemCount: videoList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == videoList.length) {
                    return LastIndicator(() {
                      ref.read(popularCounterProvider.notifier).increment();
                    });
                  }
                  return videoTile(context, videoList[index]);
                },
              ));
  }
}
