import 'package:chess_app_flutter/core/chess_type.dart';

class Chess {
  int? id;
  int? roomId;
  ChessType? chessCode;
  ChessType? chessCodeUp;

  bool isUp;
  bool isDead;
  bool isRed;

  Chess(
      {this.id,
      this.roomId,
      this.chessCode,
      this.chessCodeUp,
      required this.isUp,
      required this.isDead,
      required this.isRed});
}
