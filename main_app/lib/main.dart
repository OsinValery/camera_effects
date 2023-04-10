import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'services/image_saver_service.dart' show ImageSaverService;
import 'package:tflite_style_transfer/tflite_style_transfer.dart'
    show TFLiteStyleTransfer;
import 'services/styles_images_service.dart' show AssetsStylesImagesService;

import 'pages/main_page/main_page.dart' show MainPage;
import 'pages/style_selector/view.dart' show StyleSelectionPage;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<ImageSaverService>(ImageSaverService());
  getIt.registerSingleton<TFLiteStyleTransfer>(TFLiteStyleTransfer());
  getIt.registerSingleton<AssetsStylesImagesService>(
      AssetsStylesImagesService());
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
      initialRoute: "/",
      routes: {
        '/': (context) => const MainPage(),
        '/styleChanging': (_) => const StyleSelectionPage()
      },
    );
  }
}
