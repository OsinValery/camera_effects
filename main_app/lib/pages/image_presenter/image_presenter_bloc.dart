import 'package:flutter_bloc/flutter_bloc.dart';
import './image_presenter_state.dart';
import './image_presenter_event.dart';

class ImagePresenterBloc
    extends Bloc<ImagePresenterEvent, ImagePresenterState> {
  ImagePresenterBloc() : super(const ImagePresenterState(false, false)) {
    on<InvertBackgroundEvent>(_onInavertBackgroundEvent);
  }

  _onInavertBackgroundEvent(event, Emitter emitter) async {
    emitter(state.copyWith(false, !state.presentDark));
  }
}
