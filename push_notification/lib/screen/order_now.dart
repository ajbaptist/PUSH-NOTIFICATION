import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            'THIS IS ORDER SCREEN',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
