import 'package:chess_app_flutter/models/chess_position.dart';
import 'package:chess_app_flutter/models/skin.dart';
import 'package:chess_app_flutter/screens/widget/chess_piece/piece.dart';
import 'package:flutter/material.dart';

class ChessPieces extends StatefulWidget {
  final List<ChessPosition> items;
  final bool isRed;
  final ChessPosition? activeItem;
  const ChessPieces(
      {Key? key,
      required this.items,
      required this.activeItem,
      required this.isRed})
      : super(key: key);

  @override
  State<ChessPieces> createState() => _ChessPiecesState();
}

class _ChessPiecesState extends State<ChessPieces> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: widget.items.map<Widget>((ChessPosition item) {
        bool isActive = false;
        bool isHover = false;
        if (item.chess.isDead) {
          //return;
        } else if (widget.activeItem != null) {
          if (widget.activeItem! == item) {
            isActive = true;
            // isHover = true;
          }
        }

        return AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuint,
          alignment: _getAlign(
            item.x,
            item.y,
          ),
          child: RotationTransition(
            turns: widget.isRed
                ? const AlwaysStoppedAnimation(1)
                : const AlwaysStoppedAnimation(0.5),
            child: SizedBox(
              width: 57 * ChessSkin().getScale(size),
              height: 57 * ChessSkin().getScale(size),
              child: Piece(
                item: item.chess,
                isHover: isHover,
                isActive: isActive,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

Alignment _getAlign(
  int xIn,
  int yIn,
) {
  final x = ((xIn * 57) * 2) / (521 - 57) - 1;
  final y = ((((9 - yIn) * 57) * 2) / (577 - 57) - 1);
  // print('Chess pos x: ${pos.x}, y: ${pos.y}' '    align: ($x , $y)');
  return Alignment(
    x,
    y,
  );
}
