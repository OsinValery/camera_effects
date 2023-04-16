import 'package:flutter_bloc/flutter_bloc.dart';
import 'style_selector_event.dart';
import 'style_selector_state.dart';

class StyleSelectionBloc
    extends Bloc<StyleSelectionEventBase, StyleSelectionStateBase> {
  StyleSelectionBloc(String path, bool fromAssets)
      : super(StyleSelectionState(path, fromAssets)) {
    on<ChangeStyleEvent>(_onStyleSelected);
  }

  _onStyleSelected(ChangeStyleEvent event, Emitter emitter) {
    print(event.curPath);
    print(event.type);
    var curState = state as StyleSelectionState;
    curState = curState.copyWith(
      newPath: event.curPath,
      newUse: event.type == 0,
    );
    emitter(StyleSelectionMessageState('notifyMainBloc', arguments: {
      "type": curState.useFromAssets,
      'path': event.curPath,
    }));
    emitter(state);
    emitter(curState);
  }
}
