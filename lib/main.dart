import 'package:flutter/material.dart';
import 'screens/create_game_screen.dart';
import 'screens/join_game_screen.dart';

void main() => runApp(const BustedApp());

class BustedApp extends StatelessWidget {
  const BustedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busted',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),

      // 👉 usa `home` al posto di `initialRoute`
      home: const HomeScreen(),

      // tieni le route per la navigazione
      routes: {
        '/create': (_) => const CreateGameScreen(),
        '/join': (_) => const JoinGameScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Busted')),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create'),
              child: const Text('Create Game'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/join'),
              child: const Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}
