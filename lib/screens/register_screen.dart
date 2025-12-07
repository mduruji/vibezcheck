import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();
  bool loading = false;

  bool isValidUsername(String username) {
    final regex = RegExp(r'^(?!.*\.\.)(?!\.)(?!.*\.$)[a-zA-Z0-9._]{1,30}$');
    return regex.hasMatch(username);
  }

  bool isValidDisplayName(String name) {
    if (name.trim().isEmpty) return false;
    if (name.trim().length > 50) return false;
    return true;
  }

  Future<bool> usernameExists(String username) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> register() async {
    final username = usernameController.text.trim().toLowerCase();
    final displayName = displayNameController.text.trim();

    if (!isValidUsername(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username.")),
      );
      return;
    }

    if (!isValidDisplayName(displayName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid display name.")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      if (await usernameExists(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username already taken.")),
        );
        setState(() => loading = false);
        return;
      }

      UserCredential userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pwController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        "username": username,
        "displayName": displayName,
        "email": emailController.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please log in.")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration error")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create your account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(hintText: "Display Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(hintText: "Username"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(height: 24),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Already have an account? Log in",
                style: TextStyle(color: Color(0xFF1DB954)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
