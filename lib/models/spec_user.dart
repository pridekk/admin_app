class SpecUser {
  int userId;
  String username;
  String nickname;
  String email;
  String image;
  String? promotionDate;

  SpecUser(
      {required this.userId,
      required this.username,
      required this.nickname,
      required this.email,
      required this.image,
      this.promotionDate,
      });

  factory SpecUser.fromJson(Map<String, dynamic> data) {
    int userId = data['user_id'];
    String username = data['username'];
    String nickname = data['nickname'];
    String email = data['email'];
    String image = data['image'];
    String? promotionDate;
    if(data['promotion_registered_at'] != null){
      promotionDate = data['promotion_registered_at'];
      return SpecUser(userId: userId, username: username, nickname: nickname, email: email, image: image, promotionDate: promotionDate);

    }

    return SpecUser(userId: userId, username: username, nickname: nickname, email: email, image: image);
  }
}
