import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image/image.dart' as imglib;

@pragma('vm:entry-point')
String saveImage(Map<String, dynamic> data) {
  String path = data['path'];
  var file = File(path);
  if (file.existsSync()) file.deleteSync();
  file.createSync(recursive: true);
  var img = imglib.Image.fromBytes(
    width: data['width'],
    height: data['height'],
    bytes: data['img'].buffer,
    format: imglib.Format.uint8,
    order: imglib.ChannelOrder.bgra,
  );

  var encoded = imglib.encodeJpg(img);
  file.writeAsBytesSync(encoded);
  return path;
}

class ImageSaverService {
  int N = 20;
  int i = 0;
  String? tmpDir;

  Future<String> startImageLoading(
      Uint8List image, int width, int height) async {
    i = (i + 1) % N;
    tmpDir ??= (await path_provider.getTemporaryDirectory()).path;
    String path = '$tmpDir/Pictures/tmp$i.jpg';
    await compute(saveImage, {
      'path': path,
      "width": width,
      "height": height,
      "img": image,
    });
    return path;
  }
}
