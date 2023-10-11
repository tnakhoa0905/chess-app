import 'package:chess_app_flutter/core/chess_type.dart';
import 'package:chess_app_flutter/models/chess.dart';

class ChessPosition {
  int x;
  int y;
  Chess chess;
  ChessPosition({required this.x, required this.y, required this.chess});

  static ChessType getChessType(String chess) {
    switch (chess) {
      case "tuong":
        return ChessType.tuong;
      case "quanChot":
        return ChessType.quanChot;
      case "quanMa":
        return ChessType.quanMa;
      case "quanPhao":
        return ChessType.quanPhao;
      case "quanSi":
        return ChessType.quanSi;
      case "quanTuong":
        return ChessType.quanTuong;
      case "quanXe":
        return ChessType.quanXe;
      default:
        return ChessType.tuong;
    }
  }

  factory ChessPosition.fromJson(Map<String, dynamic> json) => ChessPosition(
      x: json["x"],
      y: json["y"],
      chess: Chess(
          id: json["id"],
          roomId: json["room_id"],
          chessCode: getChessType(json["chess_code"]),
          chessCodeUp: getChessType(json["chess_code_up"]),
          isUp: json["is_up"],
          isDead: json["is_dead"],
          isRed: json["is_red"]));

  Map<String, dynamic> toJson(ChessPosition chessPosition) => {
        "x": chessPosition.x,
        "y": chessPosition.y,
        "room_id": chessPosition.chess.roomId ?? 12,
        "chess_code": chessPosition.chess.chessCode?.name,
        "chess_code_up": chessPosition.chess.chessCodeUp?.name,
        "is_up": chessPosition.chess.isUp,
        "is_dead": chessPosition.chess.isDead,
        "is_red": chessPosition.chess.isRed,
      };
}
