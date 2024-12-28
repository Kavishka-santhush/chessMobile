import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class ChessPiece extends StatelessWidget {
  final chess.PieceType piece;
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
      switch (piece) {
        case chess.PieceType.PAWN:
          return Icons.person;
        case chess.PieceType.ROOK:
          return Icons.account_balance;
        case chess.PieceType.KNIGHT:
          return Icons.emoji_nature;
        case chess.PieceType.BISHOP:
          return Icons.change_history;
        case chess.PieceType.QUEEN:
          return Icons.star;
        case chess.PieceType.KING:
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
