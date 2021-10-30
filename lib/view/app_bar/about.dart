import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('このアプリについて'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PornflakesはPornHubの動画を\n快適に閲覧するためのアプリです\n\nPornflakes v0.1.6.0',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
