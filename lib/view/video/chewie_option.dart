import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

List<OptionItem> chewieOption(BuildContext context) {
  return [
    OptionItem(
      onTap: () => print('Planned for implementation...'),
      iconData: Icons.settings,
      title: 'Quality',
    ),
  ];
}
