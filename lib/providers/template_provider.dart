import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meme_maker/models/template_model.dart';

import '../services/getTemplate.dart';

class TemplateProvider extends ChangeNotifier{
  bool isLoading=false;
  get loadingStatus=>isLoading;
  List<Memes>? templateData;
  List<Memes> result=[];
  bool isSearched=false;
  get getSearchStatus=> isSearched;
  set setSearchStatus(value){
    isSearched=value;
    notifyListeners();
  }
  get getTemplateData=> result;
   setLoading(){
    isLoading=!isLoading;
    notifyListeners();
  }
    setTemplateData()async{
     TemplateData tmpData=await FetchTemplate.getTemplateFromImgFlip();
     templateData=tmpData.data!.memes!;
     applyFilter();
  }
   applyFilter({String? query})async{
     result.clear();
     try{
       if(query!=null)
       {
         for (var element in templateData!) {
           if(element.name!.toLowerCase().contains(query.toLowerCase()))
             {
               result.add(element);

             }
         }
       }
       else{
         result.addAll(templateData!);
       }
     }catch(e){
       log(e.toString());
     }
     notifyListeners();

  }


}