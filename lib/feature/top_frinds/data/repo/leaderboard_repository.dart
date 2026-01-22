import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/model/user_model.dart';


class LeaderboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب أفضل 10 لاعبين
  Future<List<UserModel>> getTopPlayers() async {
    final query = await _firestore
        .collection('users')
        .orderBy('totalStars', descending: true) // الترتيب من الأكبر للأصغر
        .limit(100)
        .get();

    return query.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }
}