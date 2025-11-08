import 'package:flutter/material.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Game')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Room code',
                  hintText: 'e.g. ABC12',
                  border: OutlineInputBorder(),
                ),
                maxLength: 5,
                validator: (v) => (v == null || v.trim().length != 5)
                    ? 'Enter 5 characters'
                    : null,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final code = _codeCtrl.text.toUpperCase();
                    // TODO: check lobby exists and navigate there
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Joining $code (demo).')),
                    );
                  }
                },
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
