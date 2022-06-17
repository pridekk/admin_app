class PinProfit {
  PinProfit(
      {required this.pinId,
      required this.playId,
      required this.userId,
      required this.pinStatus,
      required this.marketCode,
      required this.direction,
      required this.initialPrice,
      required this.initializedAt,
      required this.name,
      required this.profit,
      this.releasePrice,
      this.releasedAt});

  int pinId;
  int playId;
  int userId;
  String pinStatus;
  String marketCode;
  String direction;
  int initialPrice;
  int? releasePrice;
  DateTime initializedAt;
  DateTime? releasedAt;
  String name;
  double profit;

  factory PinProfit.fromJson(Map<String, dynamic> data) {
    int pinId = data['pin_id'];
    int playId = data['play_id'];
    int userId = data['user_id'];
    String pinStatus = data['pin_status'];
    String marketCode = data['market_code'];
    String direction = data['direction'];
    int initialPrice = data['initial_price'];
    int? releasePrice = data['release_price'] as int?;
    DateTime initializedAt = DateTime.parse(data['initialized_at']);
    DateTime? releasedAt = data['released_at'] != null ? DateTime.parse(data['released_at']) : null ;
    String name = data['name'];
    double profit = data['profit'];

    return PinProfit(
        pinId: pinId,
        playId: playId,
        userId: userId,
        pinStatus: pinStatus,
        marketCode: marketCode,
        direction: direction,
        initialPrice: initialPrice,
        initializedAt: initializedAt,
        name: name,
        profit: profit,
        releasePrice: releasePrice,
        releasedAt: releasedAt
    );


  }
}
