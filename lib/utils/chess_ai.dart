import 'package:chess/chess.dart' as chess;
import 'dart:math' as math;

class ChessAI {
  static final math.Random _random = math.Random();

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

    // Get all legal moves for black
    final moves = game.moves({'verbose': true}) as List<Map<String, dynamic>>;
    if (moves.isEmpty) return null;

    // Evaluate each move
    List<MapEntry<Map<String, dynamic>, int>> scoredMoves = [];
    
    for (var move in moves) {
      game.move(move);
      int score = -evaluateBoard(game);  // Negative because we're playing as black
      game.undo();
      scoredMoves.add(MapEntry(move, score));
    }

    // Sort moves by score
    scoredMoves.sort((a, b) => b.value.compareTo(a.value));

    // Select one of the top 3 moves randomly for variety
    int topMoves = math.min(3, scoredMoves.length);
    int selectedIndex = _random.nextInt(topMoves);
    
    return scoredMoves[selectedIndex].key;
  }
}
