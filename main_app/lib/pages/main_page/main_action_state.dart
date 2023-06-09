import 'package:camera/camera.dart' show CameraImage;
import 'package:equatable/equatable.dart' show Equatable;

enum CameraMode {
  video,
  picture;
}

class MainActionState extends Equatable {
  const MainActionState({
    this.cameraMode = CameraMode.picture,
    this.cameraPermitted,
    this.curCameraImage,
    this.stylePath = 'assets/styles/style0.jpg',
    this.styleTransferRunned = false,
    this.stylizedImage,
    this.useStyleFromAssets = true,
    this.cameraAvailable = false,
    this.zoomLavel = 1,
    this.lastImage,
  });
  final bool styleTransferRunned;
  final bool cameraAvailable;
  final List<int>? stylizedImage;
  final CameraImage? curCameraImage;
  final String stylePath;
  final String? lastImage;
  final bool useStyleFromAssets;
  final bool? cameraPermitted;
  final CameraMode cameraMode;
  final num zoomLavel;

  @override
  List<Object?> get props => [
        stylePath,
        curCameraImage,
        styleTransferRunned,
        stylizedImage,
        useStyleFromAssets,
        cameraPermitted,
        cameraMode,
        cameraAvailable,
        lastImage,
      ];

  MainActionState copyWith(
          {bool? styleTransferRunned,
          List<int>? stylizedImage,
          CameraImage? curCameraImage,
          String? stylePath,
          String? lastImage,
          bool? useStyleFromAssets,
          bool? cameraPermitted,
          CameraMode? cameraMode,
          num? zoomLavel,
          bool? cameraAvailable}) =>
      MainActionState(
        cameraMode: cameraMode ?? this.cameraMode,
        stylePath: stylePath ?? this.stylePath,
        styleTransferRunned: styleTransferRunned ?? this.styleTransferRunned,
        stylizedImage: stylizedImage ?? this.stylizedImage,
        curCameraImage: curCameraImage ?? this.curCameraImage,
        useStyleFromAssets: useStyleFromAssets ?? this.useStyleFromAssets,
        cameraPermitted: cameraPermitted ?? this.cameraPermitted,
        cameraAvailable: cameraAvailable ?? this.cameraAvailable,
        zoomLavel: zoomLavel ?? this.zoomLavel,
        lastImage: lastImage ?? this.lastImage,
      );
}

class AnotherActionState extends MainActionState {
  const AnotherActionState({this.type, this.arguments});
  final String? type;
  final Map<String, dynamic>? arguments;

  @override
  operator ==(other) => false;

  @override
  int get hashCode => super.hashCode ^ type.hashCode;
}
