import 'package:flutter/material.dart';

class DragProvider extends ChangeNotifier {
  Offset offset = Offset.zero;
  get getOffset => offset;
  set setOffset(details) {
    offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy);
    notifyListeners();
  }
}
