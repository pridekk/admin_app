import 'package:admin_app/models/spec_user.dart';

class PromotionCode {
  PromotionCode({
    required this.id,
    required this.code,
    required this.startedAt,
    required this.expiredAt,
    required this.users,
    required this.enabled,
    required this.userList,
    this.description,
  });

  final int id;
  String code = '';
  String startedAt = '';
  String? expiredAt;
  String? description;
  bool enabled = false;
  List<SpecUser> userList = [];
  final int users;

  factory PromotionCode.fromJson(Map<String, dynamic> data) {
    final int id = data['id'] as int;
    String code = data['code'] as String;
    String startedAt = data['started_at'] as String;
    String? expiredAt = data['expired_at'] as String?;
    String? description = data['description'] as String?;
    bool enabled = data['enabled'] as bool;
    List<SpecUser> userList = [];
    int users = data['users'] as int;
    for (Map<String, dynamic> user in data['user_list']) {
      userList.add(SpecUser.fromJson(user));
    }
    return PromotionCode(
        id: id,
        code: code,
        startedAt: startedAt,
        expiredAt: expiredAt,
        description: description,
        enabled: enabled,
        users: users,
        userList: userList
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'code': code,
        'started_at': startedAt,
        'expired_at': expiredAt,
        'description': description,
        'enabled': enabled,
      };
}
