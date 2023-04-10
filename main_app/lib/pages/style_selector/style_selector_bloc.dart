import 'package:flutter_bloc/flutter_bloc.dart';
import 'style_selector_event.dart';
import 'style_selector_state.dart';

class StyleSelectionBloc
    extends Bloc<StyleSelectionEventBase, StyleSelectionStateBase> {
  StyleSelectionBloc(String path, bool fromAssets)
      : super(StyleSelectionState(path, fromAssets, fromAssets)) {
    on<ChangeStyleTypeEvent>(_onChangeStyleTypeEvent);
    on<ChangeStyleEvent>(_onStyleSelected);
  }

  _onChangeStyleTypeEvent(ChangeStyleTypeEvent event, Emitter emitter) {
    var st = state as StyleSelectionState;
    emitter(st.copyWith(newOpened: (event.type == 0)));
  }

  _onStyleSelected(ChangeStyleEvent event, Emitter emitter) {
    print(event.curPath);
    var curState = state as StyleSelectionState;
    curState = curState.copyWith(
      newPath: event.curPath,
      newUse: curState.assetesOpened,
    );
    emitter(StyleSelectionMessageState('notifyMainBloc', arguments: {
      "type": state.assetesOpened,
      'path': event.curPath,
    }));
    emitter(state);
    emitter(curState);
  }
}
