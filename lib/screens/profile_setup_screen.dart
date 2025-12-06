import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firestore_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final nameController = TextEditingController();
  final List<String> genres = [
    'Pop',
    'Hip-Hop',
    'EDM',
    'R&B',
    'Rock',
    'Jazz',
  ];
  final Set<String> selectedGenres = {};
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['initialName'] != null) {
      nameController.text = args['initialName'] as String;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a display name')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await FirestoreService.instance.saveUser(
        uid: user.uid,
        name: name,
        email: user.email ?? '',
        genres: selectedGenres.toList(),
      );

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (_) => false,
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xFF111827),
                child: Icon(
                  Icons.person,
                  size: 38,
                  color: Colors.grey.shade300,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Change avatar'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorite genres',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres.map((g) {
                  final selected = selectedGenres.contains(g);
                  return ChoiceChip(
                    label: Text(g),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          selectedGenres.remove(g);
                        } else {
                          selectedGenres.add(g);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
