import 'package:flutter/material.dart';

class NoCameraView extends StatelessWidget {
  const NoCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Style transfer app')),
      body: const Center(child: Text('This device does not support camera.')),
    );
  }
}
