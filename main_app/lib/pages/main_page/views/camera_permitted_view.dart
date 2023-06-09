import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_app/pages/main_page/main_action_bloc.dart';

import '../main_action_event.dart';
import '../main_action_state.dart' show MainActionState;
import 'bottom_camera_menu.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key, required this.state});

  final MainActionState state;

  IconData get cameraSwitchIcon =>
      Platform.isIOS ? Icons.flip_camera_ios : Icons.flip_camera_android;

  @override
  Widget build(BuildContext context) {
    var info = MediaQuery.of(context);
    Widget image = SizedBox(width: info.size.width, height: info.size.width);
    if (state.stylizedImage != null) {
      image = Image.memory(
        state.stylizedImage! as Uint8List,
        gaplessPlayback: true,
        width: info.size.width,
        height: info.size.width,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Style transfer app'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<MainActionBloc>().add(ChangeCameraEvent()),
            icon: Icon(cameraSwitchIcon),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onScaleUpdate: (details) {
                context.read<MainActionBloc>().add(ZoomingEvent(details.scale));
              },
              onScaleStart: (details) {
                context.read<MainActionBloc>().add(ZoomStartEvent());
              },
              child: image,
            ),
          ),
        ),
        BottomMenu(
          lastPicturePath: state.lastImage,
          btnState: CameraStateButtonState.photo,
          stylePath: state.stylePath,
          useStyleFromAssets: state.useStyleFromAssets,
        ),
      ]),
    );
  }
}
