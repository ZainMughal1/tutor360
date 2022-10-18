import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../Admin/FullScreenImage.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';
import '../Styles/TextStyles.dart';
import 'dart:math' as math;

import 'TutorAuthUpdate.dart';

class TutorEditProfile extends StatefulWidget {
  const TutorEditProfile({Key? key}) : super(key: key);

  @override
  State<TutorEditProfile> createState() => _TutorEditProfileState();
}

class _TutorEditProfileState extends State<TutorEditProfile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String useruid = Get.arguments;
  File? profileImg;
  File? degreeImg;
  File? idFrontImg;
  File? idBackImg;
  final nameC = TextEditingController();
  final desC = TextEditingController();
  List<String> courses = [
    "java",
    "c++",
    'kotlin',
    'UI Design',
    'Matric',
    'FSc',
    'ICs'
  ];
  final selectCourses = <String>[].obs;
  List temp = [];
  bool flag = true;
  bool isLoading = false;
  late TutorAuthUpdate tutorAuthUpdate;
  var cities = [
    'abbotabad',
    'bahawalpur',
    'bhalwal',
    'dera Ismail Khan',
    'faislabad',
    'gwadar',
    'gujranwala',
    'gujrat',
    'hyderabad',
    'islamabad',
    'karachi',
    'khuzdar',
    'kāmoke',
    'kohat',
    'kasur',
    'lahore',
    'larkana',
    'mirpur',
    'mingora',
    'muzaffarabad',
    'mardan',
    'multan',
    'nawabshah',
    'okara',
    'peshawar',
    'quetta',
    'rawalpindi',
    'rahim Yar Khan',
    'sialkot',
    'sargodha',
    'sukkur',
    'sahiwal',
    'turbat',
    'Others',
  ];
  String currentCity = "lahore";
  late String tempCity;
  late double currentLatitude;
  late double currentLongitude;
  late double tempLatitude;
  late double tempLongitude;
  final _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tutorAuthUpdate = TutorAuthUpdate(useruid: useruid);
    Fluttertoast.showToast(msg: "Tap On Image For Edit");
    Fluttertoast.showToast(msg: "Double Tap for Full View Image");
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('TutorData');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: Text("Edit Profile", style: GoogleFonts.ptSerif(),),
        actions: [
          IconButton(
              onPressed: () async {
                List<int> totalTutorRating =await getAllRatingOfTutor();
                print(totalTutorRating);
                if(totalTutorRating.isNotEmpty){
                  Get.toNamed('/TutorRating', arguments:  [totalTutorRating,useruid]);
                }
                else{
                  print("totalTutorRating is empty");
                }
              },
              icon: Icon(Icons.star_half)),
          TextButton(onPressed: (){checkValidation();}, child: Text("Update",style: TextStyle(color: w1),)),
        ],
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: users.doc(useruid).get(),
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
                        selectCourses.clear();
                        temp = data['Courses'];
                        currentCity = data['Location'];
                        tempCity = data['Location'];
                        currentLatitude = data['Latitude'];
                        currentLongitude = data['Longitude'];
                        tempLatitude = data['Latitude'];
                        tempLongitude = data['Longitude'];
                        for (int i = 0; i < temp.length; i++) {
                          selectCourses.add(temp[i]);
                        }
                        return Form(
                          key: _keyForm,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _showMyDialog(context, "profile");
                                },
                                onDoubleTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return FullScreenImage(
                                      imageUrl: data['ProfilePic'],
                                    );
                                  }));
                                },
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: c1,
                                  child: CircleAvatar(
                                    radius: 43,
                                    child: ClipOval(
                                      child: profileImg != null
                                          ? Image.file(
                                              profileImg!,
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
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
                                height: 5,
                              ),
                              Text(
                                data['PhoneNumber'],
                                style: txt1,
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star_half,
                                    color: c1,
                                  ),
                                  Text(data['RatePoint'].toString()[0]),
                                ],
                              ),
                              Divider(),
                              TextFormField(
                                validator: (v) {
                                  if (v!.length > 20) {
                                    return "name length should 4 to 20";
                                  }
                                },
                                controller: nameC,
                                decoration: txtDec(data['Name'], data['Name']),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                validator: (v) {
                                  if (v!.length > 1 && v.length < 30) {
                                    return "Minimum Description should 30 Characters";
                                  }
                                  if (v.length > 300) {
                                    return "Maximum 300 characters";
                                  }
                                },
                                controller: desC,
                                minLines: 3,
                                maxLines: 10,
                                decoration: txtDec(
                                    data['Description'], data['Description']),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField(
                                      decoration:
                                          txtDec("Location", "location"),
                                      isExpanded: true,
                                      value: currentCity,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: c1,
                                      ),
                                      items: cities
                                          .map((String e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (var value) {
                                        currentCity = value.toString();
                                        // setState(() {
                                        //   currentCity = value.toString();
                                        // });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await getMyLocation();
                                      },
                                      icon: Icon(
                                        Icons.my_location_rounded,
                                        color: c1,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              imageLabel("Last Degree"),
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
                                            _showMyDialog(context, "degree");
                                          },
                                          onDoubleTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                                  return FullScreenImage(
                                                    imageUrl: data['DegreePic'],
                                                  );
                                                }));
                                          },
                                          child: degreeImg != null
                                              ? Image.file(degreeImg!)
                                              : Image.network(
                                            data['DegreePic'],
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: InkWell(
                                        onTap: () async {
                                          _showMyDialog(context, "frontId");
                                        },
                                        onDoubleTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return FullScreenImage(
                                              imageUrl: data['IdFrontPic'],
                                            );
                                          }));
                                        },
                                        child: idFrontImg != null
                                            ? Image.file(idFrontImg!)
                                            : Image.network(
                                                data['IdFrontPic'],
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                height: 500,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: InkWell(
                                        onTap: () async {
                                          _showMyDialog(context, "backId");
                                        },
                                        onDoubleTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return FullScreenImage(
                                              imageUrl: data['IdBackPic'],
                                            );
                                          }));
                                        },
                                        child: idBackImg != null
                                            ? Image.file(idBackImg!)
                                            : Image.network(
                                                data['IdBackPic'],
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                height: 500,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Selected Courses:",
                                style: txt1,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: c1, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  height: 60,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    children: [
                                      Obx(
                                        () => Row(
                                          children: selectCourses.map((e) {
                                            return Text(
                                              " $e ",
                                              style: GoogleFonts.ptSerif(textStyle: TextStyle(fontSize: 26)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 250,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 5),

                                    decoration: BoxDecoration(
                                        color: w1,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 8,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      children: courses.map((e) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(c1),
                                          ),
                                          onPressed: () {
                                            for (int i = 0;
                                            i < selectCourses.length;
                                            i++) {
                                              if (selectCourses[i] == e) {
                                                flag = false;
                                                break;
                                              }
                                            }
                                            if (flag == true) {
                                              selectCourses.add(e);
                                            } else {
                                              flag = true;
                                            }
                                          },
                                          child: Text(e,style: GoogleFonts.ptSerif(),),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 9,
                                    child: InkWell(
                                      onTap: (){
                                        if (selectCourses.isNotEmpty) {
                                          selectCourses.removeLast();
                                        }
                                      },
                                      child: Icon(Icons.cancel,size: 30,),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
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

  checkValidation() async {
    if (_keyForm.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      bool flag = false;
      if (selectCourses.length == temp.length) {
        for (int i = 0; i < selectCourses.length; i++) {
          if (selectCourses[i] != temp[i]) {
            flag = true;
            break;
          }
        }
      } else {
        flag = true;
      }
      if (nameC.text.isEmpty &&
          desC.text.isEmpty &&
          profileImg == null &&
          degreeImg == null &&
          idFrontImg == null &&
          idBackImg == null &&
          flag == false &&
          currentCity == tempCity &&
          currentLatitude == tempLatitude &&
          currentLongitude == tempLatitude) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Please Edit Profile");
      }
      if (nameC.text.isNotEmpty) {
        await tutorAuthUpdate.updateName(nameC.text);
      }
      if (desC.text.isNotEmpty) {
        await tutorAuthUpdate.updateDescription(desC.text);
      }
      if (profileImg != null) {
        await tutorAuthUpdate.updateProfile(profileImg!);
      }
      if (degreeImg != null) {
        await tutorAuthUpdate.updateDegreeImage(degreeImg!);
      }
      if (idFrontImg != null) {
        await tutorAuthUpdate.updateFrontIdImage(idFrontImg!);
      }
      if (idBackImg != null) {
        await tutorAuthUpdate.updateBackIdImage(idBackImg!);
      }
      if (flag == true) {
        await tutorAuthUpdate.updateCourses(selectCourses);
      }
      if (tempCity != currentCity) {
        await tutorAuthUpdate.updateCity(currentCity);
      }
      if (currentLatitude != tempLatitude ||
          currentLongitude != tempLongitude) {
        await tutorAuthUpdate.updateLatLon(currentLatitude, currentLongitude);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Something is wrong.");
    }
  } //checkValidation()

  Future<void> _showMyDialog(BuildContext context, String imgType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera OR Gallery'),
          content: Text("Choose Location"),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await ImagePicker().getImage(source: ImageSource.camera);
                  setState(() {
                    if (imgType == "profile") {
                      profileImg = File(pickedFile!.path);
                    }
                    if (imgType == "degree") {
                      degreeImg = File(pickedFile!.path);
                    }
                    if (imgType == "frontId") {
                      idFrontImg = File(pickedFile!.path);
                    }
                    if (imgType == "backId") {
                      idBackImg = File(pickedFile!.path);
                    }
                  });
                },
                icon: Icon(Icons.camera_alt)),
            IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  setState(() {
                    if (imgType == "profile") {
                      profileImg = File(pickedFile!.path);
                    }
                    if (imgType == "degree") {
                      degreeImg = File(pickedFile!.path);
                    }
                    if (imgType == "frontId") {
                      idFrontImg = File(pickedFile!.path);
                    }
                    if (imgType == "backId") {
                      idBackImg = File(pickedFile!.path);
                    }
                  });
                },
                icon: Icon(Icons.image)),
          ],
        );
      },
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
        Fluttertoast.showToast(msg: "Permissio Denied");
      }
    }
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLatitude = p.latitude;
    currentLongitude = p.longitude;
    print(currentLatitude);
    print(currentLongitude);
  }

  Future<List<int>> getAllRatingOfTutor() async {
    List<int> totalRating = [];
    await _firestore
        .collection('TutorFeedbacks')
        .where('TutorId', isEqualTo: useruid)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                totalRating.add(element['Rating']);
              })
            });
    return totalRating;
  }

}
