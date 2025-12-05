import 'package:flutter/material.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> currentSong = {
      "title": "Midnight Waves",
      "artist": "Luna Echo",
      "cover":
          "https://images.pexels.com/photos/164879/pexels-photo-164879.jpeg",
    };

    final List<Map<String, String>> queue = [
      {"title": "Electric Dreams", "artist": "Nova Pulse"},
      {"title": "Afterglow", "artist": "Orion Sky"},
      {"title": "Gravity Shift", "artist": "The Nebulas"},
      {"title": "Golden Hour Drift", "artist": "Solstice"},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Album Cover
          Container(
            height: 260,
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(currentSong["cover"]!),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Song Title
          Text(
            currentSong["title"]!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          // Artist
          Text(
            currentSong["artist"]!,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB3B3B3),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          const Divider(color: Color(0xFF303030)),

          const SizedBox(height: 10),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Up Next",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: queue.length,
              itemBuilder: (context, index) {
                final song = queue[index];
                return ListTile(
                  leading:
                      const Icon(Icons.music_note, color: Colors.white),
                  title: Text(
                    song["title"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    song["artist"]!,
                    style: const TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
