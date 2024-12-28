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
    if (_game.turn != chess.Color.WHITE || _isThinking) return; // Only allow white moves when it's player's turn
    
    final piece = _game.get(square);
    if (piece == null || piece.color != chess.Color.WHITE) {
      _selectedPiece = null;
      _validMoves = [];
    } else {
      _selectedPiece = square;
      _validMoves = _game.moves({'square': square, 'verbose': true})
          .map((move) => move['to'].toString())
          .toList();
    }
    notifyListeners();
  }

  Future<void> makeAIMove() async {
    if (_game.turn != chess.Color.BLACK || _isThinking || _game.game_over) return;
    
    _isThinking = true;
    notifyListeners();

    // Add a small delay to show the thinking state
    await Future.delayed(const Duration(milliseconds: 500));

    final move = ChessAI.getBestMove(_game);
    if (move != null) {
      if (move is Map) {
        _game.move(move);
      } else if (move is String) {
        _game.move({'from': move.substring(0, 2), 'to': move.substring(2, 4), 'promotion': move.length > 4 ? move.substring(4) : 'q'});
      }
    }

    _isThinking = false;
    _selectedPiece = null;
    _validMoves = [];
    notifyListeners();
  }

  Future<bool> movePiece(String from, String to) async {
    if (_game.turn != chess.Color.WHITE || _isThinking) return false;
    
    try {
      final move = _game.move({'from': from, 'to': to});
      if (move != null) {
        _selectedPiece = null;
        _validMoves = [];
        notifyListeners();
        
        // Make AI move after player's move
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
