import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Token extends StatefulWidget {
  @override
  _TokenState createState() => _TokenState();
}

class _TokenState extends State<Token> {
  Future future() async {
    var response = await FirebaseMessaging.instance.getToken();
    setState(() {
      string = response;
      print(string);
    });
  }

  String serverKey =
      'AAAApOCFnQ8:APA91bE_VU4mIgxzMleHpJPTBXqCvj_rgIg_O0g46tX6TmTaFJKEv6_WH5aBIxHtdafFCjKQuPevAt5wCpoItK4X9g-LUqj-IodIIs7kLos446Ka6V02fqVSQY9BsRi4-eBBiOzb4NRk';
  int serverId = 708141489423;
  String? string;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => sendAndRetrieveMessage(string!),
          child: Icon(Icons.send)),
      appBar: AppBar(
        title: Text('TOKEN BASED NOTIFICATION'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                future();
              },
              icon: Icon(Icons.notifications_active_rounded),
              label: Text('GET TOKEN'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                controller: _textController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendAndRetrieveMessage(String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _textController.text,
            'title': 'FlutterCloudMessage'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
  }
}
