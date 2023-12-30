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
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const PlayChess()),
                          ));
                        },
                        child: const Text('Play with friend')),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
