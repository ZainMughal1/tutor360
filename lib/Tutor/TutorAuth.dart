import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';

import 'TutorModel.dart';

class TutorAuth {
  String TutorName;
  String location;
  String TutorDescription;
  List courses,tutorClass;
  File? profileImg;
  File? degreeImg;
  File? idFrontImg;
  File? idBackImg;
  String? urlProfile;
  String? urlDegree;
  String? urlIdFront;
  String? urlIdBack;
  String? role;
  String? phoneNumber;
  String? blocksms;
  double? ratePoint,latitude,longitude;
  String? deviceToken;
  TutorAuth({
    required this.TutorName,
    required this.TutorDescription,
    required this.courses,
    required this.profileImg,
    required this.degreeImg,
    required this.idFrontImg,
    required this.idBackImg,
    required this.role,
    required this.ratePoint,
    required this.phoneNumber,
    required this.blocksms,
    required this.location,
    required this.tutorClass,
    required this.latitude,
    required this.longitude,
    required this.deviceToken,
  });

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadimg() async {
    urlProfile = await imgProcess(profileImg!);
    urlDegree = await imgProcess(degreeImg!);
    urlIdFront = await imgProcess(idFrontImg!);
    urlIdBack = await imgProcess(idBackImg!);
    //Fluttertoast.showToast(msg: "Get URLs");
    saveData();
  }

  Future<String> imgProcess(File img) async {
    String fileimg = basename(img.path);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final ref = firebaseStorage.ref().child('StudentsProfileImages/$fileimg');
    await ref.putFile(img);
    String urlimg = await ref.getDownloadURL();
    return urlimg;
  }

  Future saveData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    List<String> splitListName = TutorName.split(" ");
    List<String> indexListName = [];
        for (int i = 0; i < splitListName.length; i++) {
      for (int j = 1; j <= splitListName[i].length; j++) {
        indexListName.add(splitListName[i].substring(0, j).toLowerCase());
      }
    }
    TutorModel m = TutorModel(
      name: TutorName,
      description: TutorDescription,
      profilepic: urlProfile,
      degreepic: urlDegree,
      idfrontpic: urlIdFront,
      idbackpic: urlIdBack,
      status: false,
      uid: user!.uid,
      courses: courses,
      name_index_search: indexListName,
      role: role,
      report: false,
      ratepoint: ratePoint,
      phonenumber: phoneNumber,
      blocksms: blocksms,
      location: location,
      tutoClass: tutorClass,
      latitude: latitude,
      longitude: longitude,
      deviceToken: deviceToken,
    );

    firestore
        .collection('TutorData')
        .doc(user.uid)
        .set(m.toMap())
        .then((value) => {
              //Fluttertoast.showToast(msg: "Successfully Save Data."),
              storeRoleInLocalStorage(),
              Get.offAllNamed('/TutorBlock'),
            })
        .catchError((e) {
      print("EERROORR: $e");
    });
  }

  void storeRoleInLocalStorage(){
    GetStorage storage = GetStorage();
    storage.write('role', "tutor");
  }
}
