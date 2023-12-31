import 'package:chess_app_flutter/models/skin.dart';
import 'package:chess_app_flutter/models/user_in_room.dart';
import 'package:chess_app_flutter/screens/widget/player/list_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 单个玩家框
class PlaySinglePlayer extends StatefulWidget {
  final Alignment placeAt;
  final bool myProfile;

  const PlaySinglePlayer(
      {Key? key, required this.placeAt, required this.myProfile})
      : super(key: key);

  @override
  State<PlaySinglePlayer> createState() => PlaySinglePlayerState();
}

class PlaySinglePlayerState extends State<PlaySinglePlayer> {
  Supabase supabase = Supabase.instance;
  final ChessSkin skin = ChessSkin();
  int roomId = 0;
  String userName = '';
  @override
  void initState() {
    super.initState();
    setRoomId();
  }

  void setRoomId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      roomId = pref.getInt("roomId")!;
      userName = pref.getString("userName")!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double scale = ChessSkin().getScale(size);
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        StreamBuilder<List<UserInRoomModel>>(
            stream: supabase.client
                .from("user_in_room")
                .stream(primaryKey: ["id"])
                .eq("room_id", roomId)
                .map(
                  (maps) =>
                      maps.map((map) => UserInRoomModel.fromJson(map)).toList(),
                ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                if (snapshot.data!.length == 1) {
                  UserInRoomModel userInRoom;
                  if (widget.myProfile) {
                    userInRoom = snapshot.data!.firstWhere(
                      (element) => element.userName.contains(userName),
                    );
                    return SizedBox(
                      width: skin.width * scale,
                      child: ListItem(
                          title: Text(
                            userInRoom.userName,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            "Thinking ...",
                            style: TextStyle(
                                fontSize: 10,
                                color: userInRoom.yourTurn == false
                                    ? Colors.black
                                    : Colors.blue),
                          ),
                          titleAlign: widget.myProfile == false
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  UserInRoomModel userInRoomElse;

                  if (widget.myProfile) {
                    userInRoomElse = snapshot.data!.firstWhere(
                      (element) {
                        return element.userName == userName;
                      },
                    );
                  } else {
                    userInRoomElse = snapshot.data!.firstWhere(
                      (element) => element.userName != userName,
                    );
                  }

                  return SizedBox(
                    width: 521 * scale,
                    child: ListItem(
                        title: Text(
                          userInRoomElse.userName,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          "Thinking ...",
                          style: TextStyle(
                              fontSize: 10,
                              color: userInRoomElse.yourTurn == false
                                  ? Colors.black
                                  : Colors.blue),
                        ),
                        titleAlign: widget.myProfile == false
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end),
                  );
                }
              }
              return Container();
            }),
      ]),
    );
  }
}
