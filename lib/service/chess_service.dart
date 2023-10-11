import 'package:chess_app_flutter/models/chess_position.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChessServicer {
  List<ChessPosition> randomListChess(List<ChessPosition> list);

  Future<void> insertListChessToSupabase(List<ChessPosition> list);

  Future<bool> checkListRoom(int roomId);

  Future<void> updateChess(ChessPosition chessPosition);

  Future<void> deleteAllChess(int roomId);
}

class ChessServiceImplement extends ChessServicer {
  final Supabase _supabase = Supabase.instance;
  @override
  List<ChessPosition> randomListChess(List<ChessPosition> list) {
    List<ChessPosition> listResult = list;
    listResult.shuffle();
    print(listResult);
    return listResult;
  }

  @override
  Future<void> insertListChessToSupabase(List<ChessPosition> list) async {
    for (var item in list) {
      await _supabase.client.from("chess_in_room").insert(item.toJson(item));
    }
  }

  @override
  Future<bool> checkListRoom(int roomId) async {
    List<dynamic> result = await _supabase.client
        .from("chess_in_room")
        .select()
        .eq("room_id", roomId);
    if (result.isEmpty) return true;
    return false;
  }

  @override
  Future<void> updateChess(ChessPosition chessPosition) async {
    await _supabase.client
        .from("chess_in_room")
        .update(chessPosition.toJson(chessPosition))
        .eq("id", chessPosition.chess.id);
  }

  @override
  Future<void> deleteAllChess(int roomId) async {
    await _supabase.client.from("chess_in_room").delete().eq("room_id", roomId);
  }
}
