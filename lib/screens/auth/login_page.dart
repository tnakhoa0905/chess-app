import 'package:chess_app_flutter/models/user.dart';
import 'package:chess_app_flutter/screens/home/home.dart';
import 'package:chess_app_flutter/service/user_in_room_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _enterRoom = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final UserInRoomService _userInRoomService = UserInRoomServireImplement();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              child: TextFormField(
                controller: _enterRoom,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter ID room',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              child: TextFormField(
                controller: _userName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter User',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                bool result = await _userInRoomService.createUserInRoom(
                    UserInRoomModel(
                        roomId: -1,
                        yourTurn: false,
                        userName: _userName.text,
                        isRed: false),
                    _enterRoom.text);
                if (result) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                  _enterRoom.clear();
                  _userName.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Tên đã tồn taị hoặc phòng đã đủ người"),
                  ));
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    ));
  }
}
