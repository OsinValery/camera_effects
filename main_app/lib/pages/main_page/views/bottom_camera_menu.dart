import 'package:flutter/material.dart';
import 'dart:io' show File;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_app/pages/main_page/main_action_bloc.dart';
import '../main_action_event.dart';

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
        ? SizedBox(width: iconsSide, height: iconsSide)
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.green),
            ),
            width: iconsSide,
            height: iconsSide,
            child: GestureDetector(
              onTap: () => context.read<MainActionBloc>().add(TakePhoteEvent()),
            ),
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
