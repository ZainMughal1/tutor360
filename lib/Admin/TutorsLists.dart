import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class TutorsList extends StatefulWidget {
  const TutorsList({Key? key}) : super(key: key);

  @override
  State<TutorsList> createState() => _TutorsListState();
}

class _TutorsListState extends State<TutorsList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  final fieldC = TextEditingController();
  String? searchString;
  NotificationServiceForAdmin _notificationServiceForAdmin = NotificationServiceForAdmin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("All Tutors"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                      onChanged: (v) {
                        setState(() {
                          searchString = v.toLowerCase();
                        });
                      },
                      controller: fieldC,
                      decoration: searchtxtDec('Search', 'search', () {
                        fieldC.clear();
                      })),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: (searchString == null || searchString!.trim() == '')
                        ? firestore.collection('TutorData')
                        .where('status', isEqualTo: true)
                        .where('Report', isEqualTo: false)
                        .snapshots()
                        : firestore
                            .collection('TutorData')
                            .where('Name_search_index',
                                arrayContains: searchString)
                            .where('status', isEqualTo: true)
                            .where('Report', isEqualTo: false)
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
                                onTap: () {
                                  print(e['Uid']);
                                  Get.toNamed('/TutorDetail',
                                      arguments: e['Uid']);
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: c1,
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage:
                                                AssetImage('images/zain.jpg'),
                                            child: ClipOval(
                                              child: Image.network(
                                                e['ProfilePic'],
                                                height: 90,
                                                width: 90,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 22,
                                              child: Text(
                                                e['Name'],
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.ptSerif(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    )
                                                ),
                                              ),
                                            ),
                                            TextButton(onPressed: (){
                                              trueReport(e['Uid']);
                                              _notificationServiceForAdmin.sendPushMessage(
                                                  "Your account has Blocked By Admin",
                                                  e['Uid'],
                                                "tutor"
                                              );
                                            }, child: Text("Block Account")),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                      }
                    },
                  )),
                ],
              ),
            ),
    );
  }

  // void CancelAction(String uid) {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference users = firestore.collection('TutorData');
  //   users
  //       .doc(uid)
  //       .delete()
  //       .then((value) => {
  //             Fluttertoast.showToast(msg: "Successfully change stats"),
  //           })
  //       .catchError((e) {
  //     Fluttertoast.showToast(msg: e);
  //   });
  // }
  void trueReport(String uid) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('TutorData');
    users
        .doc(uid)
        .update({
      'Report': true,
      'BlockSMS': "Your Account has been Blocked by Admin.",
    })
        .then((value) => {
      Fluttertoast.showToast(msg: "Successfully change Report status"),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
      setState(() {
        isLoading = false;
      });
    });

    setState(() {
      isLoading = false;
    });
  }
}
