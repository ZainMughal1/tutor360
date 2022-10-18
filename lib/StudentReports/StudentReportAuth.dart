import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:get/get.dart';
import '../Report/ReportModel.dart';
class StudentReportAuth {
  String? reportText;
  File? evidanceImg;
  String? reporterId;
  String? victomId;
  String? urlEvidanceImg;
  String? reporterName;
  String? victomName;
  StudentReportAuth(
      {this.reportText,
        this.evidanceImg,
        this.reporterId,
        this.victomId,
        this.reporterName,
        this.victomName});

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadData() async {
    urlEvidanceImg = await imgProcess(evidanceImg!);
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
    User? user = FirebaseAuth.instance.currentUser;

    ReportModel reportModel = ReportModel(
      reportText: reportText,
      urlEvidanceImg: urlEvidanceImg,
      reporterId: reporterId,
      victomId: victomId,
      reporterName: reporterName,
      victomName: victomName,
    );

    _firestore.collection('StudentReport').add(reportModel.toMap()).then((value) {
      addId(value.id);
    });
  }

  void addId(String id) {
    _firestore.collection('StudentReport').doc(id).update({
      'ID': id,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Successfully Report submit."),
      Get.back(),
    });
  }
}