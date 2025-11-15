class LobbyConfig {
  final bool azioneIA;
  final bool azioneSuGiocatoreSpecifico;
  final bool azioneDaAltroGiocatore;
  final int azioniPerGiocatore; // 1–24 (default 4)
  final int bustedMaxPerGiocatore; // 1–24 (default 2)

  const LobbyConfig({
    this.azioneIA = false,
    this.azioneSuGiocatoreSpecifico = false,
    this.azioneDaAltroGiocatore = false,
    this.azioniPerGiocatore = 4,
    this.bustedMaxPerGiocatore = 2,
  });

  LobbyConfig copyWith({
    bool? azioneIA,
    bool? azioneSuGiocatoreSpecifico,
    bool? azioneDaAltroGiocatore,
    int? azioniPerGiocatore,
    int? bustedMaxPerGiocatore,
  }) {
    return LobbyConfig(
      azioneIA: azioneIA ?? this.azioneIA,
      azioneSuGiocatoreSpecifico:
          azioneSuGiocatoreSpecifico ?? this.azioneSuGiocatoreSpecifico,
      azioneDaAltroGiocatore:
          azioneDaAltroGiocatore ?? this.azioneDaAltroGiocatore,
      azioniPerGiocatore: azioniPerGiocatore ?? this.azioniPerGiocatore,
      bustedMaxPerGiocatore:
          bustedMaxPerGiocatore ?? this.bustedMaxPerGiocatore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'azioneIA': azioneIA,
      'azioneSuGiocatoreSpecifico': azioneSuGiocatoreSpecifico,
      'azioneDaAltroGiocatore': azioneDaAltroGiocatore,
      'azioniPerGiocatore': azioniPerGiocatore,
      'bustedMaxPerGiocatore': bustedMaxPerGiocatore,
    };
  }

  factory LobbyConfig.fromMap(Map<String, dynamic> map) {
    return LobbyConfig(
      azioneIA: map['azioneIA'] as bool? ?? false,
      azioneSuGiocatoreSpecifico:
          map['azioneSuGiocatoreSpecifico'] as bool? ?? false,
      azioneDaAltroGiocatore: map['azioneDaAltroGiocatore'] as bool? ?? false,
      azioniPerGiocatore: map['azioniPerGiocatore'] as int? ?? 4,
      bustedMaxPerGiocatore: map['bustedMaxPerGiocatore'] as int? ?? 2,
    );
  }
}
