import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/TextStyles.dart';
import '../Tutor/TutorModel.dart';
import 'FullScreenImage.dart';

class TutorDetail extends StatefulWidget {
  const TutorDetail({Key? key}) : super(key: key);

  @override
  State<TutorDetail> createState() => _TutorDetailState();
}

class _TutorDetailState extends State<TutorDetail> {
  TutorModel m = TutorModel();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = Get.arguments;
  String? victomId;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('TutorData');
    return Scaffold(
      appBar: appbar5("Tutor Detail", (){
        Get.toNamed('/TutorEditProfile',
            arguments: uid);
      }),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.hasError){
                  return Text("Document has error");
                }
                if(snapshot.hasData && !snapshot.data!.exists){
                  return Text("Document no Exist");
                }
                if(snapshot.connectionState == ConnectionState.done){
                  Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
                  victomId = data['Uid'];
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                                return FullScreenImage(
                                    imageUrl: data['ProfilePic']);
                              }));
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: c1,
                          child: CircleAvatar(
                            radius: 53,
                            child: ClipOval(
                              child: Image.network(data['ProfilePic'],width: 200,height: 200,fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(data['Name'],style: txt1,),
                          Text(data['PhoneNumber'],style: txt1,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text(data['Location'].toUpperCase(),style: txt1,),
                      Divider(),
                      Text("Status",style: txt2,),
                      Text(data['Description'],style: TextStyle(fontSize: 17,),textAlign: TextAlign.justify,),
                      Divider(),
                      SizedBox(height: 10,),
                      Text("Courses:",style: txt2,),
                      Text(data['Courses'].toString(),style: txt1,),
                      Divider(),
                      SizedBox(height: 10,),
                      imageLabel("Degree Image"),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(0,7)
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            color: w1,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: InkWell(
                                  onTap: () async {
                                    Get.to(FullScreenImage(imageUrl: data['DegreePic']));
                                  },
                                  child: Image.network(
                                    data['DegreePic'],
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      imageLabel("ID CARD FRONT"),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(0,7)
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            color: w1,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: InkWell(
                                onTap: () async {
                                  Get.to(FullScreenImage(imageUrl: data['IdFrontPic']));
                                },
                                child: Image.network(
                                  data['IdFrontPic'],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      imageLabel("ID CARD BACK"),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(0,7)
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            color: w1,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: InkWell(
                                onTap: () async {
                                  Get.to(FullScreenImage(imageUrl: data['IdBackPic']));
                                },
                                child: Image.network(
                                  data['IdBackPic'],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },

            ),
          ),
        ),
      ),
    );

  }
}
