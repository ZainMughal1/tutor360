import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Cloud Messaging/NotificationServices.dart';
import '../Styles/AppBar.dart';
import '../Styles/TextStyles.dart';

class StudentBlock extends StatefulWidget {
  const StudentBlock({Key? key}) : super(key: key);

  @override
  State<StudentBlock> createState() => _StudentBlockState();
}

class _StudentBlockState extends State<StudentBlock> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices().initForegroundMessaging();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    NotificationServices().initBackgroundMessaging();
    NotificationServices().cancleForegroundSubscription();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('StudentData');
    return Scaffold(
      appBar: appbar4("Your Are Block", (){
        _auth.signOut();
        Get.offAllNamed('/AskRoll');
      }),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(_auth.currentUser!.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasError){
                return Text("Document has error");
              }
              if(snapshot.hasData && !snapshot.data!.exists){
                return Text("Document no Exist");
              }
              if(snapshot.connectionState == ConnectionState.done){
                Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data['BlockSMS'],style: txt1,),

                  ],
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },

          ),
        ),
      ),
    );
  }
}
