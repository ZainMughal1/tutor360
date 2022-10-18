import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../Styles/Clrs.dart';
import '../Styles/TextStyles.dart';
import '../TutorReports/TutorReportForm.dart';

class StudentDetailForTutor extends StatefulWidget {
  const StudentDetailForTutor({Key? key}) : super(key: key);

  @override
  State<StudentDetailForTutor> createState() => _StudentDetailForTutorState();
}

class _StudentDetailForTutorState extends State<StudentDetailForTutor> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = Get.arguments;
  String? victomId;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('StudentData');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: Text("Student Details"),
        actions: [
          TextButton(
            onPressed: () async{
              addStudentInClass();
            },
            child: Text(
              "Add to Classroom",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Document has error");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document no Exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  victomId = data['Uid'];
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(data['ProfileImg'],
                            width: MediaQuery.of(context).size.width),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Name: ${data['Name']}",
                        style: txt1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: (){
                Get.to(TutorReportForm(
                  victomId: victomId,
                ));
              },
              title: Text("Report",style: txt4),
              leading: Icon(Icons.report,color: c1,),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            var chatDocId = await ChatAuth().getDocId(uid);
            print("CAt ID >>>>>>>>>>>>>>>>$chatDocId");

            Get.to(
                Chat(
                  chatId: chatDocId,
                ),
                arguments: [uid,"tutor"]);
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.chat),
        backgroundColor: c1,
      ),
    );
  }

  addStudentInClass() async {
    List previousClassStudentsIds = [];
    await _firestore
        .collection('/TutorData')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
      previousClassStudentsIds = value.data()!['Class'],
      print(previousClassStudentsIds),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
    bool flag = true;
    for (int i = 0; i < previousClassStudentsIds.length; i++) {
      if (previousClassStudentsIds[i] == uid) {
        flag = false;
        break;
      }
    }
    if (flag == true) {
      previousClassStudentsIds.add(uid);
      await _firestore
          .collection('TutorData')
          .doc(_auth.currentUser!.uid)
          .update({
        'Class': previousClassStudentsIds,
      })
          .then((value) => {
        Fluttertoast.showToast(msg: "Successfully Add in Class"),
      })
          .catchError((e) {
        Fluttertoast.showToast(msg: e);
      });
    } else {
      Fluttertoast.showToast(msg: "Your Already add in Tutor class");
    }
  }
}
