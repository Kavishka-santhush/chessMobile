import 'package:chess/chess.dart' as chess;
import 'dart:math' as math;

class ChessAI {
  static final math.Random _random = math.Random();

  static Map<String, String>? getBestMove(chess.Chess game) {
    try {
      if (game.game_over) {
        print('Game is over, no moves possible');
        return null;
      }

      // Get all possible moves for the current position
      final List<Map<String, dynamic>> moves = List<Map<String, dynamic>>.from(
        game.moves({'verbose': true})
      );

      print('Available moves: $moves'); // Debug print

      if (moves.isEmpty) {
        print('No moves available');
        return null;
      }

      // Pick a random move
      final move = moves[_random.nextInt(moves.length)];
      
      // Ensure we have the required fields
      if (move['from'] == null || move['to'] == null) {
        print('Invalid move format: $move');
        return null;
      }

      // Create the move map
      final Map<String, String> selectedMove = {
        'from': move['from'],
        'to': move['to'],
      };

      // Add promotion if present
      if (move['promotion'] != null) {
        selectedMove['promotion'] = move['promotion'];
      }

      print('Selected move: $selectedMove'); // Debug print
      return selectedMove;

    } catch (e, stackTrace) {
      print('Error in getBestMove: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
