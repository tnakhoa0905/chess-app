import 'package:chess_app_flutter/models/board_model.dart';
import 'package:chess_app_flutter/models/skin.dart';
import 'package:chess_app_flutter/screens/widget/board/board.dart';
import 'package:chess_app_flutter/screens/widget/player/player.dart';
import 'package:chess_app_flutter/service/chess_service.dart';
import 'package:chess_app_flutter/service/user_in_room_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayChess extends StatefulWidget {
  const PlayChess({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayChess();
}

class _PlayChess extends State<PlayChess> {
  Supabase supabase = Supabase.instance;
  int roomId = 0;
  String userName = '';
  bool isRed = false;
  ChessSkin chessSkin = ChessSkin();
  final UserInRoomService _userInRoomService = UserInRoomServireImplement();
  final ChessServicer _chessServicer = ChessServiceImplement();
  final BoardModel _boardModel = BoardModel();
  final ChessSkin skin = ChessSkin();
  @override
  void initState() {
    super.initState();
    setUserName();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  delete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void setUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getInt('roomId')!;
    userName = prefs.getString('userName')!;
    isRed = prefs.getBool('isRed')!;
    setState(() {
      roomId;
      userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double scale = ChessSkin().getScale(size);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            // height: skin.height * scale,
            // width: skin.width * scale,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Image.asset(
                  'assets/images/hinh.jpg',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                Center(
                  child: Container(
                    width: skin.width * scale,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.navigate_before,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              await _chessServicer.deleteAllChess(roomId);
                              _boardModel.randomlist(roomId);
                              _userInRoomService.resetTurnInUserInRoom(roomId);
                            },
                            child: const Text('New Game')),
                        const PlaySinglePlayer(
                          placeAt: Alignment.topCenter,
                          myProfile: false,
                        ),
                        if (!(roomId == 0) && !(userName == ''))
                          Board(
                              roomId: roomId, userName: userName, isRed: isRed),
                        const PlaySinglePlayer(
                          placeAt: Alignment.topCenter,
                          myProfile: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
