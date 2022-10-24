import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import 'package:meme_maker/models/FontClass.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({Key? key}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;
  bool isVisible = true;

  Matrix4 transform=Matrix4.identity();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      focusNode.addListener(() {
        setState(() {
          isFocused = focusNode.hasPrimaryFocus;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: MatrixGestureDetector(
        onMatrixUpdate: (m,ms,my,mx){
          setState(() {
            transform=m;
          });
        },
        child: Stack(

          children: [
            Transform(
              transform: transform,
              child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        autofocus: false,
                        textAlignVertical: TextAlignVertical.center,
                        cursorWidth: isFocused ? 2 : 0,
                        autocorrect: true,

                        style: TextStyle(
                            color: FontClass.currentColor,
                            fontSize: FontClass.fontSize),
                        onTap: () {
                          setState(() {
                            isFocused = !isFocused;
                          });
                        },
                        focusNode: focusNode,
                        decoration: InputDecoration(
                            hintText: "Text 1",
                            hintStyle: TextStyle(
                                color: FontClass.currentColor,
                                fontSize: FontClass.fontSize),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: isFocused,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: FontClass.pickerColor,
                                            availableColors:FontClass.defaultColors,
                                          onColorChanged: (changeColor) {
                                            setState(() {
                                              FontClass.pickerColor = changeColor;
                                            });
                                          },
                                        )),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('Change'),
                                        onPressed: () {
                                          setState(() => FontClass.currentColor =
                                              FontClass.pickerColor);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.colorize)),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = false;
                              });
                            },
                            child: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
