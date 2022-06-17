class PinplayUser{
  PinplayUser({
    required this.userId,
    required this.profit,
    required this.pinWithinPeriod,
    required this.joinedAt
  });

  int userId;
  double profit;
  int pinWithinPeriod;
  DateTime joinedAt;

  factory PinplayUser.fromJson(Map<String, dynamic> data) {
    int userId = data["user_id"];
    double profit = data["profit"];
    int pinWithinPeriod = data["pin_within_period"];
    DateTime joinedAt = DateTime.parse(data["joined_at"] as String);
    return PinplayUser(userId: userId, profit: profit, pinWithinPeriod: pinWithinPeriod, joinedAt: joinedAt);
  }
}