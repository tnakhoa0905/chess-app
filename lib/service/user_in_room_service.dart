import 'package:chess_app_flutter/models/room.dart';
import 'package:chess_app_flutter/models/user.dart';
import 'package:chess_app_flutter/service/room_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserInRoomService {
  Future<bool> createUserInRoom(UserInRoomModel userInRoom, String roomName);
  Future<void> updateTurnInUserInRoom(int roomId);
  Future<bool> getTeamInUserInRoom(String userName);
  Future<bool> getTurnInUserInRoom(String userName);
}

class UserInRoomServireImplement extends UserInRoomService {
  Supabase supabase = Supabase.instance;
  final RoomService _roomService = RoomServiceImplement();
  @override
  Future<bool> createUserInRoom(
      UserInRoomModel userInRoom, String roomName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      RoomModel roomCreated = await _roomService.getRoomModel(roomName);
      if (roomCreated.id == -1) {
        roomCreated = await _roomService.createRoomModel(roomName);
      }
      await prefs.setInt('roomId', roomCreated.id);

      List<dynamic> userIsCreated = await supabase.client
          .from("user_in_room")
          .select()
          .eq("user_name", userInRoom.userName)
          .eq("room_id", roomCreated.id);

      if (userIsCreated.length == 1) {
        await prefs.setString('userName', userInRoom.userName);
        return true;
      }
      List<dynamic> result = await supabase.client
          .from("user_in_room")
          .select()
          .eq("room_id", roomCreated.id);
      if (result.length == 2) {
        return false;
      }
      if (result.isEmpty) {
        userInRoom.isRed = true;
        userInRoom.yourTurn = true;
      }

      userInRoom.roomId = roomCreated.id;
      await supabase.client
          .from("user_in_room")
          .insert(userInRoom.toJson())
          .select();
      await prefs.setString('userName', userInRoom.userName);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateTurnInUserInRoom(int roomId) async {
    List<dynamic> listUserInRoom = await supabase.client
        .from("user_in_room")
        .select()
        .eq("room_id", roomId);
    for (var item in listUserInRoom) {
      UserInRoomModel user = UserInRoomModel.fromJson(item);
      user.yourTurn = !user.yourTurn;
      await supabase.client
          .from("user_in_room")
          .update(user.toJson())
          .eq("id", user.id);
    }
  }

  @override
  Future<bool> getTeamInUserInRoom(String userName) async {
    List<dynamic> userIsCreated = await supabase.client
        .from("user_in_room")
        .select()
        .eq("user_name", userName);
    UserInRoomModel userInRoomModel =
        UserInRoomModel.fromJson(userIsCreated[0]);
    return userInRoomModel.isRed!;
  }

  @override
  Future<bool> getTurnInUserInRoom(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int roomId = prefs.getInt("roomId")!;
    List<dynamic> userIsCreated = await supabase.client
        .from("user_in_room")
        .select()
        .eq("user_name", userName)
        .eq("room_id", roomId);
    UserInRoomModel userInRoomModel =
        UserInRoomModel.fromJson(userIsCreated[0]);
    return userInRoomModel.yourTurn;
  }
}
