class StyleSelectionEventBase {}

class ChangeStyleEvent extends StyleSelectionEventBase {
  ChangeStyleEvent(this.curPath, this.type);
  String curPath;
  int type;
}
