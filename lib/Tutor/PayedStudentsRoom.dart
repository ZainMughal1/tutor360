import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../Styles/AppBar.dart';
class PayedStudentsRoom extends StatefulWidget {
  const PayedStudentsRoom({Key? key}) : super(key: key);

  @override
  State<PayedStudentsRoom> createState() => _PayedStudentsRoomState();
}

class _PayedStudentsRoomState extends State<PayedStudentsRoom> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  List studentList = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Class Students"),
      body: studentList.isEmpty
          ? Center(
        child: Text("Class is Empty",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),),
      )
          : Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('StudentData')
              .where('Uid', whereIn: studentList)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("snapshot has Error");
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SizedBox(
                  child: Center(
                    child: Text("Waiting"),
                  ),
                );

              case ConnectionState.none:
                return Text("OOps no data present.");
              default:
                return ListView(
                  children: snapshot.data!.docs.map((e) {
                    return InkWell(
                      onTap: () async {
                        try {
                          var chatDocId =
                          await ChatAuth().getDocId(e['Uid']);
                          print("CAt ID >>>>>>>>>>>>>>>>$chatDocId");

                          Get.to(
                              Chat(
                                chatId: chatDocId,
                              ),
                              arguments: [e['Uid'],"tutor"]);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 2),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/StudentDetail',
                                          arguments: e['Uid']);
                                    },
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Colors.blueAccent,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                        AssetImage('images/zain.jpg'),
                                        child: ClipOval(
                                          child: Image.network(
                                            e['ProfileImg'],
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    e['Name'],
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: IconButton(
                                  onPressed: () async {
                                    await deleteStudentFromClass(
                                        e['Uid']);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }

  deleteStudentFromClass(String uid) async {
    List tempList = [];
    await _firestore
        .collection('TutorData')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
      tempList = value.data()!['Class'],
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i] == uid) {
        tempList.removeAt(i);
      }
    }

    await _firestore
        .collection('TutorData')
        .doc(_auth.currentUser!.uid)
        .update({
      'Class': tempList,
    })
        .then((value) => {
      getStudentFromClass(),
      Fluttertoast.showToast(msg: "Successfully Delete Student"),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });

  }

  getStudentFromClass() async {
    await _firestore
        .collection('TutorData').
    doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
      studentList = value.data()!['Class'],
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });

    setState(() {

    });
  }
}


