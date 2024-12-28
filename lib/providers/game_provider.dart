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
    if (_game.turn != chess.Color.BLACK || _isThinking || _game.game_over) return;
    
    _isThinking = true;
    notifyListeners();

    try {
      // Add a small delay to show the thinking state
      await Future.delayed(const Duration(milliseconds: 300));

      // Add timeout to prevent infinite thinking
      final move = await Future.delayed(
        const Duration(seconds: 2),
        () => ChessAI.getBestMove(_game),
      );

      if (move != null && !_game.game_over) {
        _game.move(move);
      }
    } catch (e) {
      print('AI move error: $e');
    } finally {
      _isThinking = false;
      _selectedPiece = null;
      _validMoves = [];
      notifyListeners();
    }
  }

  Future<bool> movePiece(String from, String to) async {
    if (_game.turn != chess.Color.WHITE || _isThinking) return false;
    
    try {
      final move = _game.move({'from': from, 'to': to});
      if (move != null) {
        _selectedPiece = null;
        _validMoves = [];
        notifyListeners();
        
        if (!_game.game_over) {
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
