import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'services/image_saver_service.dart' show ImageSaverService;
import 'package:tflite_style_transfer/tflite_style_transfer.dart'
    show TFLiteStyleTransfer;

import 'pages/main_page/main_page.dart' show MainPage;

void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<ImageSaverService>(ImageSaverService());
  getIt.registerSingleton<TFLiteStyleTransfer>(TFLiteStyleTransfer());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Style transfer app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
