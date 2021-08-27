import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:push_notification/screen/dispatch.dart';
import 'package:push_notification/screen/order_now.dart';
import 'package:push_notification/screen/query.dart';
import 'package:push_notification/screen/rejected.dart';
import 'package:push_notification/token.dart';
import 'package:push_notification/utils.dart';

Utils utils = Utils();

GlobalKey<NavigatorState>? _navigation = GlobalKey(debugLabel: 'BOOKING');

String url =
    'https://www.wigzo.com/blog/wp-content/uploads/2017/08/personalized-push-notifications.jpg';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AndroidFlutterLocalNotificationsPlugin()
      .createNotificationChannel(channel);
  FirebaseMessaging.onBackgroundMessage(firebase);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
}

Future<void> firebase(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("messege data is ${message.messageId}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var init = InitializationSettings(android: android, iOS: ios);
    FlutterLocalNotificationsPlugin().initialize(init,
        onSelectNotification: (payload) async {
      if (payload == 'ORDER') {
        _navigation!.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Order()),
          (Route<dynamic> route) => false,
        );
      } else if (payload == 'QUERY') {
        _navigation!.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Query()),
          (Route<dynamic> route) => false,
        );
      } else if (payload == 'REJECTED') {
        _navigation!.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Reject()),
          (Route<dynamic> route) => false,
        );
      } else {
        _navigation!.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Dispatch()),
          (Route<dynamic> route) => false,
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      var action = message.data['action'];
      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue, icon: '@mipmap/ic_launcher')),
            payload: action!);
        FlutterLocalNotificationsPlugin().initialize(init,
            onSelectNotification: (action) async {
          if (action == 'ORDER') {
            _navigation!.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Order()),
              (Route<dynamic> route) => false,
            );
          }
          if (action == 'QUERY') {
            _navigation!.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Query()),
              (Route<dynamic> route) => false,
            );
          }
          if (action == 'REJECTED') {
            _navigation!.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Reject()),
              (Route<dynamic> route) => false,
            );
          } else {
            _navigation!.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Dispatch()),
              (Route<dynamic> route) => false,
            );
          }
        });
      }
    });
    super.initState();
  }

  // Future future() async {
  //   var response = await FirebaseMessaging.instance.getToken();
  //   setState(() {
  //     string = response;
  //     print(string);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigation,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async => await Get.to(() => Token()),
          child: Icon(Icons.lock),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Push Notification'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    showNotification(goto: 'ORDER');
                  },
                  icon: Icon(Icons.notifications),
                  label: Text('ORDER NOW')),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                onPressed: () {
                  showNotification(goto: 'QUERY');
                },
                icon: Icon(Icons.notifications),
                label: Text('ORDER QUERY')),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  showNotification(goto: 'REJECTED');
                },
                icon: Icon(Icons.notifications),
                label: Text('ORDER REJECTED')),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.purple),
                onPressed: () {
                  showNotification(goto: 'DISPATCHED');
                },
                icon: Icon(Icons.notifications),
                label: Text('ORDER DISPATCHED')),
          ],
        ),
      ),
    );
  }
}

showNotification({required String goto}) async {
  FlutterAppBadger.updateBadgeCount(1);
  var android = AndroidNotificationDetails(
      'channelId', 'channelName', 'channelDescription',
      importance: Importance.max,
      playSound: true,
      styleInformation: await styleInfo());
  var ios = IOSNotificationDetails();
  var notifiDetail = NotificationDetails(android: android, iOS: ios);
  await FlutterLocalNotificationsPlugin().show(
      1, 'BASED ON RECENT ORDER', 'CLICK MORE DETAIL', notifiDetail,
      payload: goto);
}

Future styleInfo() async => BigPictureStyleInformation(
    FilePathAndroidBitmap(
        await utils.downloadFile(url: url, filename: 'bigPicture')),
    largeIcon: FilePathAndroidBitmap(
        await utils.downloadFile(url: url, filename: 'largeIcon')));

AndroidNotificationChannel channel =
    AndroidNotificationChannel('1', 'name', 'description');

// String? string;
// String serverKey =
//     'AAAApOCFnQ8:APA91bE_VU4mIgxzMleHpJPTBXqCvj_rgIg_O0g46tX6TmTaFJKEv6_WH5aBIxHtdafFCjKQuPevAt5wCpoItK4X9g-LUqj-IodIIs7kLos446Ka6V02fqVSQY9BsRi4-eBBiOzb4NRk';
// int serverId = 708141489423;

// Future<void> sendAndRetrieveMessage(
//     {String? token, required String navigation}) async {
//   await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': 'CLICK TO MORE',
//           'title': 'BASED ON YOUR ORDER'
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'action': navigation,
//           'id': '1',
//           'status': 'done'
//         },
//         'to': token,
//       },
//     ),
//   );
// }
