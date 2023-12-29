import 'package:chess_app_flutter/screens/play/play_chess.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/hinh.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const PlayChess()),
                        ));
                      },
                      child: const Text('Play with friend')),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Play with bot'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
