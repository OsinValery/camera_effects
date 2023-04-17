import 'package:equatable/equatable.dart' show Equatable;

class ImagePresenterState extends Equatable {
  const ImagePresenterState(this.shouldListen, this.presentDark);
  final bool shouldListen;
  final bool presentDark;
  @override
  List<Object?> get props => [shouldListen, presentDark];

  ImagePresenterState copyWith(
    bool? listen,
    bool? dark,
  ) =>
      ImagePresenterState(listen ?? shouldListen, dark ?? presentDark);
}
