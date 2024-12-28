import 'package:chess/chess.dart' as chess;

class ChessAI {
  static const int MAX_DEPTH = 3;
  
  static Map<String, int> pieceValues = {
    'p': 100,
    'n': 320,
    'b': 330,
    'r': 500,
    'q': 900,
    'k': 20000,
  };

  static int evaluateBoard(chess.Chess game) {
    if (game.in_checkmate) {
      return game.turn == chess.Color.WHITE ? -999999 : 999999;
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

  static int minimax(chess.Chess game, int depth, int alpha, int beta, bool maximizing) {
    if (depth == 0 || game.game_over) {
      return evaluateBoard(game);
    }

    final moves = game.moves({'verbose': true}) as List<Map<String, dynamic>>;
    
    if (maximizing) {
      int maxEval = -999999;
      for (var move in moves) {
        game.move(move);
        int eval = minimax(game, depth - 1, alpha, beta, false);
        game.undo();
        maxEval = maxEval > eval ? maxEval : eval;
        alpha = alpha > eval ? alpha : eval;
        if (beta <= alpha) break;
      }
      return maxEval;
    } else {
      int minEval = 999999;
      for (var move in moves) {
        game.move(move);
        int eval = minimax(game, depth - 1, alpha, beta, true);
        game.undo();
        minEval = minEval < eval ? minEval : eval;
        beta = beta < eval ? beta : eval;
        if (beta <= alpha) break;
      }
      return minEval;
    }
  }

  static Map<String, dynamic>? getBestMove(chess.Chess game) {
    final moves = game.moves({'verbose': true}) as List<Map<String, dynamic>>;
    if (moves.isEmpty) return null;

    Map<String, dynamic>? bestMove;
    int bestValue = -999999;

    for (var move in moves) {
      game.move(move);
      int value = minimax(game, MAX_DEPTH - 1, -999999, 999999, false);
      game.undo();

      if (value > bestValue) {
        bestValue = value;
        bestMove = move;
      }
    }

    return bestMove;
  }
}
