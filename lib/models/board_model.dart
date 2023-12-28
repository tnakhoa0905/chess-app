import 'package:chess_app_flutter/core/chess_type.dart';
import 'package:chess_app_flutter/models/chess.dart';
import 'package:chess_app_flutter/models/chess_position.dart';
import 'package:chess_app_flutter/service/chess_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardModel {
  static Map<ChessType, List<int>> xPosition = {
    ChessType.quanChot: [0, 2, 4, 6, 8],
    ChessType.tuong: [4],
    ChessType.quanSi: [3, 5],
    ChessType.quanTuong: [2, 6],
    ChessType.quanMa: [1, 7],
    ChessType.quanXe: [0, 8],
    ChessType.quanPhao: [1, 7]
  };

  static Map<ChessType, List<int>> yPosition = {
    ChessType.quanChot: [3, 6],
    ChessType.tuong: [0, 9],
    ChessType.quanSi: [0, 9],
    ChessType.quanTuong: [0, 9],
    ChessType.quanMa: [0, 9],
    ChessType.quanXe: [0, 9],
    ChessType.quanPhao: [2, 7]
  };

  List<ChessPosition> createAllChesses() {
    var reds = viTri(true);
    var blacks = viTri(false);
    return reds + blacks;
  }

  List<ChessPosition> viTri(bool isRed) {
    List<ChessPosition> result = [];
    int indexY = 0;
    if (!isRed) {
      indexY = 1;
    }
    xPosition.forEach((key, value) {
      result.addAll(value.map((e) => ChessPosition(
          x: e, y: yPosition[key]![indexY], chess: createChess(key, isRed))));
    });
    return result;
  }

  Chess createChess(ChessType type, bool isRed) {
    return _createChess(type, type, isRed);
  }

  Chess _createChess(ChessType typeUp, ChessType typeDown, bool isRed) {
    return Chess(
        chessCode: typeDown,
        chessCodeUp: typeUp,
        isUp: typeUp == ChessType.tuong ? false : true,
        isDead: false,
        isRed: isRed);
  }

  void randomlist(int roomId) async {
    ChessServicer chessService = ChessServiceImplement();
    List<ChessPosition> listChessPositionsRandom = createAllChesses();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int roomId = prefs.getInt('roomId')!;
    bool checkListIsEmpty = await chessService.checkListRoom(roomId);
    if (!checkListIsEmpty) {
      return;
    }
    List<ChessPosition> listRandomRed = viTri(true);
    List<ChessPosition> listRandomBlack = viTri(false);
    listRandomRed.shuffle();
    listRandomBlack.shuffle();
    List<ChessPosition> result = listRandomRed + listRandomBlack;
    Chess redKing = listChessPositionsRandom[5].chess;
    Chess blackKing = listChessPositionsRandom[21].chess;
    for (int i = 0; i < result.length; i++) {
      if (result[i].chess.isRed == true &&
          result[i].chess.chessCode == ChessType.tuong) {
        var temp = result[5].chess;
        result[5].chess = redKing;
        result[i].chess = temp;
      }
      if (result[i].chess.isRed == false &&
          result[i].chess.chessCode == ChessType.tuong) {
        var temp = result[21].chess;
        result[21].chess = blackKing;
        result[i].chess = temp;
      }
    }
    for (int i = 0; i < result.length; i++) {
      listChessPositionsRandom[i].chess.roomId = roomId;
      listChessPositionsRandom[i].chess.chessCodeUp =
          result[i].chess.chessCodeUp;
    }
    await chessService.insertListChessToSupabase(listChessPositionsRandom);
  }
}
