abstract class MainActionEvent {}

class InitStateEvent extends MainActionEvent {}

class StyleTimerEvent extends MainActionEvent {}

class TakePhoteEvent extends MainActionEvent {}

class RequestCameraPermissionEvent extends MainActionEvent {}

class ChangeCameraEvent extends MainActionEvent {}

class ZoomStartEvent extends MainActionEvent {}

class ZoomingEvent extends MainActionEvent {
  ZoomingEvent(this.zoom);
  final num zoom;
}

class ChangeStyleEvent extends MainActionEvent {}

class SelectStyleEvent extends MainActionEvent {
  SelectStyleEvent(this.path, this.useAssets);
  bool useAssets;
  String path;
}

class FinishStyleSelectionEvent extends MainActionEvent {
  FinishStyleSelectionEvent(this.argument);
  Map<String, dynamic>? argument;
}

class PresentLastImageEvent extends MainActionEvent {}
