import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cloud Messaging/NotificationServices.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
class TutorBlock extends StatefulWidget {
  const TutorBlock({Key? key}) : super(key: key);

  @override
  State<TutorBlock> createState() => _TutorBlockState();
}

class _TutorBlockState extends State<TutorBlock>{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar4("Message From Admin", () {
        _auth.signOut();
        Get.offAllNamed('/AskRoll');
      }),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('TutorData')
                .doc(_auth.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: Text("Waiting"),
                );
              }
              else if(snapshot.hasData){
                Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AlertRotate(report: data['Report'],),
                    Column(
                      children: [

                        Divider(),
                        Text(
                          data['BlockSMS'],
                          style: GoogleFonts.ptSerif(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: data['Report'] ==true? Colors.redAccent: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed('/TutorEditProfile',
                                  arguments: _auth.currentUser!.uid);
                            },
                            child: Text("Edit Profile",style: TextStyle(
                                fontSize: 17
                            ),)),
                      ],
                    ),
                  ],
                );
              }
              return Center(
                child: Text("lskdjl"),
              );
            },
          ),
        ),
      ),
    );
  }
}



class AlertRotate extends StatefulWidget {
  bool report;
  AlertRotate({Key? key,required this.report}) : super(key: key);
  @override
  State<AlertRotate> createState() => _AlertRotateState();
}

class _AlertRotateState extends State<AlertRotate> with TickerProviderStateMixin{
  late AnimationController _controller;
  late AnimationController _controller1;
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices().initForegroundMessaging();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
    );
    _controller1 = AnimationController(vsync: this,
      duration: Duration(seconds: 10),
      lowerBound: 1,
      upperBound: 13.5,
    );
    _controller.repeat(reverse: true);
    _controller.addListener(() {setState(() {});});
    _controller1.repeat();
    _controller1.addListener(() {setState(() {});});
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    NotificationServices().initBackgroundMessaging();
    NotificationServices().cancleForegroundSubscription();
    _controller1.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: widget.report? _controller.value: _controller1.value,
      child: Icon(widget.report?Icons.notification_important:Icons.access_time_outlined,size: 200,color: c1,),
    );
  }
}
