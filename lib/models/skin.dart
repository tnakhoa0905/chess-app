import 'package:chess_app_flutter/core/chess_type.dart';
import 'package:chess_app_flutter/models/chess.dart';
import 'package:flutter/material.dart';

class ChessSkin {
  double scale = 1;

  double width = 521;
  double height = 577;
  double size = 57;
  Offset offset = const Offset(0, 0);
  Map<ChessType, String> redMap = {
    ChessType.tuong: "rk.png",
    ChessType.quanSi: "ra.png",
    ChessType.quanTuong: "rb.png",
    ChessType.quanPhao: "rc.png",
    ChessType.quanMa: "rn.png",
    ChessType.quanXe: "rr.png",
    ChessType.quanChot: "rp.png",
  };
  Map<ChessType, String> blackMap = {
    ChessType.tuong: "bk.png",
    ChessType.quanSi: "ba.png",
    ChessType.quanTuong: "bb.png",
    ChessType.quanPhao: "bc.png",
    ChessType.quanMa: "bn.png",
    ChessType.quanXe: "br.png",
    ChessType.quanChot: "bp.png",
  };

  String getChessSkin(Chess c) {
    if (c.isUp) return "assets/skins/woods/chess_up.png";
    if (c.chessCode == ChessType.tuong) {
      if (c.isRed) return "assets/skins/woods/${redMap[c.chessCode]}";
      return "assets/skins/woods/${blackMap[c.chessCode]}";
    }
    if (c.isRed) return "assets/skins/woods/${redMap[c.chessCodeUp]}";
    return "assets/skins/woods/${blackMap[c.chessCodeUp]}";
  }

  double getScale(Size size) {
    if (size.width < 521) {
      return (size.width) / 521;
    }
    return 1;
  }
}
