import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pornflakes/main.dart';
import 'package:pornflakes/view/app_bar/search.dart';
import 'package:pornflakes/view/bottom_navigation_bar/home.dart';
import 'package:pornflakes/view/bottom_navigation_bar/hot.dart';
import 'package:pornflakes/view/bottom_navigation_bar/popular.dart';
import 'package:pornflakes/view/plugin/popup_menu.dart';
import 'package:pornflakes/view_model/bottom_navigation_bar/search_viewmodel.dart';
import 'bottom_navigation_bar/library.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  // for Search
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SearchBar searchBar;
  late int nowTab;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(title: Text('Pornflakes'), actions: [
      searchBar.getSearchAction(context),
      appBarPopupMenu(context)
    ]);
  }

  void onSubmitted(String value) {
    ref.read(searchWordProvider).state = value;
  }

  void clearSubmit() {
    ref.read(searchWordProvider).state = '';
  }

  _MainPageState() {
    searchBar = SearchBar(
      inBar: false,
      hintText: 'Pornhub を検索',
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      closeOnSubmit: false,
      clearOnSubmit: false,
      onClosed: clearSubmit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabType = ref.watch(tabTypeProvider);
    final _screens = [
      HomeListView(),
      HotListView(),
      PopularListView(),
      LibraryScreen(),
    ];
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: (ref.watch(searchWordProvider).state == '')
          ? _screens[tabType.state.index]
          : SearchListView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: tabType.state.index,
        onTap: (int selectIndex) {
          searchBar.onClosed?.call();
          searchBar.controller.clear();
          Navigator.maybePop(context);
          tabType.state = TabType.values[selectIndex];
        },
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: '急上昇'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '日本で人気'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'ライブラリ'),
        ],
      ),
    );
  }
}
