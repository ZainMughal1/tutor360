import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class NotificationServices{
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? token;
  String? name;
  String role = GetStorage().read('role');
  Future<void> sendPushMessage(String textMessage,String userid) async {
    print("=>>>>$textMessage");
    if(role == "tutor"){
      await getTargetStudentToken(userid);
    }else{
      await getTargetTutorToken(userid);
    }
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": token,
      "notification": {
        "title": name,
        "body": textMessage,
      },
      "data": {
        "sound": "default",
        "reciverUserId": userid,
        "senderUserId": _auth.currentUser!.uid,
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAVurpigA:APA91bHtB74btqKG1XPIBC2-lpNVs4XlV1Cg-Kw34tVTO6ElzHjzB-BwuUbClS9k60PHC_XQ4bvI5tm-KcfFGvNfMWhf5u25pqxdn6iG1MlAL43VTGq9dUGWjsS0zcGY7TCyqUzc8gS1'
    };
    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
    } else {
      print(' CFM error');
      // on failure do sth
    }
  }
  var backgroundSubscription;
  var foregroundSubscription;
  void initBackgroundMessaging()async{
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetting = InitializationSettings(android: androidInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response){
        print(response.payload);
      },
    );
    var androidDetails = AndroidNotificationDetails(
        "1",
        'Default',
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);
    backgroundSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if(notification !=null && android != null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            generalNotificationDetails);
      }
    });
    if(role == "tutor"){
      await saveTutorToken();
      _messaging.onTokenRefresh.listen((event) {saveTutorToken();});
    }
    else{
      await saveStudentToken();
      _messaging.onTokenRefresh.listen((event) {saveStudentToken();});
    }
  }
  void initForegroundMessaging()async{
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetting = InitializationSettings(android: androidInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response){
        print(response.payload);
      },
    );
    var androidDetails = AndroidNotificationDetails(
        "1",
        'Default',
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);
    foregroundSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      var data = message.data;
      AndroidNotification android = message.notification!.android!;
      if(notification !=null && android != null){
        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     generalNotificationDetails);
        Get.snackbar(notification.title!, notification.body!);
      }
    });
    if(role == "tutor"){
      await saveTutorToken();
      _messaging.onTokenRefresh.listen((event) {saveTutorToken();});
    }
    else{
      await saveStudentToken();
      _messaging.onTokenRefresh.listen((event) {saveStudentToken();});
    }
  }
  cancleBackgroundSubscription(){
    backgroundSubscription.cancle();
  }
  cancleForegroundSubscription(){
    foregroundSubscription.cancle();
  }
  getTargetStudentToken(String userid)async{
    final studentsnapshot = await _firestore.collection('StudentData').doc(userid).get();
    final tutorsnapshot = await _firestore.collection('TutorData').doc(_auth.currentUser!.uid).get();
      Map<String, dynamic> studata = studentsnapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> tutordata = tutorsnapshot.data() as Map<String, dynamic>;
      token =  studata['DeviceToken'];
      name = tutordata['Name'];
  }
  getTargetTutorToken(String userid)async{
    final tutorsnapshot = await _firestore.collection('TutorData').doc(userid).get();
    final studentsnapshot = await _firestore.collection('StudentData').doc(_auth.currentUser!.uid).get();
    Map<String, dynamic> studata = studentsnapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> tutordata = tutorsnapshot.data() as Map<String, dynamic>;
    token =  tutordata['DeviceToken'];
    name = studata['Name'];
  }
  saveTutorToken()async{
    String? deviceToken = await _messaging.getToken();
    _firestore.collection('TutorData').doc(_auth.currentUser!.uid).update({
      'DeviceToken': deviceToken,
    }).catchError((e){
      print("Eerrrorrr in saving device token=> $e ");
    });
  }
  saveStudentToken()async{
    String? deviceToken = await _messaging.getToken();
    _firestore.collection('StudentData').doc(_auth.currentUser!.uid).update({
      'DeviceToken': deviceToken,
    }).catchError((e){
      print("Eerrrorrr in saving device token=> $e ");
    });
  }
}