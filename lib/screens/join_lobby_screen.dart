import 'package:flutter/material.dart';

class JoinLobbyScreen extends StatefulWidget {
  const JoinLobbyScreen({super.key});

  @override
  State<JoinLobbyScreen> createState() => _JoinLobbyScreenState();
}

class _JoinLobbyScreenState extends State<JoinLobbyScreen> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Lobby')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nickname'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Lobby code',
                hintText: 'ABCDE',
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final code = _codeController.text.trim().toUpperCase();
                if (name.isEmpty || code.length < 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inserisci nickname e codice valido'),
                    ),
                  );
                  return;
                }
                // TODO: join sul backend
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Join $code come $name (placeholder)'),
                  ),
                );
              },
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
