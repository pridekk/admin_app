import 'package:intl/intl.dart';

DateFormat format = DateFormat("yyyy-MM-dd");

class Pinplay {
  final int id;
  final String name;
  final String roomType;
  String? description;
  final bool isPublic;
  final bool isDeleted;
  final RoomStatus status;
  final String createdAt;
  final String startedAt;
  final String endAt;
  int? masterId;
  int? users = 0;
  List<PinplayUser>? userList = [];
  int comments = 0;
  int? pins;
  final String? openedAt;
  String? password;
  int minParticipants = 0;
  int maxParticipants = 0;

  String get roomStatus  {

    switch (status) {
      case RoomStatus.canceled:
        return "취소";

      case RoomStatus.waiting:
        return "대기중";
        break;
      case RoomStatus.ready:
        return "시작전";
        break;
      case RoomStatus.started:
        return "개임중";
        break;
      case RoomStatus.finished:
        return "개임 종료";
        break;
    }
  }
  Pinplay(
    {
      required this.id,
      required this.name,
      required this.roomType,
      required this.isPublic,
      required this.isDeleted,
      required this.status,
      required this.createdAt,
      required this.startedAt,
      required this.endAt,
      required this.masterId,
      required this.pins,
      this.description,
      this.openedAt,
      this.users = 0,
      this.comments = 0,
      this.userList
    } );

  factory Pinplay.fromJson(Map<String, dynamic> data) {


    final int id = data['id'] as int;
    String name = data['name'] as String;
    String roomType = data['private'] as bool ? "개인방" : "공개방";
    bool isPublic = data['display'] as bool ? true : false;
    bool isDeleted = data['deleted'] as bool ? true : false;

    String roomStatusString = data['state'] as String;

    RoomStatus roomStatus;

    if(roomStatusString == "WAITING_START"){
      roomStatus = RoomStatus.waiting;
    } else if(roomStatusString == "WAITING"){
      roomStatus = RoomStatus.ready;
    } else if(roomStatusString == "IN_GAME"){
      roomStatus = RoomStatus.started;
    } else if(roomStatusString == "FINISHED"){
      roomStatus = RoomStatus.finished;
    } else {
      roomStatus = RoomStatus.canceled;
    }


    String createdAt = format.format(DateTime.parse(data['created_at'] as String));
    String startedAt = format.format(DateTime.parse(data['started_at'] as String));
    String endAt = format.format(DateTime.parse(data['ended_at'] as String));
    int? masterId = data['created_by'] as int?;
    int? pins = data["pins"] as int?;
    int? users = data["users"] as int?;
    String? description = data['description'] as String?;

    var userList = data['user_list'] as Object?;

    if(userList != null){

    }
    return Pinplay(
      id: id,
      name: name,
      roomType: roomType,
      isPublic: isPublic,
      isDeleted: isDeleted,
      status: roomStatus,
      startedAt: startedAt,
      endAt: endAt,
      description: description,
      users: users,
      createdAt: createdAt,
      masterId: masterId,
      pins: pins
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'private': !isPublic,
        'started_at': startedAt,
        'ended_at': endAt,
        'description': description,
        'max_participants': maxParticipants,
        'min_participants': minParticipants,
      };
}

enum RoomStatus { waiting, ready, started, finished, canceled }


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