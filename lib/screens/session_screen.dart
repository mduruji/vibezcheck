import 'package:flutter/material.dart';

class SessionScreen extends StatelessWidget {
  static const routeName = '/session';

  final String sessionId;
  final String? sessionName;

  const SessionScreen({
    super.key,
    required this.sessionId,
    this.sessionName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sessionName ?? 'Session'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Session ID (join code): $sessionId\n\n'
            'placeholder'
            'features',
          ),
        ),
      ),
    );
  }
}
