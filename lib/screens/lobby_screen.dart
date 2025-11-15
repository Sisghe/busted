import 'package:flutter/material.dart';

import '../models/tipo_connessione.dart';
import '../models/player.dart';
import '../models/lobby_config.dart';
import '../models/lobby.dart';

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
  late final Player _me;
  late Lobby _lobby;

  late final AnimationController _dotController;

  @override
  void initState() {
    super.initState();

    // id "semplice" basato sul tempo: per ora va benissimo
    final myId = DateTime.now().millisecondsSinceEpoch.toString();

    _me = Player(
      id: myId,
      nickname: widget.nickname,
      isHost: widget.isHost,
      isConnected: true,
    );

    _lobby = Lobby(
      id: widget.codiceStanza ?? myId,
      codiceStanza: widget.codiceStanza,
      tipoConnessione: widget.tipoConnessione,
      hostId: widget.isHost ? _me.id : 'host',
      stato: LobbyState.inAttesa,
      config: const LobbyConfig(), // valori di default
      giocatori: [_me],
    );

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

  void _aggiornaConfig(LobbyConfig nuovaConfig) {
    setState(() {
      _lobby = _lobby.copyWith(config: nuovaConfig);
    });
  }

  void _apriImpostazioni() async {
    // copia locale della configurazione attuale
    LobbyConfig tempConfig = _lobby.config;

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
                    value: tempConfig.azioneIA,
                    onChanged: (v) => setModalState(
                      () => tempConfig = tempConfig.copyWith(azioneIA: v),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Azione obbligata su specifico giocatore',
                    ),
                    value: tempConfig.azioneSuGiocatoreSpecifico,
                    onChanged: (v) => setModalState(
                      () => tempConfig = tempConfig.copyWith(
                        azioneSuGiocatoreSpecifico: v,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Azione inviata da un altro giocatore'),
                    value: tempConfig.azioneDaAltroGiocatore,
                    onChanged: (v) => setModalState(
                      () => tempConfig = tempConfig.copyWith(
                        azioneDaAltroGiocatore: v,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: Text(
                      'Azioni per giocatore: ${tempConfig.azioniPerGiocatore}',
                    ),
                  ),
                  Slider(
                    value: tempConfig.azioniPerGiocatore.toDouble(),
                    min: 1,
                    max: 24,
                    divisions: 23,
                    label: tempConfig.azioniPerGiocatore.toString(),
                    onChanged: (v) => setModalState(
                      () => tempConfig = tempConfig.copyWith(
                        azioniPerGiocatore: v.round(),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'BUSTED max per giocatore: ${tempConfig.bustedMaxPerGiocatore}',
                    ),
                  ),
                  Slider(
                    value: tempConfig.bustedMaxPerGiocatore.toDouble(),
                    min: 1,
                    max: 24,
                    divisions: 23,
                    label: tempConfig.bustedMaxPerGiocatore.toString(),
                    onChanged: (v) => setModalState(
                      () => tempConfig = tempConfig.copyWith(
                        bustedMaxPerGiocatore: v.round(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      _aggiornaConfig(tempConfig);
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
    // qui più avanti: cambia stato della lobby + naviga alla schermata di gioco
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partita avviata (placeholder)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCodice =
        _lobby.codiceStanza != null && _lobby.codiceStanza!.isNotEmpty;

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
              children: _lobby.giocatori
                  .map(
                    (player) => Row(
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
                        Text(player.nickname),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),

            // Centro: pulsanti
            if (_me.isHost) ...[
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
                'Codice stanza: ${_lobby.codiceStanza}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
