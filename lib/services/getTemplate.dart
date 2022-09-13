import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meme_maker/models/template_model.dart';
class FetchTemplate {
  static Future getTemplateFromImgFlip() async {
    try {
      final response = await http.get(
          Uri.parse("https://api.imgflip.com/get_memes"));
      var jsonData = jsonDecode(response.body);
      return TemplateData.fromJson(jsonData);
    } catch (e) {
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
}