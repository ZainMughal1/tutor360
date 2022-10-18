import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppFeedbackAuth{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final  role = GetStorage().read('role');
  Future<bool> saveFeedback(String feedback)async{
    String name = await getUserName();
    await _firestore.collection("AppFeedback").add({
      'Userid': _auth.currentUser!.uid,
      'UserName': name,
      'Feedback': feedback,
    }).then((value){
      Fluttertoast.showToast(msg: "Successfull Send Feedback.");
      Get.back();
      return true;
    }).catchError((e){
      print("eeroor ${e.toString()}");
      return false;
    });
    return false;
  }
  Future<String> getUserName()async{
    var field;
    if(role== "tutor"){
      await _firestore.collection('TutorData').doc(_auth.currentUser!.uid).get().then((value) => {
        field = value.data(),
      });
    }
    else{
      await _firestore.collection('StudentData').doc(_auth.currentUser!.uid).get().then((value) => {
        field = value.data(),
      });
    }

    return await field['Name'];
  }
}