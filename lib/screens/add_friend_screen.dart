import 'package:flutter/material.dart';
import '../services/search_service.dart';
import '../services/friend_service.dart';
import '../services/user_service.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final controller = TextEditingController();
  final searchService = SearchService();
  final friendService = FriendService();
  final userService = UserService();

  Map<String, dynamic>? userData;
  String? userUid;
  bool loading = false;

  Future<void> runSearch() async {
    setState(() {
      loading = true;
      userData = null;
      userUid = null;
    });

    final results = await searchService.searchUsers(controller.text.trim());
    if (results.isNotEmpty) {
      userData = results.first;

      final q = controller.text.trim().toLowerCase();

      final snap = await userService.db
          .collection("users")
          .where("username", isGreaterThanOrEqualTo: q)
          .orderBy("username")
          .orderBy("displayNameLower")
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        userUid = snap.docs.first.id;
      }
    }

    setState(() => loading = false);
  }

  Future<void> addFriend() async {
    if (userUid != null) {
      await friendService.addFriend(userUid!);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Friend added")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Friend")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search username or display name",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: runSearch,
              child: const Text("Search"),
            ),
            const SizedBox(height: 30),
            if (loading) const CircularProgressIndicator(),
            if (!loading && userData == null)
              const Text("No user found"),
            if (userData != null)
              Column(
                children: [
                  Text(
                    userData!["displayName"],
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text("@${userData!["username"]}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addFriend,
                    child: const Text("Add Friend"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
