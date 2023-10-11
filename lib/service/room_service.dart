import 'package:chess_app_flutter/models/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RoomService {
  Future<RoomModel> getRoomModel(String name);
  Future<RoomModel> createRoomModel(String name);
}

class RoomServiceImplement extends RoomService {
  final Supabase _supabase = Supabase.instance;
  @override
  Future<RoomModel> createRoomModel(String name) async {
    try {
      List<dynamic> result =
          await _supabase.client.from("room").insert({"name": name}).select();
      return RoomModel.fromJson(result[0]);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<RoomModel> getRoomModel(String name) async {
    try {
      List<dynamic> result =
          await _supabase.client.from("room").select().eq("name", name);
      if (result.isEmpty) {
        return RoomModel(id: -1, name: "khong");
      }
      return RoomModel.fromJson(result[0]);
    } catch (e) {
      throw UnimplementedError();
    }
  }
}
