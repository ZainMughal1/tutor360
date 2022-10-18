import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Cloud Messaging/NotificationServices.dart';
import '../Styles/Clrs.dart';
class Chat extends StatefulWidget {
  String? chatId;
  Chat({Key? key, this.chatId}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? chatDocId;
  var info = Get.arguments;
  final messageC = TextEditingController();
  final scrollC = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference? chats;
  String? currentUserId;
  String name = "Name";
  String? targeruserid;
  int timeCount = 0;
  getFriendData() async {
    var field;
    if (info[1] == "student") {
      await _firestore
          .collection('TutorData')
          .doc(info[0])
          .get()
          .then((value) => {
                field = value.data(),
              });
    } else {
      await _firestore
          .collection('StudentData')
          .doc(info[0])
          .get()
          .then((value) => {
                field = value.data(),
              });
    }

    setState(() {
      name = field['Name'];
      targeruserid = field['Uid'];
    });
  }

  @override
  void initState() {
    chatDocId = widget.chatId;
    currentUserId = _auth.currentUser!.uid;
    chats = _firestore.collection('Chats');
    getFriendData();
    super.initState();
    print("chat init method called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name,style: GoogleFonts.ptSerif(),),
        backgroundColor: c1,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('Chats')
                        .doc(chatDocId)
                        .collection('Messages')
                        .orderBy('Time', descending: true)
                        .snapshots()
                        .asBroadcastStream(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something Went Wrong.."),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Text("Waiting.."),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
                        return const Center(
                          child: Text("Connection Fail..."),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("Start Chatting.."),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        return ListView(
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          controller: scrollC,
                          children: snapshot.data!.docs.map((e) {
                            return Align(
                              alignment: currentUserId != e['Uid']
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: ConstrainedBox(
                                constraints: BoxConstraints.loose(
                                    Size.fromWidth(
                                        MediaQuery.of(context).size.width)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width-60,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: currentUserId == e['Uid']
                                      ? BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                        )
                                      : BoxDecoration(
                                          color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                        ),
                                  child: Text(
                                    e['Msg'],
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        wordSpacing: 2
                                      ),
                                    ),
                                    // style: TextStyle(
                                    //     color: Colors.black,
                                    //   wordSpacing: 2,
                                    // ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: c1,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(

                    controller: messageC,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: c1),
                        ),
                        fillColor: Colors.white),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                  IconButton(
                    onPressed: () {
                      if (messageC.text.isNotEmpty) {
                        sendMessage(messageC.text);
                      }
                    },
                    icon: const Icon(Icons.send),
                    iconSize: 35,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage(String msg) {
    messageC.text = '';
    chats!.doc(chatDocId).collection('Messages').add({
      'Time': FieldValue.serverTimestamp(),
      'Uid': currentUserId,
      'Msg': msg,
    }).then((value) {
      NotificationServices().sendPushMessage(msg, targeruserid!);
      messageC.text = '';
    });

  }

  // puchToLast() {
  //   if (timeCount <= 0) {
  //     Timer(
  //       const Duration(milliseconds: 100),
  //       () => scrollC.jumpTo(scrollC.position.maxScrollExtent + 10),
  //     );
  //     timeCount++;
  //     puchToLast();
  //   } else {
  //     timeCount = 0;
  //   }
  // }
}
