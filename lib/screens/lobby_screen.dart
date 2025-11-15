import 'package:flutter/material.dart';
import '../models/tipo_connessione.dart';

class LobbyScreen extends StatefulWidget {
  final String nickname;
  final bool isHost;
  final TipoConnessione tipoConnessione;
  final String? codiceStanza;

  const LobbyScreen({
    super.key,
    required this.nickname,
    required this.isHost,
    required this.tipoConnessione,
    this.codiceStanza,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen>
    with SingleTickerProviderStateMixin {
  late final List<String> _giocatori;

  // impostazioni stanza (default)
  bool _azioneIA = false;
  bool _azioneSuGiocatoreSpecifico = false;
  bool _azioneDaAltroGiocatore = false;
  int _azioniPerGiocatore = 4; // 1–24
  int _bustedMaxPerGiocatore = 2; // 1–24

  late final AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _giocatori = [widget.nickname];

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  void _apriImpostazioni() async {
    // Copie locali per il bottom sheet
    bool azIA = _azioneIA;
    bool azSpec = _azioneSuGiocatoreSpecifico;
    bool azAltro = _azioneDaAltroGiocatore;
    int azioni = _azioniPerGiocatore;
    int busted = _bustedMaxPerGiocatore;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Impostazioni stanza',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Azione generata dall’IA'),
                    value: azIA,
                    onChanged: (v) => setModalState(() => azIA = v),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Azione obbligata su specifico giocatore',
                    ),
                    value: azSpec,
                    onChanged: (v) => setModalState(() => azSpec = v),
                  ),
                  SwitchListTile(
                    title: const Text('Azione inviata da un altro giocatore'),
                    value: azAltro,
                    onChanged: (v) => setModalState(() => azAltro = v),
                  ),
                  const SizedBox(height: 8),
                  ListTile(title: Text('Azioni per giocatore: $azioni')),
                  Slider(
                    value: azioni.toDouble(),
                    min: 1,
                    max: 24,
                    divisions: 23,
                    label: azioni.toString(),
                    onChanged: (v) => setModalState(() => azioni = v.round()),
                  ),
                  ListTile(title: Text('BUSTED max per giocatore: $busted')),
                  Slider(
                    value: busted.toDouble(),
                    min: 1,
                    max: 24,
                    divisions: 23,
                    label: busted.toString(),
                    onChanged: (v) => setModalState(() => busted = v.round()),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      // Salvo nei campi "veri" della Lobby
                      setState(() {
                        _azioneIA = azIA;
                        _azioneSuGiocatoreSpecifico = azSpec;
                        _azioneDaAltroGiocatore = azAltro;
                        _azioniPerGiocatore = azioni;
                        _bustedMaxPerGiocatore = busted;
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Salva impostazioni'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _avviaPartita() {
    // In futuro: naviga alla schermata di gioco
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partita avviata (placeholder)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCodice =
        widget.codiceStanza != null && widget.codiceStanza!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Stanza Busted')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Giocatori in alto a sinistra
            Text('Giocatori:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _giocatori
                  .map(
                    (nome) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _dotController,
                          builder: (context, child) {
                            final opacity =
                                0.4 + 0.6 * _dotController.value; // 0.4–1.0
                            return Opacity(opacity: opacity, child: child);
                          },
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(nome),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),

            // Centro: pulsanti
            if (widget.isHost) ...[
              Row(
                children: [
                  FilledButton(
                    onPressed: _apriImpostazioni,
                    child: const Text('Impostazioni'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.tonal(
                    onPressed: _avviaPartita,
                    child: const Text('Start'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Se avvii la partita senza aprire le impostazioni,\n'
                'verranno usati i valori di default.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else ...[
              const Text(
                'In attesa che il creatore della stanza avvii la partita...',
              ),
            ],

            const Spacer(),

            // Codice stanza (solo se esiste)
            if (hasCodice)
              Text(
                'Codice stanza: ${widget.codiceStanza}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
