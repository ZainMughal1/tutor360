import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'TutorReportAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';

class TutorReportForm extends StatefulWidget {
  String? victomId;
  TutorReportForm({Key? key, this.victomId}) : super(key: key);

  @override
  State<TutorReportForm> createState() => _TutorReportFormState();
}

class _TutorReportFormState extends State<TutorReportForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final reportC = TextEditingController();
  File? evidanceImg;
  String? reporterName;
  String? victomName;
  bool isLoading = false;
  final _keyForm = GlobalKey<FormState>();

  getReporterName(String uid) async {
    var field;
    await _firestore.collection('TutorData').doc(uid).get().then((value) => {
          field = value.data(),
        });
    reporterName = await field['Name'];
  }

  getVictomName(String uid) async {
    var field;
    await _firestore.collection('StudentData').doc(uid).get().then((value) => {
          field = value.data(),
        });
    victomName = await field['Name'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReporterName(_auth.currentUser!.uid);
    getVictomName(widget.victomId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Report Page"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
              child: Form(
                key: _keyForm,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: reportC,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Write about report";
                        }
                        if (v.length < 5) {
                          return "Write little bit more";
                        }
                      },
                      minLines: 6,
                      maxLines: 10,
                      autofocus: true,
                      decoration: txtDec("What is issue", ""),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);

                        setState(() {
                          evidanceImg = File(pickedFile!.path);
                        });
                      },
                      child: evidanceImg != null
                          ? Image.file(evidanceImg!)
                          : Buttons().b3(() async{
                              final pickedFile = await ImagePicker()
                                  .getImage(source: ImageSource.gallery);

                              setState(() {
                                evidanceImg = File(pickedFile!.path);
                              });
                            }, "Upload Evidance"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Buttons().b1(() {
                      if (_keyForm.currentState!.validate()) {
                        if(evidanceImg==null){
                          Fluttertoast.showToast(msg: "Upload an Evidance Image");
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        TutorReportAuth tutorReportAuth = TutorReportAuth(
                          reportText: reportC.text,
                          evidanceImg: evidanceImg,
                          reporterId: _auth.currentUser!.uid,
                          reporterName: reporterName,
                          victomId: widget.victomId,
                          victomName: victomName,
                        );

                        tutorReportAuth.uploadData();
                      }
                    }, "Report")
                  ],
                ),
              ),
            ),
    );
  }
}
