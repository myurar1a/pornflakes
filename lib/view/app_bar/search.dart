import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pornflakes/model/freezed/list_item.dart';
import 'package:pornflakes/view/video_tile.dart';
import 'package:pornflakes/view/widgets/future_widget.dart';
import 'package:pornflakes/view/widgets/last_indicator.dart';
import 'package:pornflakes/view_model/bottom_navigation_bar/search_viewmodel.dart';

class SearchListView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _buildList(context, ref),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchListViewModelProvider);
    late List<ListItem> videoList;
    if (!state.isLoading) {
      videoList = ref.read(searchListViewModelProvider).items;
    }
    if (state.error != null) {
      return errorView(state.error!);
    } else {
      return RefreshIndicator(
          onRefresh: () async => ref.refresh(searchListViewModelProvider),
          child: state.isLoading
              ? loadingView()
              : ListView.builder(
                  itemCount: videoList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == videoList.length) {
                      return LastIndicator(() {
                        ref.read(searchCounterProvider.notifier).increment();
                      });
                    }
                    return videoTile(context, ref, videoList[index]);
                  },
                ));
    }
  }
}
