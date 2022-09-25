import 'package:flutter/material.dart';

class FontClass {
  String selectedFont = "Roboto";
  TextStyle selectedFontTextStyle = const TextStyle(
    color: Colors.white
  );
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = Colors.white;
  double fontSize = 30;
  final List<Color> defaultColors = const [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white

  ];

}
