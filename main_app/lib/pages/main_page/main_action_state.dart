enum CameraMode {
  video,
  picture;
}

class MainActionState {
  MainActionState();
  bool styleTransferRunned = false;
  List<int>? stylizedImage;
  String stylePath = 'file.png';
  bool useStyleFromAssets = true;
  bool cameraPermitted = false;
  CameraMode cameraMode = CameraMode.picture;
}
