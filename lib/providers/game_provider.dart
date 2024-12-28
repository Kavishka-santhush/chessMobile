import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class GameProvider extends ChangeNotifier {
  late chess.Chess _game;
  String? _selectedPiece;
  List<String> _validMoves = [];

  GameProvider() {
    _game = chess.Chess();
  }

  chess.Chess get game => _game;
  String? get selectedPiece => _selectedPiece;
  List<String> get validMoves => _validMoves;
  bool get isGameOver => _game.game_over;
  String? get winner => isGameOver ? (_game.in_checkmate ? (_game.turn == chess.Color.WHITE ? 'Black' : 'White') : 'Draw') : null;

  void selectPiece(String square) {
    if (_game.get(square) == null) {
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

  bool movePiece(String from, String to) {
    try {
      final move = _game.move({'from': from, 'to': to});
      if (move != null) {
        _selectedPiece = null;
        _validMoves = [];
        notifyListeners();
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
    notifyListeners();
  }
}
