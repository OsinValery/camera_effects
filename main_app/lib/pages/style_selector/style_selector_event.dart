class StyleSelectionEventBase {}

class ChangeStyleEvent extends StyleSelectionEventBase {
  ChangeStyleEvent(this.curPath);
  String curPath;
}

class ChangeStyleTypeEvent extends StyleSelectionEventBase {
  final int type;
  ChangeStyleTypeEvent(this.type);
}
