import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LastIndicator extends StatelessWidget {
  final VoidCallback onVisible;
  LastIndicator(this.onVisible);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key("for detect visibility"),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1) {
            onVisible();
          }
        },
        child: Column(
          children: [
            Divider(
              height: 1,
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ));
  }
}
