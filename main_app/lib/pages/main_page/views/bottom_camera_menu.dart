import 'package:flutter/material.dart';
import 'dart:io' show File;

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    super.key,
    required this.btnState,
    required this.lastPicturePath,
    required this.stylePath,
    required this.useStyleFromAssets,
  });

  final String? lastPicturePath;
  final String stylePath;
  final CameraStateButtonState btnState;
  final bool useStyleFromAssets;

  @override
  Widget build(BuildContext context) {
    var windowSize = MediaQuery.of(context).size;
    var menuHeight = windowSize.height / 5;
    var iconsSide = menuHeight / 2.8;

    var lastImage = lastPicturePath == null
        ? Container()
        : Image.file(
            File(lastPicturePath!),
            gaplessPlayback: true,
            width: iconsSide,
            height: iconsSide,
          );
    late Widget styleImage;
    if (useStyleFromAssets) {
      styleImage = Image.asset(stylePath, width: iconsSide, height: iconsSide);
    } else {
      styleImage = Image.file(
        File(stylePath),
        width: iconsSide,
        height: iconsSide,
      );
    }

    return Container(
      color: const Color.fromARGB(204, 0, 0, 0),
      height: menuHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          lastImage,
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            width: iconsSide,
            height: iconsSide,
          ),
          styleImage,
        ],
      ),
    );
  }
}

enum CameraStateButtonState {
  cameraStop,
  cameraPlay,
  photo;
}
