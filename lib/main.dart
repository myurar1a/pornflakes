import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view/video/video_page.dart';

import 'view/main_page.dart';

Future<void> main() async {
  await init();
  runApp(ProviderScope(child: App()));
}

Future<void> init() async {
  await Future.delayed(Duration(milliseconds: 500), () {});
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronflakes',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color.fromRGBO(255, 153, 0, 1.0),
      ),
      //home: MainPage(),
      initialRoute: '/', // ここ以降の定義がルーティング定義
      routes: {
        '/': (context) => MainPage(),
        '/video': (context) => VideoPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TabType { home, hot, popular, library }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.home);
