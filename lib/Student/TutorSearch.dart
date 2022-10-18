import 'dart:collection';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Admin/FullScreenImage.dart';
import '../Chat/Chat.dart';
import '../Chat/ChatAuth.dart';
import '../Cloud Messaging/NotificationServices.dart';
import '../Styles/AppBar.dart';
import 'dart:math' as math;
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class TutorSearch extends StatefulWidget {
  const TutorSearch({Key? key}) : super(key: key);

  @override
  State<TutorSearch> createState() => _TutorSearchState();
}

class _TutorSearchState extends State<TutorSearch> {
  final  _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;
  final fieldC = TextEditingController();
  RxString searchString = "".obs;
  var searchItems = [
    'Name',
    'Course',
    'Location',
  ];
  String currentValueOfSearch = "Name";
  late double currentLatitude;
  late double currentLongitude;
  Map locationList = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices().initForegroundMessaging();
    isLoading.value = false;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("tutorsearch dispose method callled");
    NotificationServices().initBackgroundMessaging();
    NotificationServices().cancleForegroundSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar3("Search Tutors", () async {
        isLoading.value = true;
        gotoChatbox();
      }),
      body: Obx((){
        return isLoading.value
            ? Center(
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Loading",textStyle: GoogleFonts.ptSerif(
                  textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                )),
              ],
              repeatForever: true,
            ))
            : Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5,0),
              child: Column(
                children: [
                  Row(
                    children: [

                      Expanded(
                        flex: 2,
                        child: TextFormField(
                            onChanged: (v) {
                                searchString.value = v.toLowerCase();
                            },
                            controller: fieldC,
                            decoration: searchtxtDec('Search', 'search', () {
                              fieldC.clear();
                            })),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: DropdownButton(
                          value: currentValueOfSearch,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: c1,
                          ),
                          items: searchItems
                              .map((String e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                              .toList(),
                          onChanged: (var value) {
                              currentValueOfSearch = value.toString();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: (searchString.value == null ||
                            searchString.value.trim() == '' ||
                            searchString.value.isEmpty)
                            ? _firestore
                            .collection('TutorData')
                            .where('Report', isEqualTo: false)
                            .where('RatePoint', isGreaterThan: 3.5)
                            .orderBy('RatePoint', descending: true)
                            .where('status', isEqualTo: true)
                            .snapshots()
                            : currentValueOfSearch == "Name"
                            ? _firestore
                            .collection('TutorData')
                            .where('Name_search_index',
                            arrayContains: searchString.value)
                            .where('Report', isEqualTo: false)
                            .where('status', isEqualTo: true)
                            .snapshots()
                            : currentValueOfSearch == "Course"
                            ? _firestore
                            .collection('TutorData')
                            .where('Courses',
                            arrayContains: searchString.value)
                            .where('Report', isEqualTo: false)
                            .where('status', isEqualTo: true)
                            .snapshots()
                            : currentValueOfSearch == "Location"
                            ? _firestore
                            .collection('TutorData')
                            .where('Location', isEqualTo:searchString.value)
                            .where('Report', isEqualTo: false)
                            .where('status', isEqualTo: true)
                            .snapshots()
                            : _firestore
                            .collection('TutorData')
                            .where('Report', isEqualTo: false)
                            .where('RatePoint', isGreaterThan: 3.5)
                            .where('status', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("snapshot has Error");
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
                                        isLoading.value = true;
                                        var chatDocId =
                                        await ChatAuth().getDocId(e['Uid']);
                                        // print("CAt ID >>>>>>>>>>>>>>>>$chatDocId");
                                        await saveDataInRecommentList(e['Courses']);

                                        Get.to(
                                            Chat(
                                              chatId: chatDocId,
                                            ),
                                            arguments: [e['Uid'],"student"]);
                                        isLoading.value = false;
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Card(
                                      shadowColor: Colors.grey,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async{
                                                    isLoading.value = true;
                                                    await saveDataInRecommentList(e['Courses']);
                                                    print(e['Uid']);
                                                    isLoading.value = false;
                                                    Get.toNamed(
                                                        '/TutorDetailForStudent',
                                                        arguments: e['Uid']);
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 32,
                                                    backgroundColor: c1,
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: AssetImage(
                                                          'images/zain.jpg'),
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
                                                  width: 120,
                                                  height: 25,
                                                  child: Text(
                                                    e['Name'],
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  e['RatePoint'].toString()[0],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Icon(
                                                  Icons.star_rate,
                                                  color: c1,
                                                ),
                                              ],
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
                      )),
                ],
              ),
            ),
            Positioned(
              right: -60,
              top: MediaQuery.of(context).size.height/3,
              child: Transform.rotate(
                angle: math.pi/-2,
                child: GestureDetector(
                  onTap: (){
                    Get.toNamed('/RecommendedTutor');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                        color: c1,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 3,
                            blurRadius: 5,
                          ),
                        ]
                    ),
                    child: Text("Interest Based Tutors",style: GoogleFonts.ptSerif(
                      textStyle: TextStyle(
                        color: w1,
                      ),
                    ),),
                  ),
                ),
              ),
            ),
          ],
        );
      }),



      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 10,),
            FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('StudentData').doc(_auth.currentUser!.uid).get(),
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
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    return FullScreenImage(
                                      imageUrl: data['ProfileImg'],
                                    );
                                  }));
                            },
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: c1,
                              child: CircleAvatar(
                                radius: 53,
                                child: ClipOval(
                                  child: Image.network(
                                    data['ProfileImg'],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 73,
                            left: 79,
                            child: Container(
                              height: 31,
                              width: 31,
                              decoration: BoxDecoration(
                                  color: c1,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: IconButton(
                                  onPressed: (){
                                    Get.toNamed('/StudentEditProfile');
                                  }, icon: Icon(Icons.edit,color: w1,size: 16,)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Text(data['Name'],style: GoogleFonts.ptSerif(),),
                      Text(data['PhoneNumber'],style: GoogleFonts.ptSerif(),),
                      Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 30,),
                    ],
                  );

                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),




            ListTile(
              onTap: (){
                Get.toNamed('/StudentEditProfile');
              },
              leading: Icon(Icons.person,color: c1,),
              title: Text("Edit Profile",style: GoogleFonts.ptSerif(),),
            ),
            ListTile(
              onTap: (){
                _auth.signOut();
                Get.offAllNamed('/AskRoll');
              },
              leading: Icon(Icons.logout,color: c1,),
              title: Text("Logout",style: GoogleFonts.ptSerif(),),
            ),
            Divider(thickness: 2,),
            ListTile(
              onTap: ()async{
                isLoading.value = true;
                gotoChatbox();
              },
              leading: Icon(Icons.message_outlined,color: c1,),
              title: Text("Chatbox",style: GoogleFonts.ptSerif(),),
            ),
            ListTile(
              onTap: ()async{
                await getMyLocation();
                await getUserWithDistance();
              },
              leading: Icon(Icons.location_history,color: c1,),
              title: Text("Tutors near to you",style: GoogleFonts.ptSerif(),),
            ),
            ListTile(
              onTap: ()async{
                Get.toNamed('/RecommendedTutor');
              },
              leading: Icon(Icons.recommend_outlined,color: c1,),
              title: Text("Recommended Tutors",style: GoogleFonts.ptSerif(),),
            ),
            ListTile(
              onTap: (){
                Get.toNamed('/AppFeedback');
              },
              leading: Icon(Icons.feedback,color: c1,),
              title: Text("Give Feedback",style: GoogleFonts.ptSerif(),),
            ),
            ListTile(
              onTap: (){
                Get.toNamed('/AboutUs');
              },
              leading: Icon(Icons.account_balance_outlined,color: c1,),
              title: Text("About Us",style: GoogleFonts.ptSerif(),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: c1,
        child: Icon(Icons.near_me),
        onPressed: ()async{
          await getMyLocation();
          await getUserWithDistance();
        },
      ),
    );
  }

  getMyLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isLocatinEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocatinEnabled) {
      Fluttertoast.showToast(msg: "Location Service in Unable");
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    }
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLatitude = p.latitude;
    currentLongitude = p.longitude;
    print(currentLatitude);
    print(currentLongitude);
  }

  getUserWithDistance() async {
    isLoading.value = true;
    await _firestore.collection('TutorData')
        .where('Report', isEqualTo: false)
        .where('status', isEqualTo: true)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        double distance = Geolocator.distanceBetween(
            currentLatitude,
            currentLongitude,
            element.data()['Latitude'],
            element.data()['Longitude']);

        if(distance<=1100){
          List tempList = [];
          tempList.add(element.data()['Uid']);
          tempList.add(element.data()['ProfilePic']);
          tempList.add(element.data()['Name']);
          tempList.add(element.data()['RatePoint']);
          tempList.add(distance);
          locationList[element.data()['Uid']] = tempList;
        }

      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
    });

    print(locationList);


    var sortedKeys = locationList.keys.toList(growable: false)
      ..sort((k1, k2) =>
          locationList[k1][3]!.compareTo(locationList[k2][3]!));

    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => locationList[k]);

      isLoading.value = false;

    Get.toNamed('/TutorNearest', arguments:  sortedMap);
  }

  gotoChatbox()async{
    List? friends;
    final collection = await _firestore
        .collection('Rooms')
        .doc(_auth.currentUser!.uid)
        .get();
    if (collection.exists) {
      await _firestore
          .collection('Rooms')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {friends = value.data()!['Friends']});
    }
    if (friends != null) {
      isLoading.value = false;
      Get.toNamed('/StudentChatRoom', arguments:friends);
    } else {
      Fluttertoast.showToast(msg: "No Contacts");
    }
  }

  saveDataInRecommentList(List e)async{
    var recommentListData = await GetStorage().read('recommentList');
    List templst = e;
    if(recommentListData == null){
      GetStorage().write('recommentList',templst);
    }
    else{
      for(var t in templst){
        recommentListData.add(t);
      }
      if(recommentListData.length>10){
        int lngth = recommentListData.length;
        lngth = lngth-10;
        recommentListData.removeRange(0, lngth);
      }
      GetStorage().write('recommentList',recommentListData);
    }
    print(GetStorage().read('recommentList'));
    // // print(recommendListData);
  }
}