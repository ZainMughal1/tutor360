import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';

class RecommendedTutor extends StatefulWidget {
  const RecommendedTutor({Key? key}) : super(key: key);

  @override
  State<RecommendedTutor> createState() => _RecommendedTutorState();
}

class _RecommendedTutorState extends State<RecommendedTutor> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var recommentList = GetStorage().read('recommentList');

  final fieldC = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(recommentList);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Recommended Tutors"),
      body:  Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5,0),
        child: StreamBuilder<QuerySnapshot>(
          stream:_firestore
              .collection('TutorData')
              .where('Report', isEqualTo: false)
              .where('RatePoint', isGreaterThan: 3.5)
              .where('status', isEqualTo: true)
              .where('Courses', arrayContainsAny: recommentList)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text("snapshot has Error${snapshot.error}");
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox(
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
                          var chatDocId = await ChatAuth().getDocId(e['Uid']);
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
                              Container(
                                width: 150,
                                height: 22,
                                child: Text(
                                  e['Name'],
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
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
      ),
    );
  }
}
