import 'package:chess_app_flutter/models/chess.dart';
import 'package:chess_app_flutter/models/skin.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
/// 棋子
class Piece extends StatefulWidget {
  final Chess item;
  final bool isActive;
  final bool isAblePoint;
  final bool isHover;

  const Piece({
    Key? key,
    required this.item,
    this.isActive = false,
    this.isHover = false,
    this.isAblePoint = false,
  }) : super(key: key);

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> {
  final ChessSkin skin = ChessSkin();

  Widget blankWidget() {
    double size = skin.size * skin.scale;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.item.isDead
        ? blankWidget()
        : AnimatedContainer(
            width: 48,
            height: 48,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint,
            transform: widget.isHover
                ? (Matrix4.translationValues(-4, -4, -4))
                : (Matrix4.translationValues(0, 0, 0)),
            transformAlignment: Alignment.topCenter,
            decoration: (widget.isHover)
                ? const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .1),
                        offset: Offset(2, 3),
                        blurRadius: 1,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .1),
                        offset: Offset(4, 6),
                        blurRadius: 2,
                        spreadRadius: 2,
                      )
                    ],
                    //border: Border.all(color: Color.fromRGBO(255, 255, 255, .7), width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(57 / 2),
                    ),
                  )
                : BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .2),
                        offset: Offset(2, 2),
                        blurRadius: 1,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .1),
                        offset: Offset(3, 3),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                    border: widget.isActive
                        ? Border.all(
                            color: Colors.white54,
                            width: 2,
                            style: BorderStyle.solid,
                          )
                        : null,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(57 / 2),
                    ),
                  ),
            child: Stack(
              children: [
                Image.asset(skin.getChessSkin(widget.item)),
              ],
            ),
          );
  }
}
