class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final int totalStars; // 👈 ضيف الحقل ده لو مش موجود

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.totalStars = 0, // 👈 خليه يبدأ بصفر
  });

  // 👈 دالة الـ fromMap اللي الـ Repository محتاجها
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      totalStars: map['totalStars']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'totalStars': totalStars,
    };
  }
}