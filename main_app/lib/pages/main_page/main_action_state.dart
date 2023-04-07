import 'package:camera/camera.dart' show CameraImage;
import 'package:equatable/equatable.dart' show Equatable;

enum CameraMode {
  video,
  picture;
}

class MainActionState extends Equatable {
  const MainActionState({
    this.cameraMode = CameraMode.picture,
    this.cameraPermitted = false,
    this.curCameraImage,
    this.stylePath = 'assets/styles/style0.jpg',
    this.styleTransferRunned = false,
    this.stylizedImage,
    this.useStyleFromAssets = true,
  });
  final bool styleTransferRunned;
  final List<int>? stylizedImage;
  final CameraImage? curCameraImage;
  final String stylePath;
  final bool useStyleFromAssets;
  final bool cameraPermitted;
  final CameraMode cameraMode;

  @override
  List<Object?> get props => [
        stylePath,
        curCameraImage,
        styleTransferRunned,
        stylizedImage,
        useStyleFromAssets,
        cameraPermitted,
        cameraMode
      ];

  MainActionState copyWith(
          {bool? styleTransferRunned,
          List<int>? stylizedImage,
          CameraImage? curCameraImage,
          String? stylePath,
          bool? useStyleFromAssets,
          bool? cameraPermitted,
          CameraMode? cameraMode}) =>
      MainActionState(
        cameraMode: cameraMode ?? this.cameraMode,
        stylePath: stylePath ?? this.stylePath,
        styleTransferRunned: styleTransferRunned ?? this.styleTransferRunned,
        stylizedImage: stylizedImage ?? this.stylizedImage,
        curCameraImage: curCameraImage ?? this.curCameraImage,
        useStyleFromAssets: useStyleFromAssets ?? this.useStyleFromAssets,
        cameraPermitted: cameraPermitted ?? this.cameraPermitted,
      );
}
