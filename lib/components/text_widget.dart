import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';

import '../models/fontclass.dart';

class TextWidget extends StatefulWidget {
  final int index;
  const TextWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  final FocusNode focusNode=FocusNode();
  final FontClass fontClass=FontClass();
  bool isFocused=false;
  bool isVisible=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted) {
      focusNode.addListener(() {
      setState(() {
        isFocused=focusNode.hasPrimaryFocus;
      });
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: isFocused,
              child:Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        fontClass.fontSize++;
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        fontClass.fontSize--;
                      });
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap:(){
                      showDialog(context: context, builder: (builder){
                        return AlertDialog(
                            content: SingleChildScrollView(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: FontPicker(
                                    showInDialog: true,
                                    initialFontFamily: 'Anton',
                                    onFontChanged: (font) {
                                      setState(() {
                                        fontClass.selectedFont = font.fontFamily;
                                        fontClass.selectedFontTextStyle = font.toTextStyle();
                                      });
                                      debugPrint(
                                          "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}");
                                    },
                                    googleFonts: fontClass.myGoogleFonts),
                              ),
                            ));
                      });
                    },


                    child: const Icon(Icons.font_download),
                  ),
                  const SizedBox(width: 10,),
                  GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: fontClass.pickerColor,
                                    onColorChanged: (changeColor){
                                      setState(() {
                                        fontClass.pickerColor=changeColor;
                                      });
                                    },
                                  )
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Change'),
                                  onPressed: () {
                                    setState(() => fontClass.currentColor = fontClass.pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );

                      },
                      child: const Icon(Icons.colorize)),
                  const SizedBox(width: 10,),
                  GestureDetector(
                      onTap: (){
                       setState(() {
                         isVisible=false;
                       });
                      },
                      child: const Icon(Icons.delete)),
                ],
              ) ),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    autofocus: false,
                    cursorWidth: isFocused?2:0,
                    autocorrect: true,
                    style: fontClass.selectedFontTextStyle.copyWith(
                        color: fontClass.currentColor,
                        fontSize:fontClass.fontSize
                    ),
                    onTap: (){
                      setState(() {
                        isFocused=!isFocused;

                      });
                    },
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        hintText: "Text 1",
                        hintStyle: fontClass.selectedFontTextStyle.
                        copyWith(color: fontClass.currentColor, fontSize: fontClass.fontSize),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}