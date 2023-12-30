class UserModel {
  int? id;
  String name;

  UserModel({
    this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": name,
      };
}
