import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final q = query.toLowerCase();

    final snap = await db
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: q)
        .orderBy("username")
        .orderBy("displayNameLower")
        .limit(25)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }
}
