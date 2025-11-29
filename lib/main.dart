import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_gate.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_session_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/session_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VibzcheckApp());
}

class VibzcheckApp extends StatelessWidget {
  const VibzcheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFF050816),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF050816),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AuthGate(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profileSetup': (_) => const ProfileSetupScreen(),
        '/home': (_) => const HomeScreen(),
        '/createSession': (_) => const CreateSessionScreen(),
        '/settings': (_) => const SettingsScreen(),
        SessionScreen.routeName: (_) => const SessionScreen(),
      },
    );
  }
}
