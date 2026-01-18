


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// دالة تحويل الاسم لإيميل وهمي (بطل@miral.com)
String _processEmail(String name) => "${name.trim().replaceAll(' ', '_').toLowerCase()}@miral.com";



// تسجيل جديد
Future<void> register({required String name, required String password})async{
  UserCredential user = await _auth.createUserWithEmailAndPassword(email: _processEmail(name), password: password);
  await _firestore.collection("users").doc(user.user!.uid).set({
    'uId': user.user!.uid,
    'name': name,
  });
  
}
// تسجيل دخول
  Future<void> login({required String name, required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: _processEmail(name),
      password: password,
    );
  }

}