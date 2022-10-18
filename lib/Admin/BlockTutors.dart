import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cloud Messaging/NotificationServiceForAdmin.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class BlockTutors extends StatefulWidget {
  const BlockTutors({Key? key}) : super(key: key);

  @override
  State<BlockTutors> createState() => _BlockTutorsState();
}

class _BlockTutorsState extends State<BlockTutors> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final fieldC = TextEditingController();
  String? searchString;
  AdminAuth _adminAuth = AdminAuth();
  NotificationServiceForAdmin _notificationServiceForAdmin = NotificationServiceForAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Block Tutors"),
      body: Container(
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
                        ? firestore
                            .collection('TutorData')
                            .where('status', isEqualTo: true)
                            .where('Report', isEqualTo: true)
                            .snapshots()
                        : firestore
                            .collection('TutorData')
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
                                  Get.toNamed('/TutorDetail',
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
                                                      "Wellcome Back Your account has Unblocked now",
                                                      e['Uid'],
                                                      "tutor"
                                                  );
                                                  _adminAuth.UnBlockTutor(e['Uid']);
                                                },
                                                child: Text("Unblock Account")),
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
