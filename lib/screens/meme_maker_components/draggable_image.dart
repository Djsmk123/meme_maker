import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class ImageWidget extends StatefulWidget {
  final Uint8List bytes;
  const ImageWidget({Key? key, required this.bytes}) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  Matrix4 matrix=Matrix4.identity();
  bool isVisible=true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: MatrixGestureDetector(
            onMatrixUpdate: (m,dx,dy,dz){
              setState(() {
                matrix=m;
              });
            },
            child: Transform(
                transform: matrix,
                child: GestureDetector(
                    onLongPress: (){
                      setState(() {
                        isVisible=false;
                        Fluttertoast.showToast(msg: "Image removed");
                      });
                    },
                    child: Image.memory(widget.bytes)))),
      ),
    );
  }
}
