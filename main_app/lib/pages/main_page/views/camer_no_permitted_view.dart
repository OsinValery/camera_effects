import 'package:flutter/material.dart';

class CameraPermittionView extends StatelessWidget {
  const CameraPermittionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style transfer app')),
      body: const Center(
        child: Text("вы должны дать разрешение на использование камеры"),
      ),
    );
  }
}
