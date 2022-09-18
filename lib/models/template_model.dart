import 'package:cloud_firestore/cloud_firestore.dart';

class TemplateData {
  bool? success;
  Data? data;

  TemplateData({this.success, this.data});

  TemplateData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

}

class Data {
  List<Memes>? memes;

  Data({this.memes});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['memes'] != null) {
      memes = <Memes>[];
      json['memes'].forEach((v) {
        memes!.add(Memes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (memes != null) {
      data['memes'] = memes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Memes {
  String? id;
  String? name;
  String? url;
  int? width;
  int? height;
  int? likeCount;
  Timestamp? timeStamp;
  String? uid;
  List<dynamic>? likes;


  Memes({this.name, this.url, this.width, this.height,this.likes,this.id});

  Memes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    likes=json.containsKey('likes')?json['likes']:[];
    url = json['url'];
    width = json['width'];
    id=json['id'];
    height = json['height'];
    likeCount=json.containsKey('likeCount')?json['likeCount']:0;
    timeStamp=json.containsKey('timeStamp')?json['timeStamp']:Timestamp.now;
    uid=json.containsKey('uid')?json['uid']:"m74rafnFXddXD5iJt4VEJqEGPR03";

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    data['likeCount']=likeCount??0;
    data['timeStamp']=timeStamp;
    data['uid']=uid;
    data['likes']=likes;
    data['id']=id;
    return data;
  }
}

class CustomTemplateModel{
  final String title;
  final int value;
  const CustomTemplateModel(this.title, this.value);
}
