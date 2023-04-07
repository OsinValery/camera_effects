import 'dart:async';
import 'dart:io' show File;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:tflite_style_transfer/tflite_style_transfer.dart'
    show TFLiteStyleTransfer;

import 'main_action_state.dart';
import 'main_action_event.dart';
import 'package:main_app/services/image_saver_service.dart'
    show ImageSaverService;

class MainActionBloc extends Bloc<MainActionEvent, MainActionState> {
  MainActionState curState = const MainActionState();
  late CameraController _cameraController;
  Timer? styleTimer;
  Future<String>? imageLoadingProgress;
  bool imageProcessing = false;

  MainActionBloc() : super(const MainActionState()) {
    on<InitStateEvent>(_onInitStateEvent);
    on<StyleTimerEvent>(_onStyleTimerEvent);
  }

  void prepareCameraController(CameraDescription description) {
    _cameraController = CameraController(description, ResolutionPreset.low);
    _cameraController.initialize().then((value) {
      _cameraController.startImageStream(
        (image) => curState = curState.copyWith(curCameraImage: image),
      );
      styleTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (imageProcessing) return;
        add(StyleTimerEvent());
      });
    });
  }

  void _onInitStateEvent(event, Emitter emitter) async {
    var description = (await availableCameras())[0];
    emitter(curState);

    var status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) {
      curState = curState.copyWith(cameraPermitted: true);
    } else {
      var status = await Permission.camera.request();
      if (status.isGranted) curState = curState.copyWith(cameraPermitted: true);
      if (status.isLimited) curState = curState.copyWith(cameraPermitted: true);
    }

    if (curState.cameraPermitted) prepareCameraController(description);
    emitter(curState);
  }

  Future<void> _onStyleTimerEvent(event, Emitter emitter) async {
    var service = GetIt.instance<ImageSaverService>();
    if (imageLoadingProgress == null) {
      if (curState.curCameraImage == null) return;
      imageLoadingProgress = service.startImageLoading(
        curState.curCameraImage!.planes[0].bytes,
        curState.curCameraImage!.width,
        curState.curCameraImage!.height,
      );
      return;
    }
    // here I am in full transform cycle
    DateTime start = DateTime.now();
    imageProcessing = true;
    String path = (await imageLoadingProgress!);
    imageLoadingProgress = service.startImageLoading(
      curState.curCameraImage!.planes[0].bytes,
      curState.curCameraImage!.width,
      curState.curCameraImage!.height,
    );
    var styleTransfer = GetIt.instance<TFLiteStyleTransfer>();
    var result = await styleTransfer.runStyleTransfer(
      styleImagePath: curState.stylePath,
      imagePath: path,
      styleFromAssets: curState.useStyleFromAssets,
    );
    curState =
        curState.copyWith(stylizedImage: File(result!).readAsBytesSync());
    imageProcessing = false;
    DateTime finish = DateTime.now();
    emitter(curState);
    print(finish.difference(start));
  }

  @override
  Future<void> close() async {
    await _cameraController.stopImageStream();
    await _cameraController.dispose();
    styleTimer?.cancel();
    return super.close();
  }
}
