import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChessPiece extends StatelessWidget {
  final String piece;
  final bool isWhite;

  const ChessPiece({
    super.key,
    required this.piece,
    required this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _getPieceWidget(),
    );
  }

  Widget _getPieceWidget() {
    final color = isWhite ? Colors.white : Colors.black;
    
    IconData getIcon() {
      switch (piece.toLowerCase()) {
        case 'p':
          return Icons.person;
        case 'r':
          return Icons.castle;
        case 'n':
          return Icons.sports_hockey;
        case 'b':
          return Icons.church;
        case 'q':
          return Icons.corona;
        case 'k':
          return Icons.king_bed;
        default:
          return Icons.help_outline;
      }
    }

    return Icon(
      getIcon(),
      color: color,
      size: 32,
    );
  }
}
