import 'package:chess/chess.dart' as chess;
import 'dart:math' as math;

class ChessAI {
  static final math.Random _random = math.Random();

  static Map<String, String>? getBestMove(chess.Chess game) {
    try {
      // Get all possible moves
      final moves = game.moves({'verbose': true});
      if (moves.isEmpty) return null;

      // Convert moves to the correct format
      final legalMoves = moves.map((move) {
        final m = move as Map<String, dynamic>;
        return {
          'from': m['from'].toString(),
          'to': m['to'].toString(),
          'promotion': m['promotion']?.toString(),
        };
      }).toList();

      // Pick a random move from legal moves
      if (legalMoves.isNotEmpty) {
        final moveIndex = _random.nextInt(legalMoves.length);
        return Map<String, String>.from(legalMoves[moveIndex]);
      }
    } catch (e) {
      print('Error in getBestMove: $e');
    }
    return null;
  }
}
