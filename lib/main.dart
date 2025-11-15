import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/create_lobby_screen.dart';
import 'screens/join_lobby_screen.dart';

void main() => runApp(const BustedApp());

class BustedApp extends StatelessWidget {
  const BustedApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00BCD4), // ciano elegante
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Busted',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050814), // sfondo molto scuro
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black.withOpacity(0.85),
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.04),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/create': (_) => const CreateLobbyScreen(),
        '/join': (_) => const JoinLobbyScreen(),
      },
    );
  }
}
