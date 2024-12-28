import 'package:chess/chess.dart' as chess;

class ChessAI {
  static const int MAX_DEPTH = 2;  // Reduced depth for faster computation
  
  static Map<String, int> pieceValues = {
    'p': 1,
    'n': 3,
    'b': 3,
    'r': 5,
    'q': 9,
    'k': 100,
  };

  static int evaluateBoard(chess.Chess game) {
    if (game.in_checkmate) {
      return game.turn == chess.Color.WHITE ? -10000 : 10000;
    }
    
    if (game.in_draw || game.in_stalemate || game.in_threefold_repetition) {
      return 0;
    }

    int score = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        final square = '${String.fromCharCode(97 + j)}${8 - i}';
        final piece = game.get(square);
        if (piece != null) {
          int value = pieceValues[piece.type.toLowerCase()] ?? 0;
          if (piece.color == chess.Color.WHITE) {
            score += value;
          } else {
            score -= value;
          }
        }
      }
    }
    return score;
  }

  static Map<String, dynamic>? getBestMove(chess.Chess game) {
    if (game.game_over) return null;

    final moves = game.moves({'verbose': true}) as List<Map<String, dynamic>>;
    if (moves.isEmpty) return null;

    // Add randomness to move selection for variety
    moves.shuffle();

    Map<String, dynamic>? bestMove;
    int bestValue = -99999;

    for (var move in moves) {
      game.move(move);
      int value = -evaluateBoard(game);  // Simplified evaluation
      game.undo();

      if (value > bestValue) {
        bestValue = value;
        bestMove = move;
      }
    }

    return bestMove;
  }
}
