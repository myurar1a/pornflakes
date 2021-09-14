import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text('全般'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => general(context)),
                );
              },
            ),
            Text('現在設定できる項目はありません (順次追加予定)'),
          ],
        ),
      ),
    );
  }
}

Widget general(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('全般'),
    ),
    body: Center(
      child: Column(
        children: [
          ListTile(
            title: Text('動画ロードの高速化'),
            subtitle: Text('読み込むページを減らして動画のロード時間を短縮します'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Text('実装中');
                }),
              );
            },
          ),
        ],
      ),
    ),
  );
}

/*
Future _fastLoadSimpleDialog(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
              'Pornhubの動画ページを読み込まないことで動画の読み込みを高速化させます。\n高速化すると動画情報の一部が表示されなくなります'),
          children: [
            SimpleDialogOption(
              child: RadioListTile(
                title: Text('デフォルト'),
              ),
              onPressed: () {
                return Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              onPressed: () {
                return Navigator.pop(context);
              },
              child: Text('高速化'),
            ),
          ],
        );
      });
}
*/