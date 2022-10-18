import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class BlockStudents extends StatefulWidget {
  const BlockStudents({Key? key}) : super(key: key);

  @override
  State<BlockStudents> createState() => _BlockStudentsState();
}

class _BlockStudentsState extends State<BlockStudents> {
  AdminAuth _adminAuth = AdminAuth();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      appBar: appbar2("Block Students"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        ? _firestore
                            .collection('StudentData')
                            .where('status', isEqualTo: true)
                            .where('Report', isEqualTo: true)
                            .snapshots()
                        : _firestore
                            .collection('StudentData')
                            .where('Name_search_index',
                                arrayContains: searchString)
                            .where('status', isEqualTo: true)
                            .where('Report', isEqualTo: true)
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
                                  Get.toNamed('/StudentDetail',
                                      arguments: e['Uid']);
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
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
                                                e['ProfileImg'],
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e['Name'],
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.ptSerif(
                                                  textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  _notificationServiceForAdmin.sendPushMessage(
                                                      "Wellcome back your account has Unblocked now.",
                                                      e['Uid'],
                                                      "student"
                                                  );
                                                  _adminAuth.UnBlockStudent(e['Uid']);
                                                },
                                                child: Text("Ublock Account")),
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


}
