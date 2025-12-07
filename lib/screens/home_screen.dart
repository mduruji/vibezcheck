import 'package:flutter/material.dart';
import 'add_friend_screen.dart';
import 'friends_screen.dart';
import 'chat_screen.dart';
import 'now_playing_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String displayName;

  const HomeScreen({
    super.key,
    required this.username,
    required this.displayName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Tabs
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _homeTab(),
      const ChatScreen(),
      const NowPlayingScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _homeTab() {
    return Center(
      child: Text(
        "@${widget.username}",
        style: const TextStyle(fontSize: 22, color: Colors.white),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFriendScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FriendsScreen()),
              );
            },
          ),
        ],
      ),

      // MAIN CONTENT
      body: _screens[_selectedIndex],

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
