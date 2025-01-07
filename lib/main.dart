import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Tic Tac Toe',
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool isGameOver = false;
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Tic Tac Toe')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isGameOver
                ? (winner.isEmpty ? 'Draw!' : '$winner Wins!')
                : 'Player: $currentPlayer',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => makeMove(index),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(board[index], style: TextStyle(fontSize: 36)),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(onPressed: resetGame, child: Text('Restart Game')),
        ],
      ),
    );
  }

  void makeMove(int index) {
    if (board[index].isEmpty && !isGameOver) {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner(currentPlayer)) {
          isGameOver = true;
          winner = currentPlayer;
        } else if (!board.contains('')) {
          isGameOver = true; // Draw
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (currentPlayer == 'O') aiMove();
        }
      });
    }
  }

  void aiMove() {
    int bestScore = -999, move = 0;
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        board[i] = 'O';
        int score = minimax(board, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    setState(() {
      board[move] = 'O';
      if (checkWinner('O')) {
        isGameOver = true;
        winner = 'O';
      }
      currentPlayer = 'X';
    });
  }

  int minimax(List<String> newBoard, bool isMaximizing) {
    if (checkWinner('O')) return 1;
    if (checkWinner('X')) return -1;
    if (!newBoard.contains('')) return 0; // Draw

    int bestScore = isMaximizing ? -999 : 999;
    for (int i = 0; i < newBoard.length; i++) {
      if (newBoard[i].isEmpty) {
        newBoard[i] = isMaximizing ? 'O' : 'X';
        int score = minimax(newBoard, !isMaximizing);
        newBoard[i] = '';
        bestScore =
            isMaximizing ? max(bestScore, score) : min(bestScore, score);
      }
    }
    return bestScore;
  }

  bool checkWinner(String player) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];
    for (var pattern in winPatterns) {
      if (pattern.every((index) => board[index] == player)) return true;
    }
    return false;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      isGameOver = false;
      winner = '';
    });
  }
}
