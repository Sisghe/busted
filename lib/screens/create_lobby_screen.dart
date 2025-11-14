import 'package:flutter/material.dart';

enum GameMode { normal, competitive }

enum NetworkMode { online, lan, bluetooth }

enum EndCondition { timer, actionsDone, manual }

class CreateLobbyScreen extends StatefulWidget {
  const CreateLobbyScreen({super.key});

  @override
  State<CreateLobbyScreen> createState() => _CreateLobbyScreenState();
}

class _CreateLobbyScreenState extends State<CreateLobbyScreen> {
  GameMode _mode = GameMode.normal;
  NetworkMode _network = NetworkMode.online;
  EndCondition _end = EndCondition.timer;

  bool _aiAction = false;
  bool _forcedTarget = false;
  bool _playerSent = false;

  int _actionsPerPlayer = 3;
  int _bustedMax = 3;
  int _timerMinutes = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Lobby')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Modalità
          SegmentedButton<GameMode>(
            segments: const [
              ButtonSegment(value: GameMode.normal, label: Text('Normal')),
              ButtonSegment(
                value: GameMode.competitive,
                label: Text('Competitive'),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          const SizedBox(height: 16),

          // Connessione
          DropdownButtonFormField<NetworkMode>(
            value: _network,
            decoration: const InputDecoration(labelText: 'Connessione'),
            items: const [
              DropdownMenuItem(
                value: NetworkMode.online,
                child: Text('Online'),
              ),
              DropdownMenuItem(
                value: NetworkMode.lan,
                child: Text('Wi-Fi locale'),
              ),
              DropdownMenuItem(
                value: NetworkMode.bluetooth,
                child: Text('Bluetooth'),
              ),
            ],
            onChanged: (v) =>
                setState(() => _network = v ?? NetworkMode.online),
          ),
          const Divider(height: 32),

          // Switch
          SwitchListTile(
            title: const Text('Azione generata dall’IA'),
            value: _aiAction,
            onChanged: (v) => setState(() => _aiAction = v),
          ),
          SwitchListTile(
            title: const Text('Azione obbligata su giocatore specifico'),
            value: _forcedTarget,
            onChanged: (v) => setState(() => _forcedTarget = v),
          ),
          SwitchListTile(
            title: const Text('Azione inviata da un altro giocatore'),
            value: _playerSent,
            onChanged: (v) => setState(() => _playerSent = v),
          ),

          // Slider numerici
          ListTile(title: Text('Azioni per giocatore: $_actionsPerPlayer')),
          Slider(
            value: _actionsPerPlayer.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _actionsPerPlayer.toString(),
            onChanged: (v) => setState(() => _actionsPerPlayer = v.round()),
          ),
          ListTile(title: Text('BUSTED max per giocatore: $_bustedMax')),
          Slider(
            value: _bustedMax.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _bustedMax.toString(),
            onChanged: (v) => setState(() => _bustedMax = v.round()),
          ),
          ListTile(title: Text('Timer (minuti): $_timerMinutes')),
          Slider(
            value: _timerMinutes.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: _timerMinutes.toString(),
            onChanged: (v) => setState(() => _timerMinutes = v.round()),
          ),

          // Fine partita
          DropdownButtonFormField<EndCondition>(
            value: _end,
            decoration: const InputDecoration(labelText: 'Fine partita'),
            items: const [
              DropdownMenuItem(value: EndCondition.timer, child: Text('Timer')),
              DropdownMenuItem(
                value: EndCondition.actionsDone,
                child: Text('Azioni finite'),
              ),
              DropdownMenuItem(
                value: EndCondition.manual,
                child: Text('Manuale'),
              ),
            ],
            onChanged: (v) => setState(() => _end = v ?? EndCondition.timer),
          ),

          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // TODO: crea lobby sul backend e naviga
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lobby creata (placeholder)')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
