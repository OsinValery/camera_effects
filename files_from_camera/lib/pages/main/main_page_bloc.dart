import 'package:files_from_camera/default_bloc.dart' show DefaultBloc;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_style_transfer/tflite_style_transfer.dart';
import 'dart:async' show Timer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imglib;

Uint8List convertImagetoPng(CameraImage image) {
  var buffer = image.planes[0].bytes.buffer;

  var img = imglib.Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: buffer,
    format: imglib.Format.uint8,
    order: imglib.ChannelOrder.bgra,
  );

  return imglib.encodePng(img);
  //return null;
}

@pragma('vm:entry-point')
String saveImage(Map<String, dynamic> data) {
  String path = data['path'];
  var file = File(path);
  if (file.existsSync()) file.deleteSync();
  file.createSync(recursive: true);
  print('start saving');
  var img = imglib.Image.fromBytes(
    width: data['width'],
    height: data['height'],
    bytes: data['img'].buffer,
    format: imglib.Format.uint8,
    order: imglib.ChannelOrder.bgra,
  );

  var encoded = imglib.encodePng(img);
  file.writeAsBytesSync(encoded);
  return path;
}

class MainPageBloc extends DefaultBloc {
  MainPageBloc(context) : super(context);

  CameraController? _controller;
  Timer? _timer;
  final styleTransfer = TFLiteStyleTransfer();

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

  void startImageLoading() {
    i = (i + 1) % N;
    String path = '$picturesDir/Pictures/tmp$i.png';
    compute(saveImage, {
      'path': path,
      "width": img!.width,
      "height": img!.height,
      'img': img!.planes[0].bytes,
    }).then((value) {
      imageLoaded = true;
      curPath = value;
    });
    imageLoaded = false;
  }

  @override
  void workEvent(Map<String, dynamic> data) async {
    String type = data['type'];

    switch (type) {
      case 'init':
        var cameras = await availableCameras();
        picturesDir = (await getApplicationDocumentsDirectory()).path;
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

        while (!imageLoaded) {
          await Future.delayed(const Duration(milliseconds: 1));
        }
        startImageLoading();
        DateTime fileSaved = DateTime.now();

        var result = await styleTransfer.runStyleTransfer(
          styleImagePath: stylePath,
          imagePath: curPath!,
          styleFromAssets: true,
        );
        DateTime finish = DateTime.now();

        print("save image: ${fileSaved.difference(start)}");
        print("processing image: ${finish.difference(fileSaved)}");
        producing = false;
        print('completed');
        resPath = result;

        Image getImageData(String path) {
          File f = File(path);
          return Image.memory(f.readAsBytesSync(), gaplessPlayback: true);
        }

        compute<String, Image>(getImageData, resPath!).then((value) {
          stylizedImage = value;
          notificationSink.add(curState);
        });

        return;

      case "start":
        if (runned) return;
        runned = true;
        stylePath = 'assets/styles/style12.jpg';
        _controller?.startImageStream((image) async => img = image);
        _timer = Timer.periodic(
          const Duration(milliseconds: 25),
          (_) => eventsSink.add({"type": 'timer'}),
        );

        Timer(
          const Duration(milliseconds: 50),
          startImageLoading,
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
        break;
      case "dec":
        if (style != 0) style -= 1;
        stylePath = 'assets/styles/style$style.jpg';
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
