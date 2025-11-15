import 'package:flutter/material.dart';
import '../models/tipo_connessione.dart';
import 'lobby_screen.dart';

class CreateLobbyScreen extends StatefulWidget {
  const CreateLobbyScreen({super.key});

  @override
  State<CreateLobbyScreen> createState() => _CreateLobbyScreenState();
}

class _CreateLobbyScreenState extends State<CreateLobbyScreen> {
  final _nomeController = TextEditingController();
  TipoConnessione _tipo = TipoConnessione.wifi;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  String _generaCodiceStanza() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final seed = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 5; i++) {
      code += chars[(seed + i * 17) % chars.length];
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final bool usaCodice = _tipo == TipoConnessione.serverOnline;

    return Scaffold(
      appBar: AppBar(title: const Text('Crea stanza')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nickname'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Scegli il tipo di connessione per la stanza:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            RadioListTile<TipoConnessione>(
              title: const Text('Wi-Fi'),
              value: TipoConnessione.wifi,
              groupValue: _tipo,
              onChanged: (v) => setState(() => _tipo = v!),
            ),
            RadioListTile<TipoConnessione>(
              title: const Text('Bluetooth'),
              value: TipoConnessione.bluetooth,
              groupValue: _tipo,
              onChanged: (v) => setState(() => _tipo = v!),
            ),
            RadioListTile<TipoConnessione>(
              title: const Text('Server online (connessione dati)'),
              subtitle: const Text('Usa un codice stanza di 5 lettere'),
              value: TipoConnessione.serverOnline,
              groupValue: _tipo,
              onChanged: (v) => setState(() => _tipo = v!),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                final nome = _nomeController.text.trim();
                if (nome.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inserisci un nickname')),
                  );
                  return;
                }

                String? codice;
                if (usaCodice) {
                  codice = _generaCodiceStanza();
                }

                // Vai alla schermata Stanza come creatore
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LobbyScreen(
                      nickname: nome,
                      isHost: true,
                      tipoConnessione: _tipo,
                      codiceStanza: codice,
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Crea stanza'),
            ),
          ],
        ),
      ),
    );
  }
}
