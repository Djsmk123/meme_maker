import 'package:cloud_firestore/cloud_firestore.dart';
class Memes {
  String? id;
  String? name;
  String? url;
  int? width;
  int? height;
  Timestamp? timeStamp;
  String? uid;
  List<dynamic>? likes;
  String? userName;
  Memes({this.name, this.url, this.width, this.height, this.likes, this.id,this.uid,this.timeStamp,this.userName});

  Memes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    likes = json.containsKey('likes') ? json['likes'] : [];
    url = json['url'];
    width = json['width'];
    id = json['id'];
    height = json['height'];
    timeStamp =
        json.containsKey('timeStamp') ? json['timeStamp'] : Timestamp.now;
    uid =
        json.containsKey('uid') ? json['uid'] : "m74rafnFXddXD5iJt4VEJqEGPR03";
    userName = json.containsKey('userName') ? json['userName'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    data['timeStamp'] = timeStamp;
    data['uid'] = uid;
    data['likes'] = likes;
    data['id'] = id;
    data['userName']=userName;
    return data;
  }
}

class CustomTemplateModel {
  final String title;
  final int value;
  const CustomTemplateModel(this.title, this.value);
}
