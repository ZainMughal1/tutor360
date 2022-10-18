import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/EditTexts.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  AdminAuth _adminAuth = AdminAuth();
  final fieldC = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? searchString;
  NotificationServiceForAdmin _notificationServiceForAdmin = NotificationServiceForAdmin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar1("All Students", (){Get.toNamed('/AdminDashboard');}),
      body: Container(
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
                  ? firestore.collection('StudentData')
                  .where('status', isEqualTo: true)
                  .where('Report', isEqualTo: false)
                  .snapshots()
                  : firestore
                      .collection('StudentData')
                      .where('Name_search_index', arrayContains: searchString)
                      .where('status', isEqualTo: true)
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
                            Get.toNamed('/StudentDetail',arguments: e['Uid']);
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.only(left: 10,top: 2,right: 10,bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.blueAccent,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage('images/zain.jpg'),
                                      child: ClipOval(
                                        child: Image.network(e['ProfileImg'],height: 90,width: 90,fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(e['Name'],style: GoogleFonts.ptSerif(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )
                                      ),),
                                      SizedBox(height: 10,),
                                      TextButton(onPressed: (){
                                        _notificationServiceForAdmin.sendPushMessage(
                                            "Your account has Blocked by admin.",
                                            e['Uid'],
                                            "student"
                                        );
                                        _adminAuth.updateStudentReportStatus(e['Uid'],"Your account has Blocked by admin.");
                                      }, child: Text("Block Account",style: GoogleFonts.ptSerif(fontSize: 16),)),
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
              },
            )),
          ],
        ),
      ),
    );
  }


}
