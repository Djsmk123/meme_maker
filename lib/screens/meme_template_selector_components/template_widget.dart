import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constant.dart';
import '../../models/template_model.dart';
import '../../services/authencation_service.dart';
import '../../services/getTemplate.dart';

class TemplateWidget extends StatefulWidget {
  final Memes item;
  const TemplateWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<TemplateWidget> createState() => _TemplateWidgetState();
}

class _TemplateWidgetState extends State<TemplateWidget> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    var item=widget.item;
     User? user=Authentication.user;
    var likes=item.likes!;
    var image=base64Decode(item.url!);
    String time=timeFormat(item.timeStamp!.toDate());
    bool isLiked=isLikedByUser(user,likes);

    return !isLoading?Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.memory(image,isAntiAlias: true)),
            const SizedBox(height: 10,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name!,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),),
                    SizedBox(
                      width: 50,
                      child: ListTile(
                          onTap: () async {
                            if(user!=null)
                            {
                              if(!isLiked)
                              {
                                setState(() {
                                  isLoading=true;
                                });
                                try{
                                  await FetchTemplate.likeTemplate(item.id!, user.uid);
                                  likes.add(user.uid);
                                  isLiked=true;
                                }catch(e){
                                  log(e.toString());
                                  Fluttertoast.showToast(msg: "Something went wrong");
                                }
                                setState(() {
                                  isLoading=false;
                                });
                              }
                              else{

                                setState(() {
                                  isLoading=true;
                                });
                                try{
                                  await FetchTemplate.removeTemplateLike(item.id!, user.uid);
                                  likes.remove(user.uid);
                                  isLiked=false;
                                }catch(e){
                                  log(e.toString());
                                  Fluttertoast.showToast(msg: "Something went wrong");
                                }
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            }
                            else{
                              Fluttertoast.showToast(msg: "Sign in required");
                            }
                          },
                          title: Text(likes.length.toString()),
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: Icon(!isLiked?Icons.favorite_border:Icons.favorite,color: isLiked?Colors.red:Colors.black,)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("upload by SmkWinner",
                      maxLines: 2,
                      style:  TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),),
                    SizedBox(
                      width: 100,
                      child:ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: const Icon(Icons.add,color: Colors.white,),
                          title: Text('${time}ago',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12
                          ),)),
                    )
                  ],
                ),
                if(user!=null || user!.uid==item.uid)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title:const Text("Do you want to delete this template?",style: TextStyle(
                                color: Colors.black,
                                fontSize: 24
                              ),
                              ),
                              content: Image.memory(image,),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child:const Text("No",style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24
                                  ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child:const Text("Yes",style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24
                                  ),
                                  ),
                                )
                              ],
                            );
                          });
                        },
                        child: const Icon(Icons.delete,color: kPrimaryColor,),
                      )
                    ],
                  )
              ],
            )
          ],
        )
    ):const Center(child: CircularProgressIndicator(color: kPrimaryColor,),);
  }
  String timeFormat(DateTime time){
    final dtNow=DateTime.now();
    var diff=dtNow.difference(time);
    if(diff.inDays>0)
    {
      return '${diff.inDays}\tdays\t';
    }
    else if(diff.inHours>0)
    {
      return '${diff.inHours}\thr\t';
    }
    else if(diff.inMinutes>0)
    {
      return '${diff.inMinutes}\tmin\t';
    }

    return'${diff.inSeconds}\tsec\t';

  }

  bool isLikedByUser(User? user,List likes){
    if(user!=null)
    {
      for(var i in likes) {
        if (i==user.uid)
        {
          return true;
        }
      }
    }
    return false;
  }
}


