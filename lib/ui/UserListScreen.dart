import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat/items/UserItem.dart';
import 'package:chat/model/Choice.dart';
import 'package:chat/model/users.dart';
import 'package:chat/service/DatabaseService%20.dart';
import 'package:chat/service/auth.dart';
import 'package:chat/ui/LoginScreen.dart';
import 'package:chat/ui/SettingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen();

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  AuthService get service => GetIt.I<AuthService>();
  FirebaseMessaging messaging;
  // FlutterLocalNotificationsPlugin fltNotification;

  var document = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid);
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);



  List<Choice> choices = [
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    // notitficationPermission();
    initMessaging();

    messaging.getToken().then((value) {
      print(value);
      document.update({'token': value});
    });

    document.update({'isOnline': true});
    super.initState();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("ttttttt ${message.data.toString()}");
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: message.data['name'],
                body: message.data['message'],
            )
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All User"),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: [
                        Icon(
                          choice.icon,
                          color: Colors.black,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: databaseService.firestoreInstance
              .collection("Users")
              .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text("There is no expense");
            return ListView(children: getExpenseItems(snapshot));
          }),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => Column(
              children: [
                UserItem(
                  userData: UserData(doc.get("uid"), doc.get("name"),
                      doc.get("email"), doc.get("image"), doc.get("isOnline"),doc.get("token")),
                )
              ],
            ))
        .toList();
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      service.signOut();
      Get.off(
        LoginScreen(),
      );
    } else {
      Get.to(SettingScreen());
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'isOnline': false});
    super.dispose();
  }



  void initMessaging() {
    // var androiInit = AndroidInitializationSettings('ic_launcher');
    //
    // var iosInit = IOSInitializationSettings();
    //
    // var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    //
    // fltNotification = FlutterLocalNotificationsPlugin();

    // fltNotification.initialize(initSetting);

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("messsage listen ${message.data} ttttt");
    //   // showNotification();
    //   AwesomeNotifications().createNotification(
    //       content: NotificationContent(
    //           id: 10,
    //           channelKey: 'basic_channel',
    //           title: 'Simple Notification',
    //           body: 'Simple body'
    //       )
    //   );
    // });
  }

  // void showNotification() async {
  //   var androidDetails =
  //   AndroidNotificationDetails('1', 'channelName', 'channel Description');
  //   var iosDetails = IOSNotificationDetails();
  //   var generalNotificationDetails =
  //   NotificationDetails(android: androidDetails, iOS: iosDetails);
  //   await fltNotification.show(0, 'title', 'body', generalNotificationDetails,
  //       payload: 'Notification');
  // }
  //
  // void notitficationPermission() async {
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  // }
}
