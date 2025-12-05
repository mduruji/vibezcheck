import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search songs, chats, playlists...",
          prefixIcon: const Icon(Icons.search, color: Color(0xFFB3B3B3)),
          filled: true,
          fillColor: const Color(0xFF181818),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
        ),
      ),
    );
  }
}
