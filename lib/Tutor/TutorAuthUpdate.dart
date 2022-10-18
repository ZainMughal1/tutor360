import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TutorAuthUpdate{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String useruid;
  TutorAuthUpdate({required this.useruid});
  updateName(String name)async{
    List<String> splitList = name.split(" ");
    List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 1; j <= splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    print(indexList);
    await _firestore.collection('TutorData').doc(useruid)
    .update({
      'Name': name,
      'Name_search_index': indexList,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Name Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });

  }//update Name


  updateDescription(String description)async{
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'Description': description,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Description Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });

  }//update Description


  updateProfile(File ProfileImage)async{
    String urlImg = await imgProcess(ProfileImage);
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'ProfilePic': urlImg,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Description Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });

  }//update Description

  updateDegreeImage(File DegreeImage)async{
    String urlImg = await imgProcess(DegreeImage);
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'DegreePic': urlImg,
      'status': false,
      'BlockSMS': "You update your degree so admin will approve your profile",
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Degree Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });

  }//update Description


  updateFrontIdImage(File FrontIdImage)async{
    String urlImg = await imgProcess(FrontIdImage);
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'IdFrontPic': urlImg,
      'status': false,
      'BlockSMS': "You update your Identity card so admin will approve your profile",
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Front Id Image Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });

  }//update Front Id Image

  updateBackIdImage(File backIdImage)async{
    String urlImg = await imgProcess(backIdImage);
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'IdBackPic': urlImg,
      'status': false,
      'BlockSMS': "You update your Identity card so admin will approve your profile",
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Back Id Image Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });

  }//update Back Id Image

  updateCourses(List courses)async{
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'Courses': courses,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully courses Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });
  }
  updateCity(String city)async{
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'Location': city,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully City Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });
  }
  updateLatLon(double latitude, double longitude)async{
    await _firestore.collection('TutorData').doc(useruid)
        .update({
      'Latitude': latitude,
      'Longitude': longitude,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Latitude Longitude Updated."),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });
  }

  Future<String> imgProcess(File img) async {
    String fileimg = basename(img.path);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final ref = firebaseStorage.ref().child('StudentsProfileImages/$fileimg');
    await ref.putFile(img);
    String urlimg = await ref.getDownloadURL();
    return urlimg;
  }

}