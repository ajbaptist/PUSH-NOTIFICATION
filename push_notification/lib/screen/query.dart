import 'package:flutter/material.dart';

class Query extends StatelessWidget {
  const Query({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'THIS IS QUERY SCREEN',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
