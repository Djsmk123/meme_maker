import 'package:flutter/material.dart';

import '../screens/meme_maker_components/dragble_text.dart';
class TextProvider extends ChangeNotifier{
  List<DraggableText> dragText=[];
  bool isTopAdded=false;
  get getTopAdded=>isTopAdded;
  get getDraggableText=>dragText;
  addDragText(){
    dragText.add(DraggableText(index: dragText.length,));
    notifyListeners();
  }
  removeDragText(index){
    //dragText.remove(dragText);
    notifyListeners();
  }

  changeIsTopAdded(){
    isTopAdded=!getTopAdded;
    notifyListeners();

  }

}