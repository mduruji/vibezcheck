import 'package:flutter/material.dart';
import '../services/friend_service.dart';
import '../services/user_service.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({super.key});

  final friendService = FriendService();
  final userService = UserService();

  Future<Map<String, dynamic>> getUser(String uid) async {
    final doc = await userService.db.collection("users").doc(uid).get();
    return doc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Friends")),
      body: StreamBuilder<List<String>>(
        stream: friendService.friendStream(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final friendUids = snap.data!;
          if (friendUids.isEmpty) {
            return const Center(child: Text("No friends yet"));
          }

          return ListView.builder(
            itemCount: friendUids.length,
            itemBuilder: (context, index) {
              final uid = friendUids[index];

              return FutureBuilder<Map<String, dynamic>>(
                future: getUser(uid),
                builder: (context, snap2) {
                  if (!snap2.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  final user = snap2.data!;
                  return ListTile(
                    title: Text(user["displayName"]),
                    subtitle: Text("@${user["username"]}"),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
