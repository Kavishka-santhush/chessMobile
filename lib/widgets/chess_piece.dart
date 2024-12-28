import 'package:flutter/material.dart';

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
          return Icons.fort;
        case 'n':
          return Icons.emoji_nature;
        case 'b':
          return Icons.change_history;
        case 'q':
          return Icons.stars;
        case 'k':
          return Icons.workspace_premium;
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
