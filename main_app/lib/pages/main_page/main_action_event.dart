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
