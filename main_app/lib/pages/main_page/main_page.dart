import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_app/pages/main_page/main_action_event.dart';
import 'main_action_bloc.dart' show MainActionBloc;
import 'main_action_state.dart';

import './views/camer_no_permitted_view.dart';
import './views/camera_permitted_view.dart';
import './views/no_camera.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainActionBloc>(
      create: (context) => MainActionBloc()..add(InitStateEvent()),
      child: const MainPageView(),
    );
  }
}

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainActionBloc, MainActionState>(
      listener: (context, state) {
        state as AnotherActionState;
        if (state.type == 'noPermission') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No permission yet!")),
          );
        } else if (state.type == 'style') {
          Navigator.of(context)
              .pushNamed("/styleChanging", arguments: state.arguments!)
              .then((value) {
            context
                .read<MainActionBloc>()
                .add(FinishStyleSelectionEvent(value as Map<String, dynamic>?));
          });
        }
      },
      listenWhen: (previous, current) => current.runtimeType != MainActionState,
      buildWhen: (previous, current) => current.runtimeType == MainActionState,
      builder: (context, state) {
        if (!state.cameraAvailable) return const NoCameraView();
        if (state.cameraPermitted != true) {
          return CameraPermittionView(
              canRequest: state.cameraPermitted != null);
        }

        return CameraView(state: state);
      },
    );
  }
}
