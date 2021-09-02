import 'package:flutter/services.dart';

class IconFunction {
  void like() {
    print('高評価ボタンはいつか実装させます...');
  }

  void dislike() {
    print('低評価ボタンはいつか実装させます...');
  }

  Future<void> copy(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
  }

  void download() {
    print('ダウンロード機能はいつか必ず実装させます...');
  }

  void save() {
    print('ライブラリ機能実装時に保存機能も実装させます...');
  }
}
