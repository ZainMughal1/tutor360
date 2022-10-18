import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Admin/FullScreenImage.dart';
import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../StudentReports/StudentReportForm.dart';
import '../Styles/Clrs.dart';
import '../Styles/TextStyles.dart';
import '../Tutor/TutorModel.dart';

class TutorDetailForStudent extends StatefulWidget {
  const TutorDetailForStudent({Key? key}) : super(key: key);

  @override
  State<TutorDetailForStudent> createState() => _TutorDetailForStudentState();
}

class _TutorDetailForStudentState extends State<TutorDetailForStudent> {
  TutorModel m = TutorModel();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = Get.arguments;
  String? victomId;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(32.156212575238825, 74.18709888012881),
    zoom: 15,
  );

  Uint8List? markerIcon;
  loadMarkerImage() async {
    markerIcon = await getBytesFromAsset('images/tutor.png', 150);
    print("markerIcon $markerIcon");

    // Future.delayed(Duration(seconds: 1));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMarkerImage();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('TutorData');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: const Text("Tutor Detail"),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  var chatDocId = await ChatAuth().getDocId(uid);
                  print("CAt ID >>>>>>>>>>>>>>>>$chatDocId");

                  Get.to(
                      Chat(
                        chatId: chatDocId,
                      ),
                      arguments: [uid, "student"]);
                } catch (e) {
                  print(e);
                }
              },
              icon: const Icon(Icons.chat))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                  victomId = data['Uid'];
                  cameraPosition = CameraPosition(
                    target: LatLng(data['Latitude'], data['Longitude']),
                    zoom: 15,
                  );
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
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
                              child: Image.network(
                                data['ProfilePic'],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              data['Name'],
                              style: txt1,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            rateFun(data['RatePoint'].toInt(), c1),
                          ],
                        ),
                      ),
                      Divider(),
                      Text(data['Location'].toUpperCase(),style: txt1,),
                      Divider(
                        thickness: 2,
                        height: 40,
                        color: c1,
                      ),
                      Text(
                        data['Description'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Courses:",
                        style: txt1,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: c1, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data['Courses'].length,
                            itemBuilder: (context,index){
                              return Center(child: Text(" ${data['Courses'][index]} ",style: GoogleFonts.ptSerif(textStyle: TextStyle(fontSize: 18)),));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: cameraPosition,
                              markers: <Marker>{
                                Marker(
                                  markerId: MarkerId(data['Name']),
                                  position: LatLng(
                                      data['Latitude'], data['Longitude']),
                                  infoWindow: const InfoWindow(
                                      title: 'Tutor',
                                      snippet: 'This is tutor location'),

                                  icon: markerIcon == null
                                      ? BitmapDescriptor.defaultMarker
                                      : BitmapDescriptor.fromBytes(markerIcon!),
                                  // icon: BitmapDescriptor.fromBytes(markerIcon),
                                  // icon: BitmapDescriptor.defaultMarker,
                                ),
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                List tutorInfo = [];
                                tutorInfo.add(data['Latitude']);
                                tutorInfo.add(data['Longitude']);
                                tutorInfo.add(data['Name']);
                                tutorInfo.add(markerIcon);
                                Get.toNamed('/MapScreen', arguments: tutorInfo);
                              },
                              icon: const Icon(
                                Icons.fullscreen,
                                color: Color(0xFF5E5D5D),
                                size: 40,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration: BoxDecoration(
                            color: c1, borderRadius: BorderRadius.circular(20)),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: firestore
                              .collection('TutorFeedbacks')
                              .where('TutorId', isEqualTo: uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("snapshot has Error");
                            }
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const SizedBox(
                                  child: Center(
                                    child: Text("Waiting"),
                                  ),
                                );
                              case ConnectionState.none:
                                return const Text("OOps no data present.");
                              default:
                                return ListView(
                                  children: snapshot.data!.docs.map((e) {
                                    return ListTile(
                                      title: Text(e['StudentName'],style: GoogleFonts.ptSerif(color: w1),),
                                      subtitle: Text(
                                        e['Feedback'],style: GoogleFonts.ptSerif(color: w1),
                                        textAlign: TextAlign.justify,
                                      ),
                                      trailing: rateFun(e['Rating'], w1),
                                    );
                                  }).toList(),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: (){
                Get.to(StudentReportForm(
                  victomId: victomId,
                ));
              },
              leading: Icon(Icons.report,color: c1,),
              title: Text("Report",style: GoogleFonts.ptSerif(),),
            ),
            ListTile(
              onTap: (){
                Get.toNamed('/FeedbackRatingToTutor', arguments: victomId);
              },
              leading: Icon(Icons.feedback_rounded,color: c1,),
              title: Text("Give Feedback and Rating",style: GoogleFonts.ptSerif(),),
            ),
          ],
        ),
      ),
    );
  }

  Widget rateFun(int count, Color c) {
    return Container(
        child: count == 1
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: c),
                  Icon(Icons.star_border, color: c),
                  Icon(Icons.star_border, color: c),
                  Icon(Icons.star_border, color: c),
                  Icon(Icons.star_border, color: c),
                ],
              )
            : count == 2
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: c),
                      Icon(Icons.star, color: c),
                      Icon(Icons.star_border, color: c),
                      Icon(Icons.star_border, color: c),
                      Icon(Icons.star_border, color: c),
                    ],
                  )
                : count == 3
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: c),
                          Icon(Icons.star, color: c),
                          Icon(Icons.star, color: c),
                          Icon(Icons.star_border, color: c),
                          Icon(Icons.star_border, color: c),
                        ],
                      )
                    : count == 4
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: c),
                              Icon(Icons.star, color: c),
                              Icon(Icons.star, color: c),
                              Icon(Icons.star, color: c),
                              Icon(Icons.star_border, color: c),
                            ],
                          )
                        : count == 5
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: c),
                                  Icon(Icons.star, color: c),
                                  Icon(Icons.star, color: c),
                                  Icon(Icons.star, color: c),
                                  Icon(Icons.star, color: c),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_border, color: c),
                                  Icon(Icons.star_border, color: c),
                                  Icon(Icons.star_border, color: c),
                                  Icon(Icons.star_border, color: c),
                                  Icon(Icons.star_border, color: c),
                                ],
                              ));
  }
}
