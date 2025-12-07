import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> addFriend(String friendUid) async {
    final uid = auth.currentUser!.uid;

    await db
        .collection("friends")
        .doc(uid)
        .collection("list")
        .doc(friendUid)
        .set({"addedAt": FieldValue.serverTimestamp()});

    await db
        .collection("friends")
        .doc(friendUid)
        .collection("list")
        .doc(uid)
        .set({"addedAt": FieldValue.serverTimestamp()});
  }

  Stream<List<String>> friendStream() {
    final uid = auth.currentUser!.uid;

    return db
        .collection("friends")
        .doc(uid)
        .collection("list")
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.id).toList());
  }
}
