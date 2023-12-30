import 'package:chess_app_flutter/chess_maanger/rule.dart';
import 'package:chess_app_flutter/core/constrain.dart';
import 'package:chess_app_flutter/models/board_model.dart';
import 'package:chess_app_flutter/models/chess.dart';
import 'package:chess_app_flutter/models/chess_position.dart';
import 'package:chess_app_flutter/models/pos.dart';
import 'package:chess_app_flutter/models/skin.dart';
import 'package:chess_app_flutter/models/user_in_room.dart';
import 'package:chess_app_flutter/screens/widget/chess_piece/chess_piece.dart';
import 'package:chess_app_flutter/screens/widget/point_widget.dart';
import 'package:chess_app_flutter/service/chess_service.dart';
import 'package:chess_app_flutter/service/user_in_room_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Board extends StatefulWidget {
  const Board(
      {Key? key,
      required this.roomId,
      required this.userName,
      required this.isRed})
      : super(key: key);
  final int roomId;
  final String userName;
  final bool isRed;
  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool yourTurn = false;
  bool isRed = false;
  final ChessSkin skin = ChessSkin();
  final ChessRule rule = ChessRule();
  final BoardModel _board = BoardModel();
  ChessPosition? activeItem;
  late ChessPositionModel lastPosition;
  List<ChessPosition> listChessPositions = [];
  final ChessServicer _chessService = ChessServiceImplement();
  final UserInRoomService _userInRoomService = UserInRoomServireImplement();
  List<ChessPositionModel> movePoints = [];
  // late Stream<List<ChessPosition>> chessStream;
  final Supabase supabase = Supabase.instance;
  String userName = '';
  late final Stream<List<ChessPosition>> _chessStream;

  @override
  void initState() {
    super.initState();
    _board.randomlist(widget.roomId);
    setYourTurn();
    activeItem = null;
    lastPosition = ChessPositionModel(x: -1, y: -1);
    _chessStream = supabase.client
        .from("chess_in_room")
        .stream(primaryKey: ['id'])
        .order('id', ascending: true)
        .eq("room_id", widget.roomId)
        .map(
          (maps) => maps.map((map) => ChessPosition.fromJson(map)).toList(),
        );
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // setState(() {
  //   //   yourTurn;
  //   //   // listChessPositions;
  //   // });
  // }

  @override
  void dispose() {
    super.dispose();
    // _chessService.deleteAllChess(widget.roomId);
    listChessPositions.clear();
  }

  void setYourTurn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName')!;
    // isRed = await _userInRoomService.getTeamInUserInRoom(userName);
    isRed = widget.isRed;
    yourTurn = await _userInRoomService.getTurnInUserInRoom(userName);
    setState(() {
      isRed;
      yourTurn;
    });
  }

  ChessPositionModel pointTrans(Offset tapPoint, double scale) {
    int x = (tapPoint.dx - skin.offset.dx * scale) ~/ (skin.size * scale);
    int y = 9 - (tapPoint.dy - skin.offset.dy * scale) ~/ (skin.size * scale);

    return ChessPositionModel(x: x, y: y);
  }

  Future<void> fetchMovePoints() async {
    setState(() {
      movePoints = rule.movePoints(activeItem!, listChessPositions);
    });
  }

  Future<bool> onPointer(ChessPositionModel toPosition) async {
    ChessPosition newActive = listChessPositions.firstWhere(
        (item) =>
            item.chess.isDead == false &&
            item.x == toPosition.x &&
            item.y == toPosition.y,
        orElse: () => ChessPosition(
            x: toPosition.x,
            y: toPosition.y,
            chess: Chess(isUp: false, isDead: false, isRed: false)));

    print(newActive.chess.chessCodeUp);
    if (yourTurn == false) return false;

    if (!newActive.chess.isDead) {
      if (activeItem != null) {
        if (activeItem!.chess.isRed != isRed && yourTurn == true) {
          setState(() {
            activeItem = null;
            movePoints = [];
          });
          return false;
        }
        int index = listChessPositions.indexWhere((item) =>
            item.x == activeItem!.x &&
            item.y == activeItem!.y &&
            item.chess.chessCode == activeItem!.chess.chessCode &&
            item.chess.chessCodeUp == activeItem!.chess.chessCodeUp);
        int result = movePoints.indexWhere(
            (item) => item.x == toPosition.x && item.y == toPosition.y);
        if (result < 0) {
          setState(() {
            movePoints = [];
            activeItem = null;
          });
          return false;
        }

        int indexEat = listChessPositions.indexWhere((item) =>
            item.x == toPosition.x &&
            item.y == toPosition.y &&
            !item.chess.isDead);
        // List<ChessPosition> listchekc = [];
        if (indexEat != -1) {
          setState(() {
            print(toPosition.x);
            print(toPosition.y);
            print('move');
            listChessPositions[indexEat].chess.isDead = true;
            listChessPositions[index].chess.isUp = false;
            listChessPositions[index].x = toPosition.x;
            listChessPositions[index].y = toPosition.y;
            print(listChessPositions[index].x);
            print(listChessPositions[index].y);
            activeItem = null;
            yourTurn = !yourTurn;
            movePoints = [];
          });
          // Future.delayed(const Duration(seconds: 2), () async {});
          print(listChessPositions[index].chess.chessCode);
          print(listChessPositions[index].chess.chessCodeUp);
          print(listChessPositions[index].x);
          print(listChessPositions[index].y);
          _chessService.updateChess(listChessPositions[indexEat]);
          _chessService.updateChess(listChessPositions[index]);
        } else {
          print('move');

          setState(() {
            listChessPositions[index].chess.isUp = false;
            activeItem = null;
            yourTurn = !yourTurn;
            listChessPositions[index].x = toPosition.x;
            listChessPositions[index].y = toPosition.y;
            movePoints = [];
          });
          _chessService.updateChess(listChessPositions[index]);
        }

        _userInRoomService.updateTurnInUserInRoom(widget.roomId);
        return true;
      }
    }

    if (activeItem != null) {
      // Sound.play(Sound.click);
      setState(() {
        activeItem = null;
        movePoints = [];
      });
    } else {
      // 切换选中的子
      if (newActive.chess.isRed != isRed) {
        return false;
      }
      setState(() {
        activeItem = newActive;
        lastPosition.x = activeItem!.x;
        lastPosition.y = activeItem!.y;
        movePoints = [];
      });
      fetchMovePoints();
      return true;
    }
    print(false);
    return false;
  }

  Alignment _getAlign(
    int xIn,
    int yIn,
  ) {
    final x = ((xIn * skin.size) * 2) / (skin.width - skin.size) - 1;
    final y = ((((9 - yIn) * skin.size) * 2) / (skin.height - skin.size) - 1);
    return Alignment(
      x,
      y,
    );
  }

  bool checkItemContains(ChessPosition? toPosition) {
    if (activeItem == null) return false;
    ChessPosition newActive = listChessPositions.firstWhere(
        (item) =>
            !item.chess.isDead &&
            item.x == toPosition!.x &&
            item.y == toPosition.y,
        orElse: () => ChessPosition(
            x: toPosition!.x,
            y: toPosition.y,
            chess: Chess(isUp: false, isDead: true, isRed: false)));

    if (newActive.chess.isDead) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> layer2 = [];
    for (var element in movePoints) {
      layer2.add(
        Align(
          alignment: _getAlign(element.x, element.y),
          child: PointComponent(size: skin.size * skin.scale),
        ),
      );
    }
    Size size = MediaQuery.of(context).size;
    double scale = ChessSkin().getScale(size);
    print(widget.isRed);
    return RotationTransition(
      turns: widget.isRed
          ? const AlwaysStoppedAnimation(1)
          : const AlwaysStoppedAnimation(0.5),
      child: GestureDetector(
        onTapUp: (details) {
          setState(() {
            onPointer(pointTrans(details.localPosition, scale));
          });
        },
        child: SizedBox(
          // transform: Matrix4.identity()..rotateX(150),
          // height: skin.height * ChessSkin().getScale(size),
          height: skin.height * scale,
          width: skin.width * scale,
          child: Stack(
            children: [
              StreamBuilder<List<UserInRoomModel>>(
                  stream: supabase.client
                      .from("user_in_room")
                      .stream(primaryKey: ["id"])
                      .eq("room_id", widget.roomId)
                      .map(
                        (maps) => maps
                            .map((map) => UserInRoomModel.fromJson(map))
                            .toList(),
                      ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if (snapshot.hasData) {
                      UserInRoomModel userInRoom = snapshot.data!
                          .firstWhere((item) => item.userName == userName);
                      yourTurn = userInRoom.yourTurn;
                      return const SizedBox();
                    }
                    return Container();
                  }),
              Align(
                alignment: const Alignment(0, 0),
                child: SizedBox(
                  child: Image.asset(AppString.gameBoard),
                ),
              ),
              StreamBuilder<List<ChessPosition>>(
                stream: _chessStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    listChessPositions = [];
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    List<ChessPosition> listChessPositonResult = snapshot.data!;
                    // print('leght of list chess pos');
                    // print(listChessPositonResult.length);
                    // print(listChessPositions.length);
                    if (listChessPositonResult.length < 32) {
                      listChessPositions.clear();
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // if (listChessPositonResult.length == 32) {
                    // for (var element in listChessPositonResult) {
                    //   listChessPositions.add(element);
                    // }

                    else {
                      if (listChessPositions.isEmpty) {
                      } else {
                        if (checkItemContains(activeItem) ||
                            yourTurn == false) {
                          listChessPositions = snapshot.data!;
                        } else {
                          // listChessPositions = listChessPositions;
                        }
                      }
                      if (checkItemContains(activeItem) || yourTurn == false) {
                        listChessPositions = snapshot.data!;
                      } else if (listChessPositions.isEmpty) {
                        listChessPositions = snapshot.data!;
                      } else {
                        listChessPositions = listChessPositions;
                      }
                    }

                    // listChessPositions.clear();

                    // }
                  }

                  return ChessPieces(
                    isRed: widget.isRed,
                    items: listChessPositions,
                    activeItem: activeItem,
                  );
                },
              ),
              Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: layer2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
