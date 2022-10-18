import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Styles/AppBar.dart';
import '../Styles/TextStyles.dart';
import 'FullScreenImage.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({Key? key}) : super(key: key);

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = Get.arguments;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('StudentData');
    return Scaffold(
      appBar: appbar2("Student Detail"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(uid).get(),
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
                      InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return FullScreenImage(
                                  imageUrl: data['ProfileImg']);
                            }));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              data['ProfileImg'],
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Name: ${data['Name']}",
                        style: txt1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Phone Number: ${data['PhoneNumber']}",
                        style: txt1,
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
