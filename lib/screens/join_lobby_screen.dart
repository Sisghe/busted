import 'package:flutter/material.dart';
import '../models/tipo_connessione.dart';
import 'lobby_screen.dart';

class JoinLobbyScreen extends StatefulWidget {
  const JoinLobbyScreen({super.key});

  @override
  State<JoinLobbyScreen> createState() => _JoinLobbyScreenState();
}

class _JoinLobbyScreenState extends State<JoinLobbyScreen> {
  final _nomeController = TextEditingController();
  final _codiceController = TextEditingController();
  TipoConnessione _tipo = TipoConnessione.wifi; // locale di default

  @override
  void dispose() {
    _nomeController.dispose();
    _codiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool richiedeCodice = _tipo == TipoConnessione.serverOnline;

    return Scaffold(
      appBar: AppBar(title: const Text('Entra in stanza')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nickname'),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tipo di connessione:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),

            RadioListTile<TipoConnessione>(
              title: const Text('Wi-Fi / Bluetooth (locale)'),
              value: TipoConnessione.wifi,
              groupValue: _tipo,
              onChanged: (v) => setState(() => _tipo = v!),
            ),
            RadioListTile<TipoConnessione>(
              title: const Text('Server online (codice stanza)'),
              value: TipoConnessione.serverOnline,
              groupValue: _tipo,
              onChanged: (v) => setState(() => _tipo = v!),
            ),

            if (richiedeCodice) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _codiceController,
                decoration: const InputDecoration(
                  labelText: 'Codice stanza (5 lettere)',
                  hintText: 'ABCDE',
                ),
                maxLength: 5,
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) {
                  final upper = value.toUpperCase();
                  if (upper != value) {
                    _codiceController.value = _codiceController.value.copyWith(
                      text: upper,
                      selection: TextSelection.collapsed(offset: upper.length),
                    );
                  }
                },
              ),
            ],

            const Spacer(),
            FilledButton(
              onPressed: () {
                final nome = _nomeController.text.trim();
                final codice = _codiceController.text.trim();

                if (nome.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inserisci un nickname')),
                  );
                  return;
                }

                if (richiedeCodice && codice.length != 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inserisci un codice di 5 lettere'),
                    ),
                  );
                  return;
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LobbyScreen(
                      nickname: nome,
                      isHost: false,
                      tipoConnessione: _tipo,
                      codiceStanza: richiedeCodice ? codice : null,
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Entra'),
            ),
          ],
        ),
      ),
    );
  }
}
