class UserModel{
  String? name;
  String?  img;
  UserModel({this.name,this.img});
  UserModel.fromJson(Map<String, dynamic> json){
    name=json.containsKey('name')?json['name']:"User";
    img=json.containsKey('img')?json['img']:null;
  }
  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name']=name;
    data['img']=img;
    return data;
  }
}