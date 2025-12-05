import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        "name": "Friday Night Party",
        "lastMsg": "Ayeee the vibe is unmatched 😎",
      },
      {
        "name": "Gym Playlist Crew",
        "lastMsg": "Check this new Travis joint!",
      },
      {
        "name": "Study Session",
        "lastMsg": "lofi beats for the win 🧠",
      },
      {
        "name": "Roadtrip Mix",
        "lastMsg": "Add Bad Bunny next!",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          title: Text(
            chat["name"]!,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          subtitle: Text(
            chat["lastMsg"]!,
            style: const TextStyle(color: Color(0xFFB3B3B3)),
          ),
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF1DB954),
            child: Icon(Icons.chat, color: Colors.black),
          ),
          onTap: () {
            // Later you can navigate to a specific chat room
          },
        );
      },
    );
  }
}
