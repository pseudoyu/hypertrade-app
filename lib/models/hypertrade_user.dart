class HyperTradeUser {
  final int id;
  final String privyId;
  final DateTime createdAt;

  HyperTradeUser({
    required this.id,
    required this.privyId,
    required this.createdAt,
  });

  factory HyperTradeUser.fromJson(Map<String, dynamic> json) {
    return HyperTradeUser(
      id: json['id'] as int,
      privyId: json['privy_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'privy_id': privyId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'HyperTradeUser{id: $id, privyId: $privyId, createdAt: $createdAt}';
  }
}