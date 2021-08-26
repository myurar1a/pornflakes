import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'view/main_page.dart';

void main() {
  runApp(ProviderScope(child: App()));
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
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TabType { home, hot, popular, library }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.home);
