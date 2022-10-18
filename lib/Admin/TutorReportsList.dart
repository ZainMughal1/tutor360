import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';
import '../Styles/TextStyles.dart';

class TutorReportsList extends StatefulWidget {
  const TutorReportsList({Key? key}) : super(key: key);

  @override
  State<TutorReportsList> createState() => _TutorReportsListState();
}

class _TutorReportsListState extends State<TutorReportsList> {
  AdminAuth _adminAuth = AdminAuth();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final messageC = TextEditingController();
  String? victomId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Tutor Reports"),
      body: Container(
              padding: EdgeInsets.all(5),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('TutorReport').snapshots(),
                builder: (context, snapshot){
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
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("No Reports"),
                    );
                  }
                  if(snapshot.hasData){
                    return ListView(
                      children: snapshot.data!.docs.map((e){
                        victomId = e['VictomId'];
                        return InkWell(
                          onTap: () {
                            Get.toNamed('/StudentDetail',
                                arguments: e['VictomId']);
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Report On",
                                    style: txt4,
                                  ),
                                  Text(
                                    e['VictomName'],
                                    style: TextStyle(fontSize: 20),
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
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Reporter Description",
                                    style: txt4,
                                  ),
                                  Text(
                                    e['ReportText'],
                                    style: TextStyle(fontSize: 20),
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
                                  TextFormField(
                                    validator: (v){
                                      if(v!.isEmpty){
                                        return "Enter Message for User.";
                                      }
                                      if(v.length<50 || v.length>300){
                                        return "Characters should be 50 to 300";
                                      }
                                    },
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
                                        _adminAuth.updateMessageForStudent(messageC.text, e['ID'], victomId!);
                                      }, "Take Action", context),

                                      Buttons().b2(() {
                                        _adminAuth.deleteStudentReport(e['ID']);
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
                  else{
                    return Center(
                      child: Text("No Reports."),
                    );
                  }
                },
              ),
            ),
    );
  }


}



