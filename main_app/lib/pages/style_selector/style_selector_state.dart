import 'package:equatable/equatable.dart' show Equatable;

abstract class StyleSelectionStateBase extends Equatable {
  const StyleSelectionStateBase(this.curPath, this.useFromAssets);
  final String curPath;
  final bool useFromAssets;

  @override
  List<Object?> get props => [curPath, useFromAssets];
}

class StyleSelectionState extends StyleSelectionStateBase {
  const StyleSelectionState(curPath, assetesOpened)
      : super(curPath, assetesOpened);
  StyleSelectionState copyWith({
    String? newPath,
    bool? newUse,
  }) =>
      StyleSelectionState(newPath ?? curPath, newUse ?? useFromAssets);
}

class StyleSelectionMessageState extends StyleSelectionStateBase {
  const StyleSelectionMessageState(this.type, {this.arguments})
      : super('', false);

  final String type;
  final Map? arguments;

  @override
  operator ==(other) => false;

  @override
  int get hashCode => super.hashCode * 1;
}
