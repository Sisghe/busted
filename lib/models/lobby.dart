import 'player.dart';
import 'lobby_config.dart';
import 'tipo_connessione.dart';

enum LobbyState { inAttesa, inGioco, finita }

class Lobby {
  final String id; // es: id interno (uuid)
  final String? codiceStanza; // es: ABCDE (solo per server online)
  final TipoConnessione tipoConnessione;
  final String hostId;
  final LobbyState stato;
  final LobbyConfig config;
  final List<Player> giocatori;

  const Lobby({
    required this.id,
    this.codiceStanza,
    required this.tipoConnessione,
    required this.hostId,
    this.stato = LobbyState.inAttesa,
    this.config = const LobbyConfig(),
    this.giocatori = const [],
  });

  Lobby copyWith({
    String? id,
    String? codiceStanza,
    TipoConnessione? tipoConnessione,
    String? hostId,
    LobbyState? stato,
    LobbyConfig? config,
    List<Player>? giocatori,
  }) {
    return Lobby(
      id: id ?? this.id,
      codiceStanza: codiceStanza ?? this.codiceStanza,
      tipoConnessione: tipoConnessione ?? this.tipoConnessione,
      hostId: hostId ?? this.hostId,
      stato: stato ?? this.stato,
      config: config ?? this.config,
      giocatori: giocatori ?? this.giocatori,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codiceStanza': codiceStanza,
      'tipoConnessione': tipoConnessione.name,
      'hostId': hostId,
      'stato': stato.name,
      'config': config.toMap(),
      'giocatori': giocatori.map((g) => g.toMap()).toList(),
    };
  }

  factory Lobby.fromMap(Map<String, dynamic> map) {
    return Lobby(
      id: map['id'] as String,
      codiceStanza: map['codiceStanza'] as String?,
      tipoConnessione: TipoConnessione.values.firstWhere(
        (t) => t.name == map['tipoConnessione'],
        orElse: () => TipoConnessione.serverOnline,
      ),
      hostId: map['hostId'] as String,
      stato: LobbyState.values.firstWhere(
        (s) => s.name == map['stato'],
        orElse: () => LobbyState.inAttesa,
      ),
      config: LobbyConfig.fromMap(map['config'] as Map<String, dynamic>? ?? {}),
      giocatori: (map['giocatori'] as List<dynamic>? ?? [])
          .map((g) => Player.fromMap(g as Map<String, dynamic>))
          .toList(),
    );
  }
}
