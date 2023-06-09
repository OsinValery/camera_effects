import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle, Uint8List;

class StyleTransferService {
  static const int MODEL_TRANSFER_IMAGE_SIZE = 384;
  static const int MODEL_PREDICTION_IMAGE_SIZE = 256;
  static const num mean = 0;
  static const num std = 256;

  late Interpreter predictor;
  late Interpreter styleTransfer;

  late Uint8List modelPredictionInput;

  void loadModels() async {
    predictor = await Interpreter.fromAsset('models/prediction_model.tflite');
    styleTransfer = await Interpreter.fromAsset('models/transfer_model.tflite');
  }

  Future<Uint8List> loadStyleImage(String styleImagePath) async {
    var styleImageByteData = await rootBundle.load(styleImagePath);
    return styleImageByteData.buffer.asUint8List();
  }

  Future prepareStyle(String path) async {
    var styleData = await loadStyleImage(path);
    var styleImage = img.decodeImage(styleData)!;
    var modelPredictionImage = img.copyResize(styleImage,
        width: MODEL_PREDICTION_IMAGE_SIZE,
        height: MODEL_PREDICTION_IMAGE_SIZE);

    // content_image 384 384 3
    modelPredictionInput = _imageToByteListUInt8(modelPredictionImage,
        MODEL_PREDICTION_IMAGE_SIZE, mean.toDouble(), std.toDouble());
  }

  Future<img.Image> transfer(
    Uint8List originData,
    int width,
    int height,
  ) async {
    var originImage = img.Image.fromBytes(width, height, originData);
    var modelTransferImage = img.copyResize(originImage,
        width: MODEL_TRANSFER_IMAGE_SIZE, height: MODEL_TRANSFER_IMAGE_SIZE);
    var modelTransferInput = _imageToByteListUInt8(
        modelTransferImage, MODEL_TRANSFER_IMAGE_SIZE, 0, 255);

    DateTime start = DateTime.now();

    // style_image 1 256 256 3
    var inputsForPrediction = [modelPredictionInput];
    // style_bottleneck 1 1 100
    var outputsForPrediction = <int, Object>{};
    var styleBottleneck = [
      [
        [List.filled(100, 0.0)]
      ]
    ];
    outputsForPrediction[0] = styleBottleneck;

    // style predict model
    predictor.runForMultipleInputs(inputsForPrediction, outputsForPrediction);

    // content_image + styleBottleneck
    var inputsForStyleTransfer = [modelTransferInput, styleBottleneck];

    var outputsForStyleTransfer = <int, Object>{};
    // stylized_image 1 384 384 3
    var outputImageData = [
      List.generate(
        MODEL_TRANSFER_IMAGE_SIZE,
        (index) => List.generate(
          MODEL_TRANSFER_IMAGE_SIZE,
          (index) => List.filled(3, 0.0),
        ),
      ),
    ];
    outputsForStyleTransfer[0] = outputImageData;

    styleTransfer.runForMultipleInputs(
        inputsForStyleTransfer, outputsForStyleTransfer);

    DateTime finish = DateTime.now();
    print("on model ${finish.difference(start)}");

    var outputImage =
        _convertArrayToImage(outputImageData, MODEL_TRANSFER_IMAGE_SIZE);
    var rotateOutputImage = img.copyRotate(outputImage, 90);
    var flipOutputImage = img.flipHorizontal(rotateOutputImage);

    return flipOutputImage;
  }

  img.Image _convertArrayToImage(
      List<List<List<List<double>>>> imageArray, int inputSize) {
    img.Image image = img.Image.rgb(inputSize, inputSize);
    for (var x = 0; x < imageArray[0].length; x++) {
      for (var y = 0; y < imageArray[0][0].length; y++) {
        var r = (imageArray[0][x][y][0] * 255).toInt();
        var g = (imageArray[0][x][y][1] * 255).toInt();
        var b = (imageArray[0][x][y][2] * 255).toInt();
        image.setPixelRgba(x, y, r, g, b);
      }
    }
    return image;
  }

  Uint8List _imageToByteListUInt8(
    img.Image image,
    int inputSize,
    double mean,
    double std,
  ) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
