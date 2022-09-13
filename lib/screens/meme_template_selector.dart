import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_maker/models/template_model.dart';
import 'package:meme_maker/providers/template_provider.dart';
import 'package:meme_maker/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../services/getTemplate.dart';
class TemplateSelectorScreen extends StatefulWidget {
  const TemplateSelectorScreen({Key? key}) : super(key: key);

  @override
  State<TemplateSelectorScreen> createState() => _TemplateSelectorScreenState();
}

class _TemplateSelectorScreenState extends State<TemplateSelectorScreen> {
  final TextEditingController searchController=TextEditingController();
  final List<CustomTemplateModel> customSelection=[
    const CustomTemplateModel("from file", 0),
    const CustomTemplateModel("from url",1),

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }
  initAsync()async {
    try{
      await Provider.of<TemplateProvider>(context,listen:false).setTemplateData();
    }finally{
      Provider.of<TemplateProvider>(context,listen:false).setLoading();
    }


  }
  @override
  Widget build(BuildContext context) {
    bool isLoading=Provider.of<TemplateProvider>(context).loadingStatus;
    List<Memes>? memes=Provider.of<TemplateProvider>(context).getTemplateData;
    bool isSearched=Provider.of<TemplateProvider>(context).getSearchStatus;
    final ImagePicker picker = ImagePicker();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: PopupMenuButton(
        onSelected: (index) async {
          switch(index){
            case 0:{
              try{
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                var bytes=await image!.readAsBytes();
                showDialog(context: context, builder: (builder)  {
                  return customDialog(bytes);
                });
              }catch(e){
                Fluttertoast.showToast(msg: "Something went wrong");
              }
                break;
            }
            case 1:{
              return showDialog(context: context, builder: (builder){
                return AlertDialog(
                  title: const Text("Enter url of the image"),
                  content: Row(
                    children: [
                      Flexible(child: TextFormField(
                        onFieldSubmitted: (value) async {
                          if(value.isNotEmpty && ulrRegx.hasMatch(value.toString()))
                            {

                              try{
                                var bytes=await FetchTemplate.networkImageToBytes(value);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                showDialog(context: context, builder: (builder)  {
                                  return customDialog(bytes);
                                });
                              }catch(e){
                                log(e.toString());
                                Fluttertoast.showToast(msg: "Something wrong with url.");
                              }
                            }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.link),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black,width: 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black,width: 1),
                            borderRadius: BorderRadius.circular(16),
                          )
                        ),
                      ))
                    ],
                  ),
                );
              });
            }
          }
        },
        itemBuilder: (BuildContext context) {
         return [
           for(var i in customSelection)
             PopupMenuItem(
             value: i.value,

           child: Text(i.title,style: const TextStyle(
             fontSize: 20
           ),),
         )];
        },
        child:const CircleAvatar(
            radius: 30,
            backgroundColor:  Color(0XFFE64848),
            child:  Icon(Icons.upload,color: Colors.white,)),

      ),
      body: isLoading?NestedScrollView(
        headerSliverBuilder: (context,innerBoxIsScrolled){
          return [
            SliverAppBar(
              title: Text("Select meme template",style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 20,
              ),),
              floating: false,
              pinned: true,
              scrolledUnderElevation: 0,
            ),
          ];
        }, body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                        controller: searchController,
                        onChanged: (value){
                          if(value.isNotEmpty && value.length>3)
                          {

                            Provider.of<TemplateProvider>(context,listen: false).setSearchStatus=true;
                            Provider.of<TemplateProvider>(context,listen: false).applyFilter(query: searchController.text);
                          }
                        },
                        onFieldSubmitted: (value){
                          if(value.isNotEmpty && value.length>3)
                          {

                            Provider.of<TemplateProvider>(context,listen: false).setSearchStatus=true;
                            Provider.of<TemplateProvider>(context,listen: false).applyFilter(query: searchController.text);
                          }
                        },
                        style: const TextStyle(
                          color:Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search meme template",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.black,width: 0.5),
                              gapPadding: 10
                          ),
                          prefixIcon: const Icon(Icons.search,color: Colors.black,),
                          suffixIcon: Visibility(
                            visible: isSearched,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  searchController.clear();
                                });
                                Provider.of<TemplateProvider>(context,listen: false).setSearchStatus=false;
                                Provider.of<TemplateProvider>(context,listen: false).applyFilter();
                              },
                              child: const Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.black,width: 0.5)
                          ),
                        )
                    ),
                  )
                ],
              ),
            ),
            if(memes!=null && memes.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                  itemCount:memes.length,
                  itemBuilder: (context,index){
                    var item=memes[index];
                    return GestureDetector(
                       onTap: () async {
                         try{
                           var bytes=await FetchTemplate.networkImageToBytes(item.url!);
                           showDialog(context: context, builder: (builder)  {
                             return customDialog(bytes);
                           });
                         }catch(e){
                           log(e.toString());
                           Fluttertoast.showToast(msg: "Something went wrong");
                         }

                       },
                       child: templateWidget(item));
              },
              )
            else
              Column(
                children: [
                  const SizedBox(height: 150,),
                  Image.asset("assets/images/${isSearched?"no_search_found.jpg":"no_template-found.jpg"}"),
                ],
              )
          ],
      ),
        ),
      ):const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
Widget customDialog(bytes){
  return AlertDialog(
    title:const Text("Do you want to select this?"),
    content: Image.memory(bytes),
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
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>MemeEditorScreen(image: MemoryImage(bytes))));
        },
        child:  const Text("Yes",style: TextStyle(
            fontSize: 20
        ),
        ),
      )
    ],
  );
}
  Widget templateWidget(item){
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.url!),
            const SizedBox(height: 10,),
            Text(item.name!,style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),)
          ],
        )
    );
  }
}

class CustomTemplateModel{
  final String title;
  final int value;
  const CustomTemplateModel(this.title, this.value);
}
