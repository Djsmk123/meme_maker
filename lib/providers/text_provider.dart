import 'package:flutter/material.dart';

import '../screens/meme_maker_components/draggable_image.dart';
import '../screens/meme_maker_components/text_widget.dart';

class TextProvider extends ChangeNotifier {
  List<TextWidget> dragText = [];
  bool isTopAdded = false;
  get getTopAdded => isTopAdded;
  get getDraggableText => dragText;

  List<ImageWidget> dragImage=[];
  get getImages=>dragImage;

  final captionModel=TopCaption();
  addDragImage(bytes) {
    dragImage.add(ImageWidget(bytes: bytes,));
    notifyListeners();
  }
  addDragText() {
    dragText.add(const TextWidget());
    notifyListeners();
  }

  changeIsTopAdded() {
    isTopAdded = !getTopAdded;
    notifyListeners();
  }
  get topCaptionTxtClr=>captionModel.txtClr;
  get topCaptionBackClr=>captionModel.backClr;
  set setTopCaptionTxtClr(Color value){
    captionModel.txtClr=value;
    notifyListeners();
  }
  set setTopCaptionBackClr(Color value){
    captionModel.backClr=value;
    notifyListeners();
  }
}
class TopCaption{
  Color backClr=Colors.black;
  Color txtClr=Colors.white;
}