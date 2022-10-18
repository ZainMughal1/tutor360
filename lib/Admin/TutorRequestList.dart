import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';

class TutorRequestList extends StatefulWidget {
  const TutorRequestList({Key? key}) : super(key: key);

  @override
  State<TutorRequestList> createState() => _TutorRequestListState();
}

class _TutorRequestListState extends State<TutorRequestList> {
  NotificationServiceForAdmin _notificationServiceForAdmin =
      NotificationServiceForAdmin();
  AdminAuth _adminAuth = AdminAuth();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Tutors Requests"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
        padding: EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('TutorData')
                    .where('status', isEqualTo: false)
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
                              Get.toNamed('/TutorDetail', arguments: e['Uid']);
                            },
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
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
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          e['Name'],
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.ptSerif(
                                              textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Buttons().b2(() {
                                          Get.toNamed('/TutorCancel',
                                              arguments: e['Uid']);
                                        }, "Instruct", context),
                                        Buttons().b2(() {
                                          _adminAuth.updateTutorStatus(e['Uid']);
                                          _notificationServiceForAdmin
                                              .sendPushMessage(
                                                  "Congratulations Your Account has Approved By Admin.",
                                                  e['Uid'],
                                                  "tutor");
                                        }, "Confirm", context),
                                        Buttons().b2(() {
                                          _adminAuth.DeleteTutor(e['Uid']);
                                          _notificationServiceForAdmin
                                              .sendPushMessage(
                                                  "Sorry Your Account Cannot Approved.",
                                                  e['Uid'],
                                                  "tutor");
                                        }, "Delete", context),
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
                }),
          ),
    );
  }
}
