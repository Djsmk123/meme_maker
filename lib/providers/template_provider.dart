
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
  int sortingIndex=0;
  get getSortingIndex=>sortingIndex;
  set setSortingIndex(int index){
    sortingIndex=index;
    notifyListeners();
  }
  get getTemplateData=> result;
   setLoading(){
    isLoading=!isLoading;
    notifyListeners();
  }
    setTemplateData()async{
     List<Memes> tmpData=await FetchTemplate.getTemplates();
     templateData=tmpData;
     applyFilter();
  }
   applyFilter({bool byTime=false,String? uid}){
     result.clear();
     result.addAll(templateData!);
     if(byTime)
       {
          result.sort((a,b)=>b.timeStamp!.compareTo(a.timeStamp!));
          notifyListeners();
          return;
       }
     if(uid!=null)
       {
         for(var elements in templateData!)
           {
             if(elements.uid!=uid) {
               result.remove(elements);
             }
           }
         notifyListeners();
         return;
       }

     result.sort((a,b)=>b.likes!.length.compareTo(a.likes!.length));
     notifyListeners();
     return;



  }
   search({required String query}){
     result.clear();
     result.addAll(templateData!);
    {
      for (var element in templateData!) {
        if(!element.name!.toLowerCase().contains(query.toLowerCase()))
        {
          result.remove(element);
        }
      }
    }
    notifyListeners();
  }


}