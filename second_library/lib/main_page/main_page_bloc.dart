import '../default_bloc.dart' show DefaultBloc;
import 'package:flutter/foundation.dart' show debugPrint;

class MainPageBloc extends DefaultBloc {
  MainPageBloc(context) : super(context);

  Map<String, dynamic> get curState {
    return {};
  }

  @override
  void workEvent(Map<String, dynamic> data) {
    String type = data['type'];
    switch (type) {
      case 'init':
        break;
      default:
        debugPrint("Unknown event: $data");
        break;
    }
  }
}
