import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Admin/AdminDashboard.dart';
import '../Admin/FullScreenImage.dart';
import '../Cloud Messaging/NotificationServices.dart';
import '../Styles/AppBar.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../Styles/Clrs.dart';
import '../Styles/TextStyles.dart';

class TutorHome extends StatefulWidget {
  const TutorHome({Key? key}) : super(key: key);

  @override
  State<TutorHome> createState() => _TutorHomeState();
}

class _TutorHomeState extends State<TutorHome> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List studentList;
  RxBool isLoading = true.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading.value = false;
    NotificationServices().initForegroundMessaging();
    Fluttertoast.showToast(msg: "WelCome Back");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("tutorHome dispose method callled");
    NotificationServices().initBackgroundMessaging();
    NotificationServices().cancleForegroundSubscription();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('TutorData');
    return Scaffold(
      appBar: appbar2("Tutor Home Page"),
      body: Obx(() {
        return isLoading.value
            ? Center(
                child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText("Loading",textStyle: GoogleFonts.ptSerif(
                    textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                  )),
                ],
                repeatForever: true,
              ))
            : Container(
                padding: EdgeInsets.all(5),
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    box(
                        'Chat Box',
                        Icon(
                          Icons.message,
                          color: w1,
                        ), () {
                      isLoading.value = true;
                      TutorChats();
                    }),
                    box(
                        'Payed Students',
                        Icon(
                          Icons.class_outlined,
                          color: w1,
                        ), () async {
                      isLoading.value = true;
                      await getStudentFromClass();
                      Get.toNamed('/PayedStudentsRoom', arguments: studentList);
                    }),
                  ],
                ),
              );
      }),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 30, 5, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: users.doc(_auth.currentUser!.uid).get(),
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
                    return Column(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return FullScreenImage(
                                    imageUrl: data['ProfilePic'],
                                  );
                                }));
                              },
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: c1,
                                child: CircleAvatar(
                                  radius: 54,
                                  child: ClipOval(
                                    child: Image.network(
                                      data['ProfilePic'],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 73,
                              left: 79,
                              child: Container(
                                height: 31,
                                width: 31,
                                decoration: BoxDecoration(
                                    color: c1,
                                    borderRadius: BorderRadius.circular(20)),
                                child: IconButton(
                                    onPressed: () {
                                      Get.toNamed('/TutorEditProfile',
                                          arguments: _auth.currentUser!.uid);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: w1,
                                      size: 16,
                                    )),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data['Name'],
                          style: GoogleFonts.ptSerif(),
                        ),
                        Text(
                          data['PhoneNumber'],
                          style: GoogleFonts.ptSerif(),
                        ),
                        Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/TutorEditProfile',
                      arguments: _auth.currentUser!.uid);
                },
                leading: Icon(
                  Icons.settings,
                  color: c1,
                ),
                title: Text("Profile",style: txt1,),
              ),
              ListTile(
                onTap: () async {
                  isLoading.value = true;
                  await getStudentFromClass();
                  Get.toNamed('/PayedStudentsRoom', arguments: studentList);
                },
                leading: Icon(
                  Icons.reduce_capacity,
                  color: c1,
                ),
                title: Text("Payed Students",style: txt1,),
              ),
              ListTile(
                onTap: () {
                  isLoading.value = true;
                  TutorChats();
                },
                leading: Icon(
                  Icons.message_outlined,
                  color: c1,
                ),
                title: Text("Chat",style: txt1,),
              ),
              ListTile(
                onTap: () {
                  _auth.signOut();
                  Get.offAllNamed('/AskRoll');
                },
                leading: Icon(
                  Icons.logout,
                  color: c1,
                ),
                title: Text("Logout",style: txt1,),
              ),
              ListTile(
                onTap: (){
                  Get.toNamed('/AppFeedback');
                },
                leading: Icon(Icons.feedback,color: c1,),
                title: Text("Give Feedback",style: txt1,),
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/AboutUs');
                },
                leading: Icon(
                  Icons.account_balance_outlined,
                  color: c1,
                ),
                title: Text("About Us",style: txt1,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TutorChats() async {
    List? friends;
    final collection =
        await _firestore.collection('Rooms').doc(_auth.currentUser!.uid).get();
    if (collection.exists) {
      await _firestore
          .collection('Rooms')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {friends = value.data()!['Friends']});
    }
    if (friends != null) {
      isLoading.value = false;
      Get.toNamed('/TutorChatRoom', arguments: friends);
    } else {
      Fluttertoast.showToast(msg: "No Contacts");
    }
  } //TutorChats

  getStudentFromClass() async {
    await _firestore
        .collection('TutorData')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
              studentList = value.data()!['Class'],
              isLoading.value = false,
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }
}
