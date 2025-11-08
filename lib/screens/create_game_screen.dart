import 'dart:math';
import 'package:flutter/material.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  late String roomCode;

  @override
  void initState() {
    super.initState();
    roomCode = _generateCode();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(5, (_) => chars[r.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Game')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Share this room code with your friends:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            SelectableText(
              roomCode,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                // TODO: create lobby on backend (e.g., Firebase) and navigate there
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Game created (local demo).')),
                );
              },
              child: const Text('Start Lobby'),
            ),
          ],
        ),
      ),
    );
  }
}
