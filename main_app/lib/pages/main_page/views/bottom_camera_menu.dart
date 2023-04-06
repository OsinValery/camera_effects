import 'package:flutter/material.dart';
import 'dart:io' show File;

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    super.key,
    required this.btnState,
    required this.lastPicturePath,
    required this.stylePath,
  });

  final String lastPicturePath;
  final String stylePath;
  final CameraStateButtonState btnState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(204, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.file(File(lastPicturePath), gaplessPlayback: true),
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
          ),
          Image.file(File(stylePath)),
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
