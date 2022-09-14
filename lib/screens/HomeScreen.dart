import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:meme_maker/constant.dart';
import 'package:meme_maker/providers/text_provider.dart';
import 'package:provider/provider.dart';
class MemeEditorScreen extends StatefulWidget {
  final ImageProvider image;
  const MemeEditorScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<MemeEditorScreen> createState() => _MemeEditorScreenState();
}

class _MemeEditorScreenState extends State<MemeEditorScreen> {
  final GlobalKey _globalKey = GlobalKey();
  Future<Uint8List?> capturePng() async {
    try {

      var boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image? image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      rethrow;
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TextProvider>(context,listen: false).isTopAdded=false;
    Provider.of<TextProvider>(context,listen: false).dragText.clear();
  }
  @override
  Widget build(BuildContext context) {
    List dragText=Provider.of<TextProvider>(context).getDraggableText;
    bool isTopAdded=Provider.of<TextProvider>(context).getTopAdded;
    return Scaffold(
      appBar:appBar(),
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isTopAdded,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  decoration:const BoxDecoration(
                    color: Colors.black
                  ),
                  child: Row(
                    children: [
                      Flexible(child: TextFormField(
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Add your caption here",
                          hintStyle:  TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            Stack(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue,
                      image: DecorationImage(
                          image:widget.image,
                        fit: BoxFit.fill
                  ),
                ),
                ),
               for(int i=0; i<dragText.length; i++)
                 dragText[i]
              ],
            )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar()
    );

  }
  AppBar appBar(){
  return AppBar(
      backgroundColor: kPrimaryColor,
      title: const Text("Meme Generator",style: TextStyle(
          color: Colors.white,
          fontSize: 30
      ),
      ),
    ) ;
  }
  Widget bottomNavBar(){
    return BottomNavigationBar(
      iconSize: 30,
      currentIndex: 0,
      backgroundColor: kPrimaryColor,
      selectedItemColor:Colors.white,
      selectedLabelStyle:const TextStyle(
          color: Colors.white
      ),
      selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 30
      ),
      onTap: (index) async {
        switch(index){
          case 0:{
            Provider.of<TextProvider>(context,listen: false).addDragText();
          }
          break;
          case 1:{
            Provider.of<TextProvider>(context,listen: false).changeIsTopAdded();
            break;
          }
          case 2: {

            try{
              final bytes=await capturePng();
              await ImageGallerySaver.saveImage(bytes!, name:"meme${DateTime.now()}");
              Fluttertoast.showToast(msg: "Image Saved in the gallery");

            } on Exception catch(_,e){
              debugPrint(e.toString());
              Fluttertoast.showToast(msg: "Unable to save image!!!,try again.");
            }

            break;
          }

        }
      },
      unselectedItemColor:Colors.white,
      unselectedLabelStyle:const TextStyle(
          color: Colors.white
      ),
      unselectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 30
      ),

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.text_format),label:"Text",),
        BottomNavigationBarItem(icon: Icon(Icons.closed_caption_off_rounded),label:"Top Caption"),
        BottomNavigationBarItem(icon: Icon(Icons.save_alt),label:"Save")
      ],
    );
  }
}





