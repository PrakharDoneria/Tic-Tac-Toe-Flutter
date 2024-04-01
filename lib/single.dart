import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SinglePlayer extends StatefulWidget {
  @override
  _SinglePlayerState createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer> {
  List<String> _board = List.filled(9, '');
  bool _gameOver = false;
  String _winner = '';
  int _player1Score = 0;
  int _player2Score = 0;
  bool _isPlayer1Turn = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _player1Score = prefs.getInt('player1Score') ?? 0;
      _player2Score = prefs.getInt('player2Score') ?? 0;
    });
  }

  Future<void> _saveScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('player1Score', _player1Score);
    prefs.setInt('player2Score', _player2Score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Player'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'RESULTS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'X: $_player1Score',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'O: $_player2Score',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildBoard(),
            SizedBox(height: 20),
            _gameOver ? _buildResultModal() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _board.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _onTap(index);
            },
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text(
                  _board[index],
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onTap(int index) {
    if (!_gameOver && _board[index] == '') {
      setState(() {
        _board[index] = 'X';
        if (_checkWinner('X')) {
          _player1Score++;
          _gameOver = true;
          _winner = 'X Wins!';
          _saveScores();
          _resetGame();
        } else if (!_board.contains('')) {
          _gameOver = true;
          _winner = 'Draw!';
          _resetGame();
        } else {
          _isPlayer1Turn = false;
          Timer(Duration(milliseconds: 500), _aiMove);
        }
      });
    }
  }

  bool _checkWinner(String player) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (_board[condition[0]] == player &&
          _board[condition[1]] == player &&
          _board[condition[2]] == player) {
        return true;
      }
    }

    return false;
  }

  void _aiMove() {
    int bestScore = -1000;
    int bestMove = -1;
    int alpha = -1000;
    int beta = 1000;

    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == '') {
        _board[i] = 'O';
        int score = _minimax(_board, 0, false, alpha, beta);
        _board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    if (bestMove != -1) {
      _board[bestMove] = 'O';
      setState(() {
        _isPlayer1Turn = true;
        if (_checkWinner('O')) {
          _player2Score++;
          _gameOver = true;
          _winner = 'O Wins!';
          _saveScores();
          _resetGame();
        }
        if (!_board.contains('')) {
          _gameOver = true;
          _winner = 'Draw!';
          _resetGame();
        }
      });
    }
  }

  int _minimax(List<String> board, int depth, bool isMaximizing, int alpha, int beta) {
    String opponent = isMaximizing ? 'X' : 'O';

    bool result = _checkWinner(opponent);
    if (result) {
      if (opponent == 'X') {
        return -10 + depth;
      } else {
        return 10 - depth;
      }
    }

    if (!_board.contains('')) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = _minimax(board, depth + 1, false, alpha, beta);
          board[i] = '';
          bestScore = math.max(score, bestScore);
          alpha = math.max(alpha, score);
          if (beta <= alpha) {
            break;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = _minimax(board, depth + 1, true, alpha, beta);
          board[i] = '';
          bestScore = math.min(score, bestScore);
          beta = math.min(beta, score);
          if (beta <= alpha) {
            break;
          }
        }
      }
      return bestScore;
    }
  }

  void _resetGame() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _board = List.filled(9, '');
        _gameOver = false;
        _winner = '';
      });
    });
  }

  Widget _buildResultModal() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _winner,
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SinglePlayer(),
  ));
}
