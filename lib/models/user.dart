class UserInRoomModel {
  int? id;
  int roomId;
  bool yourTurn;
  String userName;
  bool? isRed;

  UserInRoomModel(
      {this.id,
      required this.roomId,
      required this.yourTurn,
      required this.userName,
      this.isRed});

  factory UserInRoomModel.fromJson(Map<String, dynamic> json) =>
      UserInRoomModel(
          id: json["id"],
          roomId: json["room_id"],
          yourTurn: json["your_turn"],
          userName: json["user_name"],
          isRed: json["is_red"]);

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "your_turn": yourTurn,
        "user_name": userName,
        "is_red": isRed
      };
}
