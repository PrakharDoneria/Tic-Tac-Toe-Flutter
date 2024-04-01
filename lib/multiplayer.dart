import 'package:flutter/material.dart';

class Multiplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiplayer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Multiplayer Mode',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement Bluetooth functionality here
                // This could include discovering nearby devices, connecting to a device, etc.
              },
              child: Text('Connect to Opponent'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement Bluetooth functionality to start the game when connected
              },
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
