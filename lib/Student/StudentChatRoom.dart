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

class StudentChatRoom extends StatefulWidget {
  const StudentChatRoom({Key? key}) : super(key: key);

  @override
  State<StudentChatRoom> createState() => _StudentChatRoomState();
}

class _StudentChatRoomState extends State<StudentChatRoom> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List? friends = Get.arguments;
  RxString searchString = ''.obs;
  RxBool isLoading = true.obs;
  final fieldC = TextEditingController();
  @override
  void initState() {
    super.initState();
    isLoading.value = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Chat Room"),
      body:  Obx((){
        return isLoading.value ?Center(
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Loading",textStyle: GoogleFonts.ptSerif(
                  textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                )),
              ],
              repeatForever: true,
            )) :Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
              SizedBox(height: 10,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:(searchString.value == null || searchString.value.trim() == '')
                      ?_firestore
                      .collection('TutorData')
                      .where('Uid', whereIn: friends)
                      .snapshots():
                  _firestore
                      .collection('TutorData')
                      .where('Name_search_index',
                      arrayContains: searchString.value)
                      .where('Uid', whereIn: friends)
                      .snapshots()
                  ,
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
                              onLongPress: (){
                                show_Dialog(e['Uid']);
                              },
                              onTap: () async {
                                try {
                                  isLoading.value = true;
                                  var chatDocId = await ChatAuth().getDocId(e['Uid']);
                                  isLoading.value = false;
                                  Get.to(
                                      Chat(
                                        chatId: chatDocId,
                                      ),
                                      arguments: [e['Uid'],"student"]);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Card(
                                shadowColor: Colors.grey,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('/TutorDetailForStudent',
                                              arguments: e['Uid']);
                                        },
                                        child: CircleAvatar(
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
  show_Dialog(String tutorid){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are You Sure'),
        content: const Text('Delete this chat'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),

        ],
      ),
    );
  }
  
}
