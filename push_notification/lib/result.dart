import 'package:flutter/material.dart';
import 'package:push_notification/detail.dart';
import 'package:push_notification/main.dart';

final style =
    TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);

class Result extends StatelessWidget {
  final String? name;
  Result({required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(name!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WOOO HOOO',
              style: style,
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.done,
                  size: 80,
                  color: Colors.green,
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              'ORDER PLACED SUCCESSFULLY',
              textAlign: TextAlign.center,
              style: style,
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                },
                icon: Icon(Icons.home),
                label: Text('HOME')),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(),
                      ));
                },
                icon: Icon(Icons.store_mall_directory),
                label: Text('ORDER DETAIL')),
          ],
        ),
      ),
    );
  }
}
