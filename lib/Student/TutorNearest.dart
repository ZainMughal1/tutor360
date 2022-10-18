import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/TextStyles.dart';

class TutorNearest extends StatefulWidget {
  const TutorNearest({Key? key}) : super(key: key);

  @override
  State<TutorNearest> createState() => _TutorNearestState();
}

class _TutorNearestState extends State<TutorNearest> {
  Map studentList = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar2("Nearest Tutor to you"),
        body: studentList.length == 0
            ? Center(
                child: Text("Sorry No Tutor In Your Area",style: txt1,),
              )
            : Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5,0),
                child: ListView.builder(
                  itemCount: studentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = studentList.keys.elementAt(index);
                    return Column(
                      children: <Widget>[
                        InkWell(
                          onTap: ()async{
                            try {
                              var chatDocId =
                                  await ChatAuth().getDocId(studentList[key][0]);
                              print("CAt ID >>>>>>>>>>>>>>>>$chatDocId");

                              Get.to(
                                  Chat(
                                    chatId: chatDocId,
                                  ),
                                  arguments: [studentList[key][0],"student"]);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('/TutorDetailForStudent',
                                              arguments: studentList[key][0]);
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
                                                studentList[key][1],
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
                                      Column(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 25,
                                            child: Text(
                                              studentList[key][2].toString(),
                                              style: TextStyle(
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                              "Distance: ${studentList[key][4].toInt()} M"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rate,
                                        color: c1,
                                      ),
                                      Text(
                                        studentList[key][3].toString()[0],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        new Divider(
                          height: 2.0,
                        ),
                      ],
                    );
                  },
                ),
              ));
  }
}

// ListTile(
// title: new Text("${studentList[key][1]}"),
// subtitle: new Text("${studentList[key][2]}"),
// )
