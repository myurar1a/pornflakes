import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pornflakes/main.dart';
import 'package:pornflakes/view/app_bar/search.dart';
import 'package:pornflakes/view/bottom_navigation_bar/home.dart';
import 'package:pornflakes/view/bottom_navigation_bar/hot.dart';
import 'package:pornflakes/view/bottom_navigation_bar/popular.dart';
import 'package:pornflakes/view/plugin/popup_menu.dart';
import 'bottom_navigation_bar/library.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabType = ref.watch(tabTypeProvider);
    final _screens = [
      HomeListView(),
      HotListView(),
      PopularListView(),
      LibraryScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Pornflakes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: '検索',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
          appBarPopupMenu(context), //from 'plugin/popup_menu.dart'
        ],
      ),
      body: _screens[tabType.state.index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: tabType.state.index,
        onTap: (int selectIndex) {
          tabType.state = TabType.values[selectIndex];
        },
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: '急上昇'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '日本で人気'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'ライブラリ'),
        ],
      ),
    );
  }
}
