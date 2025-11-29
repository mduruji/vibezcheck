import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

final Color spotifyGreen = const Color(0xFF1DB954);
final Color spotifyBlack = const Color(0xFF121212);
final Color spotifyDarkGrey = const Color(0xFF181818);
final Color spotifyLightGrey = const Color(0xFFB3B3B3);

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If logged in → HomeScreen
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // If logged out → LoginScreen
        return const LoginScreen();
      },
    );
  }
}
