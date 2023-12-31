import 'package:chess_app_flutter/models/user.dart';
import 'package:chess_app_flutter/models/user_in_room.dart';
import 'package:chess_app_flutter/screens/home/home.dart';
import 'package:chess_app_flutter/screens/room_page/room_page.dart';
import 'package:chess_app_flutter/screens/sign_up/sign_up_page.dart';
import 'package:chess_app_flutter/service/user_in_room_service.dart';
import 'package:chess_app_flutter/service/user_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _userName = TextEditingController();
  final UserService _userService = UserServiceImplement();

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
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: TextFormField(
                      controller: _userName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 152, 128, 119),
                                width: 2)),
                        hintText: 'Enter username',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        UserModel? result =
                            await _userService.getUser(_userName.text);

                        if (result != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RoomPage()));
                          _userName.clear();
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
                          side: BorderSide(width: 2, color: Colors.green),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 60, child: Divider()),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SignUpPage()))),
                    child: const Text(
                      'or Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
