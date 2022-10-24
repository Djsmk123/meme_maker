import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';

RegExp urlRegX = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
RegExp emailRegX = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const kPrimaryColor = Color(0XFFE64848);
void showToast({String msg="Something went wrong"}){
  Fluttertoast.showToast(msg: msg);
}
Future<Color> getImagePalette (ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator = await PaletteGenerator
      .fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor!.color;
}