import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_app/pages/main_page/main_action_event.dart';
import 'main_action_bloc.dart' show MainActionBloc;
import 'main_action_state.dart';

import './views/camer_no_permitted_view.dart';
import './views/camera_permitted_view.dart';

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
      listener: (context, state) {},
      builder: (context, state) {
        if (!state.cameraPermitted) {
          return const CameraPermittionView();
        }
        return CameraView(state: state);
      },
    );
  }
}
