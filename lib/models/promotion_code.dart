class PromotionCode {
  PromotionCode({required this.id, required this.code, required this.startedAt, required this.expiredAt, required this.users, required this.enabled, this.description,});

  final int id;
  String code = '';
  String startedAt = '';
  String? expiredAt;
  String? description;
  bool enabled = false;
  int users = 0;

  factory PromotionCode.fromJson(Map<String, dynamic> data) {
    final int id = data['id'] as int;
    String code = data['code'] as String;
    String startedAt = data['started_at'] as String;
    String? expiredAt = data['expired_at'] as String?;
    String? description = data['description'] as String?;
    bool enabled = data['enabled'] as bool;
    int users = data['users'] as int;
    return PromotionCode(id: id, code: code, startedAt: startedAt, expiredAt: expiredAt, description: description, enabled: enabled, users: users );
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'code': code,
        'started_at': startedAt,
        'expired_at': expiredAt,
        'description': description,
        'enabled': enabled,
        'users': users,
      };
}