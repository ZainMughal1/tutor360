import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Styles/AppBar.dart';
import '../Styles/TextStyles.dart';

class ShowAppFeedback extends StatefulWidget {
  const ShowAppFeedback({Key? key}) : super(key: key);

  @override
  State<ShowAppFeedback> createState() => _ShowAppFeedbackState();
}

class _ShowAppFeedbackState extends State<ShowAppFeedback> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar1("All Students", (){Get.toNamed('/AdminDashboard');}),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('AppFeedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("snapshot has Error");
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SizedBox(
                child: Center(
                  child: Text("Waiting",style: txt1,),
                ),
              );

            case ConnectionState.none:
              return Text("OOps no data present.",style: txt1,);
            default:
              return ListView(
                children: snapshot.data!.docs.map((e) {
                  return ListTile(
                    title: Text(e['UserName'],style: txt1,),
                    subtitle: Text(e['Feedback'],style: txt1,textAlign: TextAlign.justify,),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
