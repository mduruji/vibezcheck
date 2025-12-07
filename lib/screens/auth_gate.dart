import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If the user is NOT logged in → show login
        if (!authSnap.hasData) {
          return const LoginScreen();
        }

        final uid = authSnap.data!.uid;

        // Load the user's Firestore profile
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!userSnap.hasData || !userSnap.data!.exists) {
              // Something is wrong — profile missing
              return const LoginScreen();
            }

            final data = userSnap.data!.data() as Map<String, dynamic>;

            return HomeScreen(
              username: data["username"],
              displayName: data["displayName"],
            );
          },
        );
      },
    );
  }
}
