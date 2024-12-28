import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'chess_piece.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemCount: 64,
      itemBuilder: (context, index) {
        final row = index ~/ 8;
        final col = index % 8;
        final isBlack = (row + col) % 2 == 1;
        final square = '${String.fromCharCode(97 + col)}${8 - row}';

        return Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            final piece = gameProvider.game.get(square);
            final isSelected = square == gameProvider.selectedPiece;
            final isValidMove = gameProvider.validMoves.contains(square);

            return GestureDetector(
              onTap: () {
                if (isValidMove && gameProvider.selectedPiece != null) {
                  gameProvider.movePiece(gameProvider.selectedPiece!, square);
                } else {
                  gameProvider.selectPiece(square);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withOpacity(0.5)
                      : isValidMove
                          ? Colors.green.withOpacity(0.3)
                          : isBlack
                              ? Colors.brown[300]
                              : Colors.brown[100],
                ),
                child: piece != null
                    ? ChessPiece(
                        piece: piece['type'].toString(),
                        isWhite: piece['color'].toString() == 'w',
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
