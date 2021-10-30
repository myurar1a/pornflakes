import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pornflakes/view/video_page.dart';

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
        colorScheme: ColorScheme.light().copyWith(
          primary: Color.fromRGBO(255, 153, 0, 1.0),
          secondary: Color.fromRGBO(255, 153, 0, 1.0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      //home: MainPage(),
      initialRoute: '/', // ここ以降の定義がルーティング定義
      routes: {
        '/': (context) => MainPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TabType { home, hot, popular, library }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.home);
