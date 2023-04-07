import '../default_bloc.dart' show DefaultBloc;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Timer;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imglib;
import 'package:second_library/style_transfer_service.dart'
    show StyleTransferService;

class MainPageBloc extends DefaultBloc {
  MainPageBloc(context) : super(context);

  CameraController? _controller;
  Timer? _timer;
  StyleTransferService styleTransfer = StyleTransferService();

  bool runned = false;
  bool producing = false;
  bool imageLoaded = false;
  String? curPath;
  String? resPath;
  String stylePath = 'assets/styles/style0.jpg';
  Image? stylizedImage;

  String picturesDir = '';
  CameraImage? img;
  int N = 300;
  int i = 0;
  int style = 0;

  Map<String, dynamic> get curState {
    return {
      'start': runned,
      "result": resPath,
      "current": curPath,
      "controller": _controller,
      "preloaded": stylizedImage,
      "style": style,
    };
  }

  @override
  void workEvent(Map<String, dynamic> data) async {
    String type = data['type'];

    switch (type) {
      case 'init':
        var cameras = await availableCameras();
        picturesDir = (await getApplicationDocumentsDirectory()).path;
        styleTransfer.loadModels();
        styleTransfer.prepareStyle(stylePath);
        _controller = CameraController(
          cameras[0],
          ResolutionPreset.low,
          imageFormatGroup: ImageFormatGroup.bgra8888,
        );
        try {
          await _controller!.initialize();
        } catch (e) {
          debugPrint('no permission');
          return;
        }

        break;
      case "timer":
        print('timer');
        if (producing) return;
        if (img == null) return;
        print('run');
        producing = true;
        DateTime start = DateTime.now();

        var result = await styleTransfer.transfer(
            img!.planes[0].bytes, img!.width, img!.height);

        DateTime finish = DateTime.now();

        producing = false;
        print('completed');
        print(finish.difference(start));

        Image getImageData(imglib.Image img) =>
            Image.memory(imglib.encodePng(img) as Uint8List,
                gaplessPlayback: true);

        compute<imglib.Image, Image>(getImageData, result).then((value) {
          stylizedImage = value;
          print('present');
          notificationSink.add(curState);
        });

        return;

      case "start":
        if (runned) return;
        runned = true;
        _controller?.startImageStream((image) async => img = image);
        _timer = Timer.periodic(
          const Duration(milliseconds: 25),
          (_) => eventsSink.add({"type": 'timer'}),
        );

        break;

      case 'stop':
        _timer?.cancel();
        if (runned) {
          _controller?.stopImageStream();
        }
        runned = false;
        break;
      case 'inc':
        if (style != 25) style += 1;
        stylePath = 'assets/styles/style$style.jpg';
        styleTransfer.prepareStyle(stylePath);
        break;
      case "dec":
        if (style != 0) style -= 1;
        stylePath = 'assets/styles/style$style.jpg';
        styleTransfer.prepareStyle(stylePath);
        break;

      default:
        debugPrint("unknown message: $data");
        break;
    }

    notificationSink.add(curState);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}
