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
  int? boxCount;

  Memes({this.id, this.name, this.url, this.width, this.height, this.boxCount});

  Memes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
    boxCount = json['box_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    data['box_count'] = boxCount;
    return data;
  }
}
