import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_action_state.dart';
import 'main_action_event.dart';

class MainActionBloc extends Bloc<MainActionEvent, MainActionState> {
  MainActionState curState = MainActionState();

  MainActionBloc() : super(MainActionState()) {
    on<InitStateEvent>(_onInitStateEvent);
  }

  void _onInitStateEvent(event, Emitter emitter) {
    print('initState');
    emitter(curState);
  }

  @override
  Future<void> close() {
    print('bloc has finished');
    return super.close();
  }
}
