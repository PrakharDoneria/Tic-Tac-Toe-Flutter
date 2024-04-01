import 'package:flutter/material.dart';
import 'single.dart';
import 'multiplayer.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[900],
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _controller.value == 0.0 ? [Colors.blue.withOpacity(0.7), Colors.blue.withOpacity(0.5)] : [Colors.green.withOpacity(0.7), Colors.green.withOpacity(0.5)],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton('Single Player', SinglePlayer()),
                  SizedBox(height: 20),
                  _buildButton('Multiplayer', Multiplayer()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _controller.value == 0.0 ? Colors.blue : Colors.green,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              _controller.forward().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                ).then((value) => _controller.reverse());
              });
            },
            onLongPress: () {
              _controller.forward().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                ).then((value) => _controller.reverse());
              });
            },
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: _controller.value == 0.0 ? Colors.white : Colors.black),
            ),
          );
        },
      ),
    );
  }
}
