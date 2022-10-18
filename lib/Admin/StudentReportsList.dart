import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';
import '../Styles/TextStyles.dart';

class StudentReportsList extends StatefulWidget {
  const StudentReportsList({Key? key}) : super(key: key);

  @override
  State<StudentReportsList> createState() => _StudentReportsListState();
}

class _StudentReportsListState extends State<StudentReportsList> {
  AdminAuth _adminAuth = AdminAuth();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final messageC = TextEditingController();
  String? victomId;
  NotificationServiceForAdmin _notificationServiceForAdmin = NotificationServiceForAdmin();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Student Reports"),
      body: Container(
              padding: EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('StudentReport').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Something is wrong"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Waiting"),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.docs.map((e) {
                        victomId = e['VictomId'];
                        return InkWell(
                          onTap: () {
                            Get.toNamed('/TutorDetail',
                                arguments: e['VictomId']);
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Report On",
                                    style: txt4,
                                  ),
                                  Text(
                                    e['VictomName'],
                                    style: GoogleFonts.ptSerif(
                                        textStyle: TextStyle(
                                      fontSize: 16,
                                    )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Report By",
                                    style: txt4,
                                  ),
                                  Text(
                                    e['ReporterName'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Reporter Description",
                                    style: txt4,
                                  ),
                                  Text(
                                    e['ReportText'],
                                    style: GoogleFonts.ptSerif(
                                      textStyle: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Reporter Evidance",
                                    style: txt4,
                                  ),
                                  Image.network(e['EvidanceImg']),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: messageC,
                                    decoration: txtDec(
                                        "Message for User", "Message for User"),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Buttons().b2(() {
                                        _notificationServiceForAdmin.sendPushMessage(
                                            messageC.text,
                                            e['VictomId'],
                                            "tutor"
                                        );
                                        _adminAuth.updateMessageForTutor(messageC.text, e['ID'], victomId!);
                                      }, "Take Action", context),
                                      Buttons().b2(() {
                                        _adminAuth.deleteTutorReport(e['ID']);
                                      }, "Delete Report", context),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Center(
                    child: Text("No Reports."),
                  );
                },
              ),
            ),
    );
  }


}
