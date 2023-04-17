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

    Widget btnCenterWidget = btnState == CameraStateButtonState.photo
        ? Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            width: iconsSide - 2,
            height: iconsSide - 2,
            child: Icon(Icons.camera, size: iconsSide / 2),
          )
        : btnState == CameraStateButtonState.cameraPlay
            ? const Text('stop')
            : const Text('start');

    return Container(
      color: const Color.fromARGB(204, 0, 0, 0),
      height: menuHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () =>
                context.read<MainActionBloc>().add(PresentLastImageEvent()),
            child: lastImage,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.green),
            ),
            width: iconsSide,
            height: iconsSide,
            child: GestureDetector(
              onTap: () => context.read<MainActionBloc>().add(TakePhoteEvent()),
              child: btnCenterWidget,
            ),
          ),
          GestureDetector(
            onTap: () => context.read<MainActionBloc>().add(ChangeStyleEvent()),
            child: Hero(
              tag: stylePath,
              child: styleImage,
            ),
          ),
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
