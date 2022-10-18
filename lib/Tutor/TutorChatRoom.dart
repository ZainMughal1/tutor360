import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class TutorChatRoom extends StatefulWidget {
  const TutorChatRoom({Key? key}) : super(key: key);

  @override
  State<TutorChatRoom> createState() => _TutorChatRoomState();
}

class _TutorChatRoomState extends State<TutorChatRoom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List? friends = Get.arguments;
  RxString searchString = "".obs;
  final fieldC = TextEditingController();
  RxBool isLoading = true.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading.value = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Chat Room"),
      body: Obx((){
        return isLoading.value? Center(
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Loading",textStyle: GoogleFonts.ptSerif(
                  textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                )),
              ],
              repeatForever: true,
            )):
        Container(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
          child: Column(
            children: [
              TextFormField(
                  onChanged: (v) {
                      searchString.value = v.toLowerCase();
                  },
                  controller: fieldC,
                  decoration: searchtxtDec('Search', 'search', () {
                    fieldC.clear();
                  })),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchString.value == null || searchString.value.trim() == '')
                      ? _firestore
                      .collection('StudentData')
                      .where('Uid', whereIn: friends)
                      .snapshots()
                      : _firestore
                      .collection('StudentData')
                      .where('Name_search_index', arrayContains: searchString.value)
                      .where('Uid', whereIn: friends)
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
                                  isLoading.value = true;
                                  var chatDocId =
                                  await ChatAuth().getDocId(e['Uid']);
                                  print("CAt ID >>>>>>>>>>>>>>>>$chatDocId");
                                  isLoading.value = false;
                                  Get.to(
                                      Chat(
                                        chatId: chatDocId,
                                      ),
                                      arguments: [e['Uid'], "tutor"]);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('/StudentDetailForTutor',
                                              arguments: e['Uid']);
                                        },
                                        child: CircleAvatar(
                                          radius: 32,
                                          backgroundColor: c1,
                                          child: CircleAvatar(
                                            radius:30,
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
                                          fontSize: 19,
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
              )
            ],
          ),
        );
      }),
    );
  }
}
