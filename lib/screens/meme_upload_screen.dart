import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meme_maker/components/custom_drawer.dart';
import 'package:meme_maker/constant.dart';
import 'package:meme_maker/services/getTemplate.dart';

class MemeUploadScreen extends StatefulWidget {
  const MemeUploadScreen({Key? key}) : super(key: key);

  @override
  State<MemeUploadScreen> createState() => _MemeUploadScreenState();
}

class _MemeUploadScreenState extends State<MemeUploadScreen> {
  bool isLoading=false;
  Uint8List? bytes;
  String? name="Template";
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      endDrawer: const EndDrawer(),
      appBar: AppBar(
        title: Text("Upload meme template",style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 20,
        ),
        ),
        actions: [
          Builder(
            builder: (context)=>IconButton(icon: const Icon(Icons.menu),onPressed: (){
              Scaffold.of(context).openEndDrawer();
            },),
          )
        ],
        scrolledUnderElevation: 0,
      ),
      body: isLoading?const Center(child: CircularProgressIndicator(color: kPrimaryColor,),):
      (bytes!=null?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(bytes!),
            Text(name!,style: const TextStyle(color: Colors.red),)
          ],
        ),
      ):Center(child: GestureDetector(
        onTap: (){},
        child: InkWell(
          onTap: () async {

             List? result=await showDialog(context: context, builder: (builder){
               final GlobalKey<FormState> key=GlobalKey<FormState>();

               bool isLoading=false;
               String? nameTemplate;
               Uint8List? bytes1;
               return StatefulBuilder(
                builder: (context,setState) {

                  return !isLoading?AlertDialog(
                    title: const Text("Select image"),
                    content: Form(
                      key: key,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                      child: TextFormField(
                                        validator: (value){
                                          if(value!.isEmpty)
                                          {
                                            return "Template can't be empty";
                                          }
                                          return null;
                                        },
                                        onChanged: (value){
                                          nameTemplate=value;
                                        },
                                        decoration: InputDecoration(
                                            hintText:"Template name",
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Colors.black,width: 1),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            focusedBorder:  OutlineInputBorder(
                                              borderSide: const BorderSide(color: Colors.black,width: 1),
                                              borderRadius: BorderRadius.circular(16),
                                            )
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  Flexible(
                                      child: TextFormField(
                                       onFieldSubmitted: (value) async {
                                        if(value.isNotEmpty && urlRegX.hasMatch(value.toString()))
                                         {setState((){
                                           isLoading=true;
                                         });
                                        try{
                                          bytes1=await FetchTemplate.networkImageToBytes(value);
                                        }catch(e){
                                          log(e.toString());
                                          Fluttertoast.showToast(msg: "Something wrong with url.");
                                        }
                                      }
                                        setState((){
                                          isLoading=false;
                                        });
                                    },
                                        validator: (value){
                                          if(value!.isEmpty && bytes1==null)
                                          {
                                            return "Image link or file required";
                                          }
                                          return null;
                                        },
                                    decoration: InputDecoration(

                                        prefixIcon: const Icon(Icons.link),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.black,width: 1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        hintText:"Enter url of image",
                                        focusedBorder:  OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.black,width: 1),
                                          borderRadius: BorderRadius.circular(16),
                                        )
                                    ),
                                  )),
                                ],
                              ),
                              const Divider(height: 20,thickness: 5,),
                              const Text("OR",style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                              ),
                              ),
                              const Divider(height: 20,thickness: 5,),
                              GestureDetector(onTap: () async {
                                setState((){
                                  isLoading=true;
                                });
                                try{
                                  bytes1=await FetchTemplate.fetchTemplateFromFile();
                                }catch(e){
                                  Fluttertoast.showToast(msg: "Something went wrong");
                                }

                                setState((){
                                  isLoading=false;
                                });
                              },child: const Icon(Icons.file_present_rounded,size: 50,),),
                              if(bytes1!=null)
                                Image.memory(bytes1!)
                            ],
                          ),
                        ),
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Text("No",style: TextStyle(
                            fontSize: 20
                        ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if(key.currentState!.validate())
                            {
                              Navigator.pop(context,[bytes1,nameTemplate]);
                            }

                        },
                        child:  const Text("Yes",style: TextStyle(
                            fontSize: 20
                        ),
                        ),
                      )
                    ],
                  ):const Center(child: CircularProgressIndicator(color: kPrimaryColor,),);
                }
              );
            });
             if(result!=null)
               {
                 bytes=result[0];
                 setState(() {

                 });
               }

          },
          child: Image.asset("assets/images/uploadImg.jpg",scale: 2,),
        ),
      ),))

    );

  }

}
