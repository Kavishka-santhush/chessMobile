import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import '../utils/chess_ai.dart';

class GameProvider extends ChangeNotifier {
  late chess.Chess _game;
  String? _selectedPiece;
  List<String> _validMoves = [];
  bool _isThinking = false;

  GameProvider() {
    _game = chess.Chess();
  }

  chess.Chess get game => _game;
  String? get selectedPiece => _selectedPiece;
  List<String> get validMoves => _validMoves;
  bool get isGameOver => _game.game_over;
  bool get isThinking => _isThinking;
  String? get winner => isGameOver ? (_game.in_checkmate ? (_game.turn == chess.Color.WHITE ? 'Black' : 'White') : 'Draw') : null;

  void selectPiece(String square) {
    if (_game.turn != chess.Color.WHITE || _isThinking) return;
    
    final piece = _game.get(square);
    if (piece == null || piece.color != chess.Color.WHITE) {
      _selectedPiece = null;
      _validMoves = [];
    } else {
      _selectedPiece = square;
      _validMoves = _game.moves({'square': square, 'verbose': true})
          .map((move) => (move as Map<String, dynamic>)['to'].toString())
          .toList();
    }
    notifyListeners();
  }

  Future<void> makeAIMove() async {
    if (_game.turn != chess.Color.BLACK || _isThinking || _game.game_over) {
      print('Skipping AI move: wrong turn or game state');
      print('Turn: ${_game.turn}, Thinking: $_isThinking, Game over: ${_game.game_over}');
      return;
    }
    
    _isThinking = true;
    notifyListeners();

    try {
      // Small delay for UI feedback
      await Future.delayed(const Duration(milliseconds: 500));

      print('Current board state:');
      print(_game.ascii);
      print('Current turn: ${_game.turn}');

      // Get AI move
      final move = ChessAI.getBestMove(_game);
      print('AI move selected: $move');

      if (move != null && move['from'] != null && move['to'] != null) {
        // Make the move
        final result = _game.move({
          'from': move['from']!,
          'to': move['to']!,
          if (move['promotion'] != null) 'promotion': move['promotion']!
        });

        print('Move made: $result');
        print('New board state:');
        print(_game.ascii);
        
        if (result == null) {
          print('Failed to make move: ${move['from']} to ${move['to']}');
        }
      } else {
        print('No valid moves found for AI');
      }
    } catch (e, stackTrace) {
      print('Error making AI move: $e');
      print('Stack trace: $stackTrace');
    } finally {
      _isThinking = false;
      _selectedPiece = null;
      _validMoves = [];
      notifyListeners();
    }
  }

  Future<bool> movePiece(String from, String to) async {
    if (_game.turn != chess.Color.WHITE || _isThinking) {
      print('Invalid move attempt: wrong turn or thinking');
      return false;
    }
    
    try {
      final move = _game.move({'from': from, 'to': to});
      if (move != null) {
        print('Player moved: $from to $to');
        _selectedPiece = null;
        _validMoves = [];
        notifyListeners();
        
        // Make AI move after a short delay
        if (!_game.game_over) {
          await Future.delayed(const Duration(milliseconds: 500));
          await makeAIMove();
        }
        return true;
      }
    } catch (e) {
      print('Invalid move: $e');
    }
    return false;
  }

  void resetGame() {
    _game = chess.Chess();
    _selectedPiece = null;
    _validMoves = [];
    _isThinking = false;
    notifyListeners();
  }
}
