import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';

class TutorCancel extends StatefulWidget {
  const TutorCancel({Key? key}) : super(key: key);

  @override
  State<TutorCancel> createState() => _TutorCancelState();
}

class _TutorCancelState extends State<TutorCancel> {
  final messageC = TextEditingController();
  bool isLoading = false;
  String tutorId = Get.arguments;
  final _firestore = FirebaseFirestore.instance;
  final _keyForm = GlobalKey<FormState>();
  NotificationServiceForAdmin _notificationServiceForAdmin = NotificationServiceForAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Cancel Tutor"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _keyForm,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Enter Message for User.";
                        }
                        if (v.length < 20 || v.length > 300) {
                          return "Characters should be 20 to 300";
                        }
                      },
                      controller: messageC,
                      decoration:
                          txtDec("Message for Tutor", "Message for Tutor"),
                    ),
                    SizedBox(height: 20,),
                    Buttons().b1(() {
                      if (_keyForm.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        _notificationServiceForAdmin.sendPushMessage(
                            messageC.text,
                            tutorId,
                            "tutor"
                        );
                        updateMessageForUser(messageC.text);
                      }
                    }, "Send"),
                  ],
                ),
              ),
            ),
    );
  }

  updateMessageForUser(String message) async {
    _firestore
        .collection('TutorData')
        .doc(tutorId)
        .update({
          'BlockSMS': message,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Message Sended"),
              Get.back(),
            })
        .catchError((e) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: e);
        });
  }

}
