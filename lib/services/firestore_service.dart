import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required List<String> genres,
  }) {
    return _db.collection('users').doc(uid).set(
      {
        'displayName': name,
        'email': email,
        'genres': genres,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<String> createSession({
    required String name,
    required String mood,
    required String hostId,
  }) async {
    final doc = await _db.collection('sessions').add({
      'name': name,
      'mood': mood,
      'hostId': hostId,
      'isActive': true,
      'listenerCount': 1,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id; // join code
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSessionsStream() {
    return _db
        .collection('sessions')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getSessionByCode(
      String code) async {
    final doc = await _db.collection('sessions').doc(code).get();
    if (!doc.exists) return null;
    return doc;
  }
}
