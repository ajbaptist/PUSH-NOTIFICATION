import 'package:flutter/material.dart';

class Dispatch extends StatefulWidget {
  @override
  _DispatchState createState() => _DispatchState();
}

class _DispatchState extends State<Dispatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'THIS IS DISPATCH SCREEN',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
