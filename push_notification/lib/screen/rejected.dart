import 'package:flutter/material.dart';

class Reject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'THIS IS REJECTED  SCREEN',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
