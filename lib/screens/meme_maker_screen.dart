// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:meme_maker/constant.dart';
import 'package:meme_maker/models/fontclass.dart';
import 'package:meme_maker/providers/text_provider.dart';
import 'package:meme_maker/screens/meme_maker_components/draggable_image.dart';
import 'package:meme_maker/services/getTemplate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../components/custom_app_bar.dart';

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
      var boundary = _globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      ui.Image? image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TextProvider>(context, listen: false).isTopAdded = false;
    Provider.of<TextProvider>(context, listen: false).dragText.clear();
    Provider.of<TextProvider>(context, listen: false).dragImage.clear();
    initAsync();
  }
  initAsync()async{
    try{
      FontClass.currentColor = await getImagePalette(widget.image);
      setState(() {
      });
    }catch(e){
      log(e.toString());
    }finally{
      setState(() {
        isLoading=false;
      });
    }



  }
  @override
  Widget build(BuildContext context) {
    List dragText = Provider.of<TextProvider>(context).getDraggableText;
    bool isTopAdded = Provider.of<TextProvider>(context).getTopAdded;
    List<ImageWidget> imageWidget=Provider.of<TextProvider>(context).getImages;
    return Scaffold(
        appBar: customAppBar( "Meme Generator",actions: false),
        body: Center(
          child: isLoading?const CircularProgressIndicator(color: kPrimaryColor):SingleChildScrollView(

            child: RepaintBoundary(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: isTopAdded,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(color: Provider.of<TextProvider>(context).topCaptionBackClr),
                      child: Row(
                        children: [
                          Flexible(
                              child: TextFormField(
                            maxLines: null,
                            style: TextStyle(
                              color: Provider.of<TextProvider>(context).topCaptionTxtClr,
                              fontSize: 20,
                            ),
                            decoration:InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: "Add your caption here",
                              hintStyle: TextStyle(
                                color:Provider.of<TextProvider>(context).topCaptionTxtClr,
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
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: widget.image,
                              fit: BoxFit.fill),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Opacity(
                            opacity: 0.5,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(color: FontClass.currentColor,borderRadius: BorderRadius.circular(16)),
                              alignment: Alignment.center,
                              width: 80,
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:const [
                                  Flexible(
                                    child:  Text("Generated by\nMemeGen.jpg",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      for (int i = 0; i < dragText.length; i++)
                        dragText[i],
                      for (int i = 0; i < imageWidget.length; i++)
                        imageWidget[i]
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomNavBar());
  }



  Widget bottomNavBar() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        bottomNavigationBarItem(
        icon: const Icon(Icons.text_format),
        label: "Text",callback: (){
          Provider.of<TextProvider>(context, listen: false).addDragText();
        }
      ),
        bottomNavigationBarItem(
        icon: const Icon(Icons.image),
        label: "Image",
          callback: ()async{
            try{
              final img=await FetchTemplate.fetchTemplateFromFile();
              Provider.of<TextProvider>(context, listen: false).addDragImage(img);
              Fluttertoast.showToast(msg: "Long pressed to remove image.");
            }catch(e){
              log(e.toString());
              Fluttertoast.showToast(msg: "Unable to pick image");
            }
          }
      ),

        bottomNavigationBarItem(icon: const Icon(Icons.closed_caption_off_rounded), label: "Top Caption",callback: (){
          final isTopAdded=Provider.of<TextProvider>(context,listen: false).isTopAdded;
          if(!isTopAdded) {
            Fluttertoast.showToast(msg: "Long pressed to change top caption colors");
          }
          Provider.of<TextProvider>(context, listen: false).changeIsTopAdded();
        },
          longPress: (){
          final isTopAdded=Provider.of<TextProvider>(context,listen: false).isTopAdded;
          if(isTopAdded)
            {
              _showPopupMenu((context.findRenderObject() as RenderBox).localToGlobal(Offset.zero));
            }
          }
        ),
        bottomNavigationBarItem(icon: const Icon(Icons.save_alt), label: "Download",callback: ()async{
          try {
            final bytes = await capturePng();
           await showDialog(context: context, builder: (builder){
              String name="Meme ${DateTime.now().toString().substring(0,10)}";
              return StatefulBuilder(builder: (builder,setState){
                return AlertDialog(
                  title: const Text("Generated Meme",),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.memory(bytes!),
                      const SizedBox(height: 10,),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: TextFormField(
                              initialValue: name,
                              onChanged: (value){
                                if(value.isNotEmpty)
                                  {
                                    name=value;
                                  }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  )
                              ),
                            ),)
                          ],
                        ),
                      )
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final path=await ImageGallerySaver.saveImage(bytes,name: name);
                         log(path.toString());
                       Share.shareFiles([path['filePath']],text: "Look I made a meme from M.E.M.E.S app");
                        Navigator.pop(context);
                      },
                      child: const Text("Save in gallery"),
                    )
                  ],
                );
              });
            });

            Fluttertoast.showToast(msg: "Image Saved in the gallery");
          } on Exception catch (_, e) {
            debugPrint(e.toString());
            Fluttertoast.showToast(
                msg: "Unable to save image!!!,try again.");
          }
        })
      ],
    ),
    );
  }
  Widget bottomNavigationBarItem({required Icon icon,required String label,required GestureTapCallback callback,GestureLongPressCallback? longPress}){
    return GestureDetector(
      onTap: callback,
      onLongPress: longPress,
      child: Column(
        children: [
          icon,
          Text(label)
        ],
      ),
    );
  }
  _showPopupMenu(Offset position)async{
   final txtClr=Provider.of<TextProvider>(context,listen: false).topCaptionTxtClr;
   final backClr=Provider.of<TextProvider>(context,listen: false).topCaptionBackClr;
    await showMenu(context: context, position: const RelativeRect.fromLTRB(200,1000,0,0),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        semanticLabel: 'Options',
        items: [
           PopupMenuItem(child: const Text("Change Background Color"),onTap: () async {
             try{
                WidgetsBinding.instance.addPostFrameCallback((_){
                  colorPickerDialog(context,backClr,FontClass.defaultColors,(clr){
                    Provider.of<TextProvider>(context,listen: false).setTopCaptionBackClr=clr;
                  }) ;
                });
             }
             catch(e){
               log(e.toString());
             }
           },
           ),
           PopupMenuItem(child: const Text("Change Text Color"),onTap: () async {
            try{
              WidgetsBinding.instance.addPostFrameCallback((_){
                colorPickerDialog(context,txtClr,FontClass.defaultColors,(clr){
                  Provider.of<TextProvider>(context,listen: false).setTopCaptionTxtClr=clr;
                }) ;
              });
            }
            catch(e){
              log(e.toString());
            }
          },
          )
        ]);
  }

}
colorPickerDialog(context,pickerColor,defaultColors,ValueChanged<Color> onColorChange){
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return StatefulBuilder(
         builder: (context,setState) {
           return AlertDialog(
             title: const Text('Pick a color!'),
             content: SingleChildScrollView(
                 child: BlockPicker(
                   pickerColor:pickerColor,
                   availableColors:defaultColors,
                   onColorChanged: onColorChange,
                 )),
           );
         }
       );
     },
   );

}