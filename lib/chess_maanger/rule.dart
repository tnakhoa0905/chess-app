import 'package:chess_app_flutter/core/chess_type.dart';
import 'package:chess_app_flutter/models/chess.dart';
import 'package:chess_app_flutter/models/chess_position.dart';
import 'package:chess_app_flutter/models/pos.dart';

class ChessRule {
  List<ChessPositionModel> movePoints(
      ChessPosition activePos, List<ChessPosition> listChessPosition) {
    ChessType code;
    if (activePos.chess.isUp || activePos.chess.chessCode == ChessType.tuong) {
      code = activePos.chess.chessCode!;
    } else {
      code = activePos.chess.chessCodeUp!;
    }

    switch (code) {
      case ChessType.quanXe:
        return _moveXe(code, activePos, listChessPosition);
      case ChessType.quanChot:
        return _moveChot(code, activePos, listChessPosition);
      case ChessType.quanPhao:
        return _movePhao(code, activePos, listChessPosition);
      case ChessType.quanMa:
        return _moveMa(code, activePos, listChessPosition);
      case ChessType.quanTuong:
        return _moveTuong(code, activePos, listChessPosition);
      case ChessType.quanSi:
        return _moveSi(code, activePos, listChessPosition);
      case ChessType.tuong:
        return moveKing(code, activePos, listChessPosition);
      default:
        return [];
    }
  }

  ChessPosition getChessPosition(List<ChessPosition> listChessPosition,
      ChessPositionModel chessPositionModel) {
    return listChessPosition.firstWhere(
        (item) =>
            item.x == chessPositionModel.x &&
            item.y == chessPositionModel.y &&
            item.chess.isDead == false,
        orElse: () => ChessPosition(
            x: -1, y: -1, chess: Chess(isUp: true, isDead: true, isRed: true)));
  }

  bool checkCanMove(ChessPositionModel chessPositionModel,
      List<ChessPosition> list, ChessPosition chessPosition) {
    bool result = true;
    ChessPosition? newItem = list.firstWhere(
      (item) {
        return (item.x == chessPositionModel.x &&
            item.y == chessPositionModel.y &&
            item.chess.isDead == false);
      },
      orElse: () => ChessPosition(
          x: -1, y: -1, chess: Chess(isUp: true, isDead: true, isRed: true)),
    );

    print(newItem.chess.chessCodeUp);
    if (newItem.chess.chessCode != null) {
      return true;
    }
    if (newItem.x == -1) {
      result = false;
    }
    if (chessPosition.chess.isRed != newItem.chess.isRed) {
      result = false;
    }

    return result;
  }

  List<ChessPositionModel> _moveXe(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];
    for (var step in [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ]) {
      ChessPositionModel movePoint = ChessPositionModel(
        x: activePos.x + step[0],
        y: activePos.y + step[1],
      );
      while (movePoint.x >= 0 &&
          movePoint.x <= 8 &&
          movePoint.y >= 0 &&
          movePoint.y <= 9) {
        ChessPositionModel newChess = ChessPositionModel(
          x: movePoint.x,
          y: movePoint.y,
        );
        if (checkCanMove(newChess, listChessPosition, activePos)) {
          break;
        }
        points.add(newChess);
        ChessPosition current = getChessPosition(listChessPosition, newChess);
        if (!current.chess.isDead) {
          break;
        }

        movePoint.x += step[0];
        movePoint.y += step[1];
      }
    }
    return points;
  }

  List<ChessPositionModel> _moveChot(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];
    for (var m in [
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ]) {
      if (activePos.chess.isRed) {
        // Không thể di chuyển lùi
        if (m[1] < 0) {
          continue;
        }
        // Không thể đi ngang khi chưa qua sông.
        if (activePos.y < 5 && m[0] != 0) {
          continue;
        }
      } else {
        // Không thể di chuyển lùi
        if (m[1] > 0) {
          continue;
        }
        // Không thể đi ngang khi chưa qua sông.
        if (activePos.y > 4 && m[0] != 0) {
          continue;
        }
      }
      ChessPositionModel newPoint = ChessPositionModel(
        x: activePos.x + m[0],
        y: activePos.y + m[1],
      );
      if (newPoint.x < 0 || newPoint.x > 8) {
        continue;
      }
      if (newPoint.y < 0 || newPoint.y > 9) {
        continue;
      }
      // 目标位置是否有己方子
      if (checkCanMove(newPoint, listChessPosition, activePos)) {
        continue;
      }
      points.add(newPoint);
    }
    return points;
  }

  List<ChessPositionModel> _movePhao(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];
    for (var step in [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ]) {
      bool hasRack = false;
      ChessPositionModel movePoint = ChessPositionModel(
        x: activePos.x + step[0],
        y: activePos.y + step[1],
      );
      while (movePoint.x >= 0 &&
          movePoint.x <= 8 &&
          movePoint.y >= 0 &&
          movePoint.y <= 9) {
        ChessPositionModel newChessPosModel = ChessPositionModel(
          x: movePoint.x,
          y: movePoint.y,
        );
        ChessPosition current =
            getChessPosition(listChessPosition, newChessPosModel);
        if (!current.chess.isDead && current.x != -1) {
          // Kiểm tra quân có gặp quân trước khi gặp đôi thủ không
          if (hasRack) {
            if (current.chess.isRed != activePos.chess.isRed) {
              points.add(newChessPosModel);
            }
            break;
          }
          hasRack = true;
        }
        // if (checkCanMove(newChessPosModel, listChessPosition, activePos)) {
        //   break;
        // }

        if (!hasRack) points.add(newChessPosModel);
        movePoint.x += step[0];
        movePoint.y += step[1];
      }
    }
    return points;
  }

  List<ChessPositionModel> _moveMa(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];

    for (var m in [
      [2, 1],
      [1, 2],
      [-2, -1],
      [-1, -2],
      [-2, 1],
      [-1, 2],
      [2, -1],
      [1, -2]
    ]) {
      ChessPositionModel newPoint = ChessPositionModel(
        x: activePos.x + m[0],
        y: activePos.y + m[1],
      );
      if (newPoint.x < 0 || newPoint.x > 8) {
        continue;
      }
      if (newPoint.y < 0 || newPoint.y > 9) {
        continue;
      }
      // Xem quan ma co bi chan khong

      print('${activePos.x + m[0] ~/ 2} ' '${activePos.y + m[1] ~/ 2}');
      if (checkCanMove(
          ChessPositionModel(
              x: activePos.x + m[0] ~/ 2, y: activePos.y + m[1] ~/ 2),
          listChessPosition,
          activePos)) {
        continue;
      }

      ChessPositionModel newChess = ChessPositionModel(
        x: newPoint.x,
        y: newPoint.y,
      );

      ChessPosition current = getChessPosition(listChessPosition, newChess);

      if (!current.chess.isDead &&
          current.x != -1 &&
          current.chess.isRed == activePos.chess.isRed) {
        continue;
      }
      points.add(newChess);
    }
    return points;
  }

  List<ChessPositionModel> _moveTuong(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];
    for (var m in [
      [2, 2],
      [-2, 2],
      [-2, -2],
      [2, -2]
    ]) {
      ChessPositionModel newPoint = ChessPositionModel(
        x: activePos.x + m[0],
        y: activePos.y + m[1],
      );
      if (newPoint.x < 0 || newPoint.x > 8) {
        continue;
      }

      if (newPoint.y < 0 || newPoint.y > 9) {
        continue;
      }
      if (checkCanMove(
          ChessPositionModel(
              x: newPoint.x + m[0] ~/ 2, y: newPoint.y + m[1] ~/ 2),
          listChessPosition,
          activePos)) {
        continue;
      }
      ChessPositionModel newChess = ChessPositionModel(
        x: newPoint.x,
        y: newPoint.y,
      );
      ChessPosition current = getChessPosition(listChessPosition, newChess);

      if (!current.chess.isDead &&
          current.x != -1 &&
          current.chess.isRed == activePos.chess.isRed) {
        continue;
      }

      points.add(newChess);
    }
    return points;
  }

  List<ChessPositionModel> _moveSi(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];

    for (var m in [
      [1, 1],
      [-1, 1],
      [-1, -1],
      [1, -1]
    ]) {
      ChessPositionModel newPoint = ChessPositionModel(
        x: activePos.x + m[0],
        y: activePos.y + m[1],
      );
      if (!activePos.chess.isUp) {
        ChessPositionModel newChess = ChessPositionModel(
          x: newPoint.x,
          y: newPoint.y,
        );
        if (newPoint.x < 0 || newPoint.x > 8) {
          continue;
        }
        if (newPoint.y < 0 || newPoint.y > 9) {
          continue;
        }
        if (checkCanMove(newPoint, listChessPosition, activePos)) {
          continue;
        }

        ChessPosition current = getChessPosition(listChessPosition, newChess);

        if (!current.chess.isDead &&
            current.x != -1 &&
            current.chess.isRed == activePos.chess.isRed) {
          continue;
        }
        points.add(newChess);
      } else {
        if (newPoint.x < 3 || newPoint.x > 5) {
          continue;
        }
        if (activePos.chess.isUp && activePos.chess.isRed) {
          if (newPoint.y < 0 || newPoint.y > 2) {
            continue;
          }
        } else {
          if (newPoint.y < 7 || newPoint.y > 9) {
            continue;
          }
        }
        if (checkCanMove(newPoint, listChessPosition, activePos)) {
          continue;
        }
        ChessPositionModel newChess = ChessPositionModel(
          x: newPoint.x,
          y: newPoint.y,
        );
        ChessPosition current = getChessPosition(listChessPosition, newChess);

        if (!current.chess.isDead &&
            current.x != -1 &&
            current.chess.isRed == activePos.chess.isRed) {
          continue;
        }
        points.add(newChess);
      }
    }
    return points;
  }

  List<ChessPositionModel> moveKing(ChessType code, ChessPosition activePos,
      List<ChessPosition> listChessPosition) {
    List<ChessPositionModel> points = [];

    for (var m in [
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ]) {
      ChessPositionModel newPoint = ChessPositionModel(
        x: activePos.x + m[0],
        y: activePos.y + m[1],
      );
      if (newPoint.x < 3 || newPoint.x > 5) {
        continue;
      }
      if (activePos.chess.isRed) {
        if (newPoint.y < 0 || newPoint.y > 2) {
          continue;
        }
      } else {
        if (newPoint.y < 7 || newPoint.y > 9) {
          continue;
        }
      }
      if (checkCanMove(newPoint, listChessPosition, activePos)) {
        continue;
      }
      ChessPositionModel newChess = ChessPositionModel(
        x: newPoint.x,
        y: newPoint.y,
      );
      points.add(newChess);
    }
    for (var m in [
      [0, 1],
    ]) {
      ChessPositionModel newChessPosModel = ChessPositionModel(
        x: activePos.x + m[0],
        y: activePos.y + m[1],
      );
      while (newChessPosModel.x >= 0 &&
          newChessPosModel.x <= 8 &&
          newChessPosModel.y >= 0 &&
          newChessPosModel.y <= 9) {
        if (checkCanMove(newChessPosModel, listChessPosition, activePos)) {
          break;
        }
        ChessPositionModel? chessKing =
            isKing(listChessPosition, activePos, newChessPosModel);

        if (chessKing.x != -1) {
          points.add(chessKing);
        }
        // } if (!current.chess.isDead) {
        //   break;
        newChessPosModel.x += m[0];
        newChessPosModel.y += m[1];
      }
    }
    return points;
  }

  ChessPositionModel isKing(List<ChessPosition> list,
      ChessPosition chessPosition, ChessPositionModel chessPositionModel) {
    ChessPosition? isKing = list.firstWhere(
        (item) =>
            item.chess.isRed != chessPosition.chess.isRed &&
            item.chess.chessCode == ChessType.tuong &&
            item.x == chessPositionModel.x &&
            item.y == chessPositionModel.y,
        orElse: () => ChessPosition(
            x: -1,
            y: -1,
            chess: Chess(isUp: false, isDead: true, isRed: false)));
    return ChessPositionModel(x: isKing.x, y: isKing.y);
  }
}
