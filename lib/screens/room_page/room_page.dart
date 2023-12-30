import 'package:chess_app_flutter/models/user_in_room.dart';
import 'package:chess_app_flutter/screens/auth/login_page.dart';
import 'package:chess_app_flutter/screens/home/home.dart';
import 'package:chess_app_flutter/service/user_in_room_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final TextEditingController _enterRoom = TextEditingController();
  UserInRoomService _userInRoomService = UserInRoomServireImplement();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/hinh.jpg',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Room',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: TextFormField(
                      controller: _enterRoom,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 152, 128, 119),
                                width: 2)),
                        hintText: 'Enter room',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const LoginPage())),
                                  (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              maximumSize: Size(350, 50),
                              elevation: 0,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                    width: 2, color: Colors.green),
                              ),
                            ),
                            child: const Text('Logout'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String userName = prefs.getString('userName')!;
                              bool result =
                                  await _userInRoomService.createUserInRoom(
                                      UserInRoomModel(
                                          roomId: -1,
                                          yourTurn: false,
                                          userName: userName,
                                          isRed: false),
                                      _enterRoom.text);
                              if (result) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                                _enterRoom.clear();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Tên đã tồn taị"),
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              maximumSize: Size(350, 50),
                              elevation: 0,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                    width: 2, color: Colors.green),
                              ),
                            ),
                            child: const Text('Join'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
