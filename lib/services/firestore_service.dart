import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  // User profile
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required List<String> genres,
  }) {
    return _db.collection('users').doc(uid).set({
      'displayName': name,
      'email': email,
      'genres': genres,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Sessions
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
    return doc.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSessions() {
    return _db
        .collection('sessions')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getSession(String id) async {
    final doc = await _db.collection('sessions').doc(id).get();
    return doc.exists ? doc : null;
  }
}
