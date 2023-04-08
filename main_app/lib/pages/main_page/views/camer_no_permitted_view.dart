import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_app/pages/main_page/main_action_bloc.dart';
import 'package:main_app/pages/main_page/main_action_event.dart';

class CameraPermittionView extends StatelessWidget {
  const CameraPermittionView({Key? key, required this.canRequest})
      : super(key: key);

  final bool canRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style transfer app')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("вы должны дать разрешение на использование камеры"),
            canRequest
                ? ElevatedButton(
                    onPressed: () => context
                        .read<MainActionBloc>()
                        .add(RequestCameraPermissionEvent()),
                    child: const Text('Request'))
                : const Text(
                    "You denied permission. You should grant it from settings."),
            if (canRequest)
              ElevatedButton(
                  onPressed: () => context
                      .read<MainActionBloc>()
                      .add(RequestCameraPermissionEvent()),
                  child: const Text('Request'))
          ],
        ),
      ),
    );
  }
}
