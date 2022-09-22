import 'package:flutter/material.dart';

import 'text_widget.dart';

class DraggableText extends StatefulWidget {
  final int index;

  const DraggableText({Key? key, required this.index}) : super(key: key);

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  Offset offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              offset = Offset(
                  offset.dx + details.delta.dx, offset.dy + details.delta.dy);
            });
          },
          child: SizedBox(
            height: 350,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextWidget(
                index: widget.index,
              ),
            ),
          ),
        ));
  }
}
