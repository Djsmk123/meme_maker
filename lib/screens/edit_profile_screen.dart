// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_maker/constant.dart';
import 'package:meme_maker/models/user_model.dart';
import 'package:meme_maker/services/authentication_services.dart';
import 'package:meme_maker/services/getTemplate.dart';

import '../components/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading=true;
  final GlobalKey<FormState> globalKey=GlobalKey<FormState>();
  bool readOnly=true;
  String? name;
  String? bytes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name=Authentication.userModel!.name;
    bytes=Authentication.userModel!.img;
    isLoading=false;
    setState(() {

    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:customAppBar("Edit profile"),
      body: Center(
        child: !isLoading?Form(
          key:globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 100,
                    backgroundColor: kPrimaryColor,
                    backgroundImage:(bytes!=null)?MemoryImage(base64Decode(bytes!)):const AssetImage("assets/images/default_img.png") as ImageProvider,

                  ),
                    Positioned(
                     right: 5,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(context: context, builder: (builder){
                         return BottomSheet(
                             onClosing: (){}, builder: (builder){
                           return Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               filePickingOptions(title: "Camera",fromFile: false),
                               filePickingOptions(title: "Gallery"),

                             ],
                           );
                         });
                        });
                        setState((){});
                      },
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.camera_alt,color: Colors.white,size: 30,),
                      ),
                    )
                  ),

                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty && value.length<4)
                            {
                              return "Minimum length of name should be greater than 3.";
                            }
                          return null;
                        },
                        onChanged: (value){
                          if(value.isNotEmpty && value.length>3)
                            {
                              name=value;
                            }

                        },
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 50,
                          fontFamily: GoogleFonts.dancingScript().fontFamily,
                        ),
                        readOnly: readOnly,
                        initialValue: name.toString(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          focusedBorder:!readOnly?OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16)
                          ):InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              readOnly=!readOnly;
                            });
                          }, icon: Icon(readOnly?Icons.edit:Icons.clear,),)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: !isLoading
                    ? () async {
                  if(globalKey.currentState!.validate())
                    {
                      try{
                        isLoading=true;
                        setState(() {

                        });
                        await Authentication.updateProfile(UserModel.fromJson({
                          'name':name,
                          'img':bytes,
                        }));
                        showToast(msg:"Updated");
                      }catch(e){
                        showToast();
                        log(e.toString());
                      }
                      isLoading=false;
                      setState(() {
                        readOnly=true;
                      });
                    }
                }
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: !isLoading
                      ? const Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.white, fontSize: 20),
                  )
                      : const CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
              )
            ],
          ),
        ):const CircularProgressIndicator(color: kPrimaryColor,),
      ),
    );
  }
  Widget filePickingOptions({bool fromFile=true,required String title}){
   return GestureDetector(
      onTap:() async {
        try{
          var img=base64Encode(await FetchTemplate.fetchTemplateFromFile(source: fromFile?ImageSource.gallery:ImageSource.camera)).toString();
          setState(() {
            bytes=img;
          });
          Navigator.pop(context);
        }catch(e){
          log(e.toString());
        }
      },
      child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        child: Text("Pick Image from $title",style: const TextStyle(
            color: Colors.black,
            fontSize: 20
        ),),
      ),
    );
  }
}
