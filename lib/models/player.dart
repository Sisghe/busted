class Player {
  final String id; // es: uid o codice univoco
  final String nickname;
  final bool isHost;
  final bool isConnected;

  const Player({
    required this.id,
    required this.nickname,
    required this.isHost,
    required this.isConnected,
  });

  Player copyWith({
    String? id,
    String? nickname,
    bool? isHost,
    bool? isConnected,
  }) {
    return Player(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      isHost: isHost ?? this.isHost,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'isHost': isHost,
      'isConnected': isConnected,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as String,
      nickname: map['nickname'] as String,
      isHost: map['isHost'] as bool? ?? false,
      isConnected: map['isConnected'] as bool? ?? true,
    );
  }
}
