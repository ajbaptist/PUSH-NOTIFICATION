import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:push_notification/detail.dart';
import 'package:push_notification/result.dart';
import 'package:push_notification/token.dart';
import 'package:push_notification/utils.dart';

Utils utils = Utils();

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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Detail()));
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue, icon: '@mipmap/ic_launcher')));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Push Notification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton.icon(
                onPressed: () {
                  showNotification();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Result(name: 'ORDER PLACED SUCCESSFULLY'),
                      ));
                },
                icon: Icon(Icons.notifications),
                label: Text('ORDER NOW')),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
              onPressed: () {
                Get.to(() => Token());
              },
              icon: Icon(Icons.notification_add),
              label: Text('TOKEN BASED NOTIFICATION'))
        ],
      ),
    );
  }
}

showNotification() async {
  FlutterAppBadger.updateBadgeCount(1);
  var android = AndroidNotificationDetails(
      'channelId', 'channelName', 'channelDescription',
      importance: Importance.max,
      playSound: true,
      styleInformation: await styleInfo());
  var ios = IOSNotificationDetails();
  var notifiDetail = NotificationDetails(android: android, iOS: ios);
  await FlutterLocalNotificationsPlugin().show(
      1, 'WOO HOO ORDER PLACED', 'CLICK MORE DETAIL', notifiDetail,
      payload: 'ORDER PLACED SUCESSFULLY');
}

Future styleInfo() async => BigPictureStyleInformation(
    FilePathAndroidBitmap(
        await utils.downloadFile(url: url, filename: 'bigPicture')),
    largeIcon: FilePathAndroidBitmap(
        await utils.downloadFile(url: url, filename: 'largeIcon')));

AndroidNotificationChannel channel =
    AndroidNotificationChannel('1', 'name', 'description');
