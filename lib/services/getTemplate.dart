import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:meme_maker/models/template_model.dart';
class FetchTemplate {
    static var collection=FirebaseFirestore.instance.collection('templates');
  static Future getTemplates() async {
    try{
      final response=await collection.get();
      List<Memes>? docs=[];
      for(var i in response.docs)
        {
          Map<String,dynamic> data =i.data();
          data['id']=i.id;
          docs.add(Memes.fromJson(data));
        }
      return docs;
    }
    catch(e){
      throw Exception(e);
    }
  }

  static Future fetchTemplateFromFile() async {

  }

  static Future fetchTemplateFromUrl(url) async {

  }

  static Future networkImageToBytes(uri) async {
    var response = await http.get(Uri.parse(uri));
    return response.bodyBytes;
  }

  static Future likeTemplate(String templateId,String userId)async{
    await collection.doc(templateId).update({
      'likes':FieldValue.arrayUnion([userId])
    });
  }
    static Future removeTemplateLike(String templateId,String userId)async{
      await collection.doc(templateId).update({
        'likes':FieldValue.arrayRemove([userId])
      });
    }
}