import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreen createState() => _LibraryScreen();
}

class _LibraryScreen extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ライブラリは現在開発中です\n実装までしばらくお待ち下さい'),
        ],
      ),
    );
  }
}
