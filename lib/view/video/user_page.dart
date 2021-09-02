import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ユーザーページは現在開発中です\n実装までしばらくお待ち下さい'),
            ],
          ),
        ),
      ),
    );
  }
}
