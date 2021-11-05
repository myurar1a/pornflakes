import 'package:flutter/material.dart';

Widget loadingView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 20),
      ],
    ),
  );
}

Widget videoLoadingView(BuildContext context) {
  return Center(
    child: Column(children: [
      Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 16 * 9,
          child: Container(
            color: Colors.black,
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(backgroundColor: Colors.black),
            ),
          ),
        ),
      ]),
      Flexible(
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    ]),
  );
}

Widget errorView(String error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(error)],
    ),
  );
}
