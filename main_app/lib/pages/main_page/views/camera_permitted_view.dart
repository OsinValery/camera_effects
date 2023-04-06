import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main_action_event.dart';
import '../main_action_state.dart' show MainActionState;

class CameraView extends StatelessWidget {
  const CameraView({super.key, required this.state});

  final MainActionState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style transfer app')),
      body: Stack(
        children: const [
          Text('present camera'),
        ],
      ),
    );
  }
}
