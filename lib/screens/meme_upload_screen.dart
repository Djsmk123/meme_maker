// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meme_maker/components/custom_drawer.dart';
import 'package:meme_maker/constant.dart';
import 'package:meme_maker/models/template_model.dart';
import 'package:meme_maker/services/authentication_services.dart';
import 'package:meme_maker/services/getTemplate.dart';
import 'package:provider/provider.dart';

import '../components/custom_app_bar.dart';
import '../providers/template_provider.dart';

class MemeUploadScreen extends StatefulWidget {
  const MemeUploadScreen({Key? key}) : super(key: key);

  @override
  State<MemeUploadScreen> createState() => _MemeUploadScreenState();
}

class _MemeUploadScreenState extends State<MemeUploadScreen> {
  bool isLoading = false;
  String? url;
  String? nameTemplate = "Template";
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  Uint8List? bytes;
  bool imageUpload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const EndDrawer(),
        appBar:customAppBar("Upload meme template"),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : Center(
                child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!imageUpload)
                      Form(
                        key: key,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Template can't be empty";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      nameTemplate = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Template name",
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        )),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: TextFormField(
                                    onFieldSubmitted: (value) async {

                                      url = value;
                                      imageFromNetwork;
                                    },
                                    onChanged: (value) {
                                      url = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty && bytes == null) {
                                        return "Image link or file required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.link),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        hintText: "Enter url of image",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        )),
                                  )),
                                ],
                              ),
                            ),
                             const Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Divider(
                                height: 20,
                                thickness: 5,
                            ),
                             ),
                            const Text(
                              "OR",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                height: 20,
                                thickness: 5,
                              ),
                            ),
                            if(bytes!=null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.memory(bytes!),
                              ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  bytes = await FetchTemplate
                                      .fetchTemplateFromFile();
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong");
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: const Icon(
                                Icons.file_present_rounded,
                                size: 50,
                              ),
                            ),
                            GestureDetector(
                              onTap: !isLoading
                                  ? () async {
                                      if (key.currentState!.validate()) {
                                        if (bytes == null) {
                                          imageFromNetwork;
                                        }
                                        setState(() {
                                          imageUpload = true;
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
                                        "Select",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    : const CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ),
                              ),
                            ),

                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Stack(
                              children: [
                                Image.memory(bytes!),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        bytes == null;
                                        imageUpload = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: kPrimaryColor,
                                      size: 35,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                nameTemplate!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: !isLoading
                                ? () async {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      int templateId = Random()
                                              .nextInt(9999998) +
                                          DateTime.now().millisecondsSinceEpoch;
                                      var decodeImg = await decodeImageFromList(bytes!);
                                      Memes meme = Memes.fromJson({
                                        'height': decodeImg.height,
                                        'width': decodeImg.width,
                                        'likes': [],
                                        'id': templateId.toString(),
                                        'url': base64Encode(bytes!),
                                        'name': nameTemplate!,
                                        'uid': Authentication.user!.uid,
                                        'timeStamp': Timestamp.now(),
                                        'userName':Authentication.userModel!.name!
                                      });
                                      await FetchTemplate.uploadTemplate(
                                          templateId: templateId, tmp: meme);
                                      await Provider.of<TemplateProvider>(context, listen: false).setTemplateData();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Upload successfully");
                                      Navigator.pop(context);
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print(e.toString());
                                      }
                                      Fluttertoast.showToast(
                                          msg: "Something went wrong");
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                      "Upload",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  : const CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              )));
  }

  get imageFromNetwork async {
    if (url!.isNotEmpty && urlRegX.hasMatch(url.toString())) {
      setState(() {
        isLoading = true;
      });
      try {
        bytes = await FetchTemplate.networkImageToBytes(url!);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        Fluttertoast.showToast(msg: "Something wrong with url.");
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
