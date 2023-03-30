import 'package:flutter/material.dart' show BuildContext, debugPrint;
import 'dart:async' show StreamController;

/// extend this class and override workEvent
abstract class DefaultBloc {
  DefaultBloc(BuildContext context2) {
    context = context2;
    _eventsController = StreamController();
    _notificationController = StreamController();
    _notificationStream = _notificationController.stream.asBroadcastStream();
    eventsStream.listen(workEvent);
  }

  /// widget -> bloc
  late StreamController<Map<String, dynamic>> _eventsController;

  /// bloc -> widget
  late StreamController<Map<String, dynamic>> _notificationController;

  /// widget's context
  late BuildContext context;

  late Stream<Map<String, dynamic>> _notificationStream;
  Sink<Map<String, dynamic>> get notificationSink =>
      _notificationController.sink;
  Sink<Map<String, dynamic>> get eventsSink => _eventsController.sink;
  Stream<Map<String, dynamic>> get notificationStream => _notificationStream;
  Stream<Map<String, dynamic>> get eventsStream => _eventsController.stream;

  void workEvent(Map<String, dynamic> data) => debugPrint(data.toString());

  void dispose() {
    _eventsController.close();
    _notificationController.close();
  }
}
