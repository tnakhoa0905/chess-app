import 'package:chess_app_flutter/models/board_model.dart';
import 'package:chess_app_flutter/models/skin.dart';
import 'package:chess_app_flutter/screens/widget/board/board.dart';
import 'package:chess_app_flutter/screens/widget/player/player.dart';
import 'package:chess_app_flutter/service/chess_service.dart';
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
  ChessSkin chessSkin = ChessSkin();
  final ChessServicer _chessServicer = ChessServiceImplement();
  final BoardModel _boardModel = BoardModel();
  @override
  void initState() {
    super.initState();
    setUserName();
  }

  void setUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    roomId = prefs.getInt('roomId')!;
    userName = prefs.getString('userName')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    await _chessServicer.deleteAllChess(roomId);
                    _boardModel.randomlist(roomId);
                  },
                  child: const Text('New Game')),
              const PlaySinglePlayer(
                placeAt: Alignment.topCenter,
                myProfile: false,
              ),
              Board(
                roomId: roomId,
                userName: userName,
              ),
              const PlaySinglePlayer(
                placeAt: Alignment.topCenter,
                myProfile: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
