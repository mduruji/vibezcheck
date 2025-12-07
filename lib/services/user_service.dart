import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<String?> getUidFromUsername(String username) async {
    final q = await db
        .collection("users")
        .where("username", isEqualTo: username.toLowerCase())
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;
    return q.docs.first.id;
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await db.collection("users").doc(uid).get();
    return doc.data();
  }
}
