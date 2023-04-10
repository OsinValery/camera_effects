import 'package:equatable/equatable.dart' show Equatable;

abstract class StyleSelectionStateBase extends Equatable {
  const StyleSelectionStateBase(
      this.curPath, this.assetesOpened, this.useFromAssets);
  final String curPath;
  final bool useFromAssets;
  final bool assetesOpened;

  @override
  List<Object?> get props => [curPath, useFromAssets, assetesOpened];
}

class StyleSelectionState extends StyleSelectionStateBase {
  const StyleSelectionState(curPath, assetesOpened, useFromAssets)
      : super(curPath, assetesOpened, useFromAssets);
  StyleSelectionState copyWith({
    String? newPath,
    bool? newUse,
    bool? newOpened,
  }) =>
      StyleSelectionState(
        newPath ?? curPath,
        newOpened ?? assetesOpened,
        newUse ?? useFromAssets,
      );
}

class StyleSelectionMessageState extends StyleSelectionStateBase {
  const StyleSelectionMessageState(this.type, {this.arguments})
      : super('', false, false);

  final String type;
  final Map? arguments;

  @override
  operator ==(other) => false;

  @override
  int get hashCode => super.hashCode * 1;
}
