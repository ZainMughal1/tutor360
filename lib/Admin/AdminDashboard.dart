import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/TextStyles.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Admin Dashboard"),
      drawer: Drawer(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Get.toNamed('/AddNewAdmin');
                },
                leading: Icon(Icons.person_add_alt_1_rounded),
                title: Text(
                  "Add new admin",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/ChangePassword');
                },
                leading: Icon(Icons.manage_accounts),
                title: Text(
                  "Change password",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  _auth.signOut();
                  Get.offAllNamed('/AskRoll');
                },
                leading: Icon(Icons.logout),
                title: Text(
                  "Logout",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              Divider(height: 30, thickness: 2),
              ListTile(
                onTap: () {
                  Get.toNamed('/TutorRequestList');
                },
                leading: Icon(Icons.list),
                title: Text(
                  "Requests",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/TutorsList');
                },
                leading: Icon(Icons.man),
                title: Text(
                  "Tutors",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/StudentList');
                },
                leading: Icon(Icons.reduce_capacity),
                title: Text(
                  "Students",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/StudentReportsList');
                },
                leading: Icon(Icons.report),
                title: Text(
                  "Student's Reports",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/TutorReportsList');
                },
                leading: Icon(Icons.report),
                title: Text(
                  "Tutor's Reports",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/BlockTutors');
                },
                leading: Icon(Icons.block),
                title: Text(
                  "Block Tutors",
                  style: txt1,
                ),
                iconColor: c1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/BlockStudents');
                },
                leading: Icon(Icons.block),
                title: Text(
                  "Block Students",
                  style: txt1,
                ),
                iconColor: c1,
              ),

            ],
          ),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          box(
              'Tutors',
              Icon(
                Icons.man,
                color: w1,
              ), () {
            Get.toNamed('/TutorsList');
          }),
          box(
              'Students',
              Icon(
                Icons.reduce_capacity,
                color: w1,
              ), () {
            Get.toNamed('/StudentList');
          }),
          box(
              'Requests',
              Icon(
                Icons.list,
                color: w1,
              ), () {
            Get.toNamed('/TutorRequestList');
          }),
          box(
              "Student's Reports",
              Icon(
                Icons.report,
                color: w1,
              ), () {
            Get.toNamed('/StudentReportsList');
          }),
          box(
              'Tutor Reports',
              Icon(
                Icons.report,
                color: w1,
              ), () {
            Get.toNamed('/TutorReportsList');
          }),
          box(
              'Block Tutors',
              Icon(
                Icons.block,
                color: w1,
              ), () {
            Get.toNamed('/BlockTutors');
          }),
          box(
              'Block Students',
              Icon(
                Icons.block,
                color: w1,
              ), () {
            Get.toNamed('/BlockStudents');
          }),

          box(
              'App Feedbacks',
              Icon(
                Icons.feedback,
                color: w1,
              ), () {
            Get.toNamed('/ShowAppFeedback');
          }),
        ],
      ),
    );
  }
}

Widget box(String name, Icon icn, fun) {
  return InkWell(
    onTap: fun,
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: c1,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2),
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 1),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icn,
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.ptSerif(
                textStyle: TextStyle(
              color: w1,
            )),
          )
        ],
      ),
    ),
  );
}