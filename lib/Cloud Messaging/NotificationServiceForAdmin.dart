import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class NotificationServiceForAdmin{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? token;
  String? name;
  Future<void> sendPushMessage(String textMessage,String userid,String role) async {
    print("=>>>>$textMessage");
    if(role == "tutor"){
      await getTargetTutorToken(userid);
    }else{
      await getTargetStudentToken(userid);
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
        "screen": userid,
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

  getTargetStudentToken(String userid)async{
    final studentsnapshot = await _firestore.collection('StudentData').doc(userid).get();
    Map<String, dynamic> studata = studentsnapshot.data() as Map<String, dynamic>;
    token =  studata['DeviceToken'];
    name = studata['Name'];
  }
  getTargetTutorToken(String userid)async{
    final tutorsnapshot = await _firestore.collection('TutorData').doc(userid).get();
    Map<String, dynamic> tutordata = tutorsnapshot.data() as Map<String, dynamic>;
    token =  tutordata['DeviceToken'];
    name = tutordata['Name'];
  }
}