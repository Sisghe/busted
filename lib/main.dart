import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/create_lobby_screen.dart';
import 'screens/join_lobby_screen.dart';

void main() => runApp(const BustedApp());

class BustedApp extends StatelessWidget {
  const BustedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busted',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/create': (_) => const CreateLobbyScreen(),
        '/join': (_) => const JoinLobbyScreen(),
      },
    );
  }
}
