import 'package:flutter/material.dart';
import 'package:pornflakes/view/app_bar/about.dart';
import 'package:pornflakes/view/app_bar/login.dart';
import 'package:pornflakes/view/app_bar/settings.dart';

// AppBar
Widget appBarPopupMenu(context) {
  return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: (int item) {
        switch (item) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 1,
              child: ListTile(
                leading: Icon(Icons.login),
                title: Text('ログイン'),
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('設定'),
              ),
            ),
            const PopupMenuItem(
              value: 3,
              child: ListTile(
                leading: Icon(Icons.apps),
                title: Text('このアプリについて'),
              ),
            ),
          ]);
}

// ホームや動画ページの動画リストからアクセス
Widget videoItemMenu() {
  return PopupMenuButton(
    child: Icon(
      Icons.more_vert,
      size: 18,
    ),
    onSelected: (int index) {
      switch (index) {
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
      }
    },
    itemBuilder: (BuildContext context) => [
      const PopupMenuItem(
        value: 1,
        child: Text('ライブラリに追加'),
      ),
      const PopupMenuItem(
        value: 2,
        child: Text('共有'),
      ),
      const PopupMenuItem(
        value: 3,
        child: Text('興味なし'),
      ),
    ],
  );
}
