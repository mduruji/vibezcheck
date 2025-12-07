import 'package:flutter/material.dart';
import '../services/search_service.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final controller = TextEditingController();
  final searchService = SearchService();

  List<Map<String, dynamic>> results = [];
  bool loading = false;

  Future<void> runSearch(String text) async {
    setState(() => loading = true);
    results = await searchService.searchUsers(text);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Users")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search username or display name",
              ),
              onChanged: runSearch,
            ),
          ),
          if (loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                final user = results[i];
                return ListTile(
                  title: Text(user["displayName"]),
                  subtitle: Text("@${user["username"]}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
