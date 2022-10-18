import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Cloud Messaging/NotificationServiceForAdmin.dart';

class AdminAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NotificationServiceForAdmin _notificationServiceForAdmin = NotificationServiceForAdmin();

  void updateTutorStatus(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('TutorData');
    users
        .doc(uid)
        .update({
      'status': true,
    })
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully change stats"),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  void DeleteTutor(String uid) {
    CollectionReference users = _firestore.collection('TutorData');
    users
        .doc(uid)
        .delete()
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully change stats"),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }
  void updateStudentReportStatus(String uid,String message) {
    CollectionReference users = _firestore.collection('StudentData');
    users
        .doc(uid)
        .update({
      'Report': true,
      'BlockSMS': message,
    })
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully block Student"),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  updateMessageForStudent(String message,String docId,String victomId)async{

    if (message.isEmpty) {

      Fluttertoast.showToast(msg: "Write a message for Tutor");
    }
    else{
      _notificationServiceForAdmin.sendPushMessage(
          message,
          victomId,
          "student"
      );
      _firestore.collection('StudentData').doc(victomId)
          .update({
        'BlockSMS': message,
      })
          .then((value) => {
        Fluttertoast.showToast(msg: "Update block message"),
        trueStudentReport(victomId,docId),
      })
          .catchError((e){

        Fluttertoast.showToast(msg: e);
      });
    }
  }
  void trueStudentReport(String uid,String docId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('StudentData');
    users
        .doc(uid)
        .update({
      'Report': true,
    })
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully change Report status"),
      deleteStudentReport(docId),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);

    });

  }

  void deleteStudentReport(String id) {
    _firestore
        .collection('TutorReport')
        .doc(id)
        .delete()
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully Delete."),
    })
        .catchError((e) {
      print("EERRoorr>> $e");

    });
  }

  updateMessageForTutor(String message, String docId, String victomId) async {
    if (message.length <= 0) {
      Fluttertoast.showToast(msg: "Write a message for Tutor");
    }
    else {
      _firestore
          .collection('TutorData')
          .doc(victomId)
          .update({
        'BlockSMS': message,
      })
          .then((value) => {
        Fluttertoast.showToast(msg: "Update block message"),
        trueTutorReport(victomId, docId),
      })
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }

  void trueTutorReport(String uid, String docId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('TutorData');
    users
        .doc(uid)
        .update({
      'Report': true,
    })
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully change Report status"),
      deleteTutorReport(docId),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);

    });
  }

  void deleteTutorReport(String id) {
    _firestore.collection('StudentReport').doc(id).delete().then((value) {
      Fluttertoast.showToast(msg: "Successfully Delete.");

    }).catchError((e) {
      print("EERRoorr>> $e");
    });
  }
  void UnBlockTutor(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('TutorData');
    users
        .doc(uid)
        .update({
      'Report': false,
    })
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully change Report status"),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  UnBlockStudent(String uid) async {
    CollectionReference users = _firestore.collection('StudentData');
    users.doc(uid).update({
      'Report': false,
    }).then((value) {
      Fluttertoast.showToast(msg: "Successfully change Report status");
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  Future<bool> login(String email, String password) async{
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value){
      Fluttertoast.showToast(msg: "Login Successfull.");
      Get.offAllNamed('/AdminDashboard');
      return true;
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e.message);
      print("EEERROORR:$e");
      return false;
    });
    return false;
  }

  Future<bool> addAdmin(String email, String password) async{
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
              addAdminCredentials(email, _auth.currentUser!.uid);
              Fluttertoast.showToast(msg: "Successfully Create Admin Account");
              return true;
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    });
    return false;
  }

  addAdminCredentials(String email, String uid) {
    CollectionReference ref = _firestore.collection('AdminData');
    ref
        .doc(uid)
        .set({
          'Email': email,
          'Uid': uid,
          'Role': "admin",
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Successfully Create New Admin"),
              Get.offAllNamed('/AdminDashboard'),
            })
        .catchError((e) {
          Fluttertoast.showToast(msg: e.toString());
        });
  }

  Future<bool> changePassword(
      String email, String oldpassword, String password) async {
    User? user = _auth.currentUser;

    _auth
        .signInWithEmailAndPassword(email: email, password: oldpassword)
        .then((value) => {
              user!
                  .updatePassword(password)
                  .then((value) => {
                        Fluttertoast.showToast(
                            msg: "Change password Succesfully"),
                        Get.offAllNamed('/AdminDashboard'),
                      })
                  .catchError((e) {
                Fluttertoast.showToast(msg: "new Password save has some issue");
              }),
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: "your old password or email is incorrect");
    });
    return false;
  }
}
