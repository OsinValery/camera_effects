import 'dart:async';
import 'dart:io' show File;
import 'dart:math';

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
import 'package:main_app/services/permission_service.dart'
    show PermissionService;

class MainActionBloc extends Bloc<MainActionEvent, MainActionState> {
  MainActionState curState = const MainActionState();
  late CameraController _cameraController;
  Timer? styleTimer;
  Future<String>? imageLoadingProgress;
  bool imageProcessing = false;
  num initialZoom = 1;

  MainActionBloc() : super(const MainActionState()) {
    on<InitStateEvent>(_onInitStateEvent);
    on<StyleTimerEvent>(_onStyleTimerEvent);
    on<RequestCameraPermissionEvent>(_onPermissionRequestEvent);
    on<TakePhoteEvent>(_onTakePictureEvent);
    on<ChangeCameraEvent>(_onCameraSwitchEvent);
    on<ZoomStartEvent>(_onZoomStartEvent);
    on<ZoomingEvent>(_onZoomEvent);
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

  Future disableCameraController() async {
    styleTimer?.cancel();
    await _cameraController.stopImageStream();
    await _cameraController.dispose();
    return;
  }

  void startImageLoading() {
    var service = GetIt.instance<ImageSaverService>();
    imageLoadingProgress = service.startImageLoading(
      curState.curCameraImage!.planes[0].bytes,
      curState.curCameraImage!.width,
      curState.curCameraImage!.height,
    );
  }

  void _onInitStateEvent(event, Emitter emitter) async {
    var availableCameras_ = await availableCameras();
    if (availableCameras_.isEmpty) {
      emitter(curState);
      return;
    }
    var description = availableCameras_[0];
    curState = curState.copyWith(cameraAvailable: true);
    emitter(curState);

    var service = PermissionService();
    curState = curState.copyWith(
        cameraPermitted: await service.requestPermission(Permission.camera));

    if (curState.cameraPermitted == true) prepareCameraController(description);
    emitter(curState);
  }

  Future<void> _onStyleTimerEvent(event, Emitter emitter) async {
    if (imageLoadingProgress == null) {
      if (curState.curCameraImage != null) startImageLoading();
      return;
    }
    // here I am in full transform cycle
    imageProcessing = true;
    String path = await imageLoadingProgress!;
    // start loading picture for the next frame
    startImageLoading();
    var styleTransfer = GetIt.instance<TFLiteStyleTransfer>();
    var res = await styleTransfer.runStyleTransfer(
      styleImagePath: curState.stylePath,
      imagePath: path,
      styleFromAssets: curState.useStyleFromAssets,
    );
    curState = curState.copyWith(stylizedImage: File(res!).readAsBytesSync());
    imageProcessing = false;
    emitter(curState);
  }

  void _onPermissionRequestEvent(event, Emitter emitter) async {
    if (curState.cameraPermitted == true) {
      emitter(curState);
      return;
    }
    var service = PermissionService();
    curState = curState.copyWith(
      cameraPermitted: await service.requestPermission(Permission.camera),
    );
    if (curState.cameraPermitted == true) {
      var availableCameras_ = await availableCameras();
      prepareCameraController(availableCameras_[0]);
      emitter(curState);
    } else {
      emitter(curState);
      emitter(const AnotherActionState(type: 'noPermission'));
    }
  }

  _onTakePictureEvent(event, Emitter emitter) async {
    var file = await _cameraController.takePicture();
    var service = GetIt.instance<TFLiteStyleTransfer>();
    var outPath = await service.runStyleTransfer(
      styleImagePath: curState.stylePath,
      imagePath: file.path,
      styleFromAssets: curState.useStyleFromAssets,
    );
    print(outPath);
  }

  _onCameraSwitchEvent(event, Emitter emitter) async {
    var availableCameras_ = await availableCameras();
    int curCamera = _cameraController.cameraId;
    if (availableCameras_.length == 1) {
      return;
    } else {
      int nextCamera = (curCamera + 1) % availableCameras_.length;
      await disableCameraController();
      prepareCameraController(availableCameras_[nextCamera]);
      curState = curState.copyWith(zoomLavel: 1);
      emitter(curState);
    }
  }

  void _onZoomStartEvent(event, Emitter _) => initialZoom = curState.zoomLavel;

  void _onZoomEvent(ZoomingEvent event, Emitter emitter) async {
    var newZoom = initialZoom * event.zoom;
    var maxZoom = await _cameraController.getMaxZoomLevel();
    var minZoom = await _cameraController.getMinZoomLevel();
    newZoom = max(minZoom, min(newZoom, maxZoom));
    curState = curState.copyWith(zoomLavel: newZoom);
    _cameraController.setZoomLevel(newZoom as double);
    emitter(curState);
  }

  @override
  Future<void> close() async {
    await _cameraController.stopImageStream();
    await _cameraController.dispose();
    styleTimer?.cancel();
    return super.close();
  }
}
