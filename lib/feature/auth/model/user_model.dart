

class  UserModel {
  final String uId;
  final String name;

  UserModel({required this.uId, required this.name});

  Map<String , dynamic> toMap()=>{
    // بنحول البيانات لـ Map عشان فايربيز بيفهم لغة الـ Map بس

    'uId': uId,
    'name': name,
  };
}