import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';
import 'package:geolocator/geolocator.dart';

import 'TutorAuth.dart';
class TutorProfile extends StatefulWidget {
  const TutorProfile({Key? key}) : super(key: key);

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  String phoneNumber = Get.arguments;
  Buttons b = Buttons();
  File? profileImg;
  File? degreeImg;
  File? idFrontImg;
  File? idBackImg;
  final nameC = TextEditingController();
  final desC = TextEditingController();
  bool isLoading = false;
  List<String> courses = [
    "java",
    "c++",
    'kotlin',
    'graphic design',
    'matric',
    'fsc',
    'ics'
  ];
  List tutorClass =[];
  final selectCourses = <String>[].obs;
  bool flag = true;
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
  double? currentLatitude;
  double? currentLongitude;
  final _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: Text("Tutor Profile"),
        actions: [
          TextButton(onPressed: ()async{
            await checkValidation();
          }, child: Text("Next",style: GoogleFonts.ptSerif(
            textStyle: TextStyle(
              color: w1,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),))
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 5,),
                  Text("Just a moment."),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          _showMyDialog(context, "profile");
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: c1,
                          child: CircleAvatar(
                            radius: 53,
                            child: ClipOval(
                              child: profileImg != null
                                  ? Image.file(
                                      profileImg!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'images/zain.jpg',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (v){
                          if(v!.isEmpty){
                            return "Enter Your Name";
                          }
                          if(v.length >20){
                            return "Name length Extended.";
                          }
                        },
                        controller: nameC,
                        decoration: txtDec("Name", "Name"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (v){
                          if(v!.isEmpty){
                            return "Enter Description.";
                          }
                          if(v.length <50 || v.length > 300){
                            return "Description length must be 5o to 300 Characters.";
                          }
                        },
                        controller: desC,
                        minLines: 6,
                        maxLines: 10,
                        decoration: txtDec("Description", "Description"),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: txtDec("Location", "location"),
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
                                Fluttertoast.showToast(msg: "Make sure Your are in City Now.");
                                setState(() {
                                  currentCity = value.toString();
                                });
                              },
                            ),
                          ),
                          IconButton(onPressed: ()async{
                            await getMyLocation();
                          }, icon: Icon(Icons.my_location_rounded,color: c1,)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          _showMyDialog(context, "degree");
                        },
                        child: degreeImg != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(degreeImg!),)
                            : Buttons().b3((){_showMyDialog(context, "degree");}, "Upload Degree")
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          _showMyDialog(context, "frontId");
                        },
                        child: idFrontImg != null
                            ? ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.file(idFrontImg!),)
                            : Buttons().b3((){_showMyDialog(context, "frontId");}, "Upload Front ID Card Image")
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          _showMyDialog(context, "backId");
                        },
                        child: idBackImg != null
                            ? ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.file(idBackImg!),)
                            : Buttons().b3((){_showMyDialog(context, "backId");}, "Upload Back ID Card Image")
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Selected Courses",
                        style: GoogleFonts.ptSerif(
                          textStyle: const TextStyle(
                            fontSize: 30,

                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: c1, width: 2),
                          borderRadius: BorderRadius.circular(10)
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
                ),
              ),
            ),
    );
  }
  checkValidation()async{
    if(_keyForm.currentState!.validate()){
      if(profileImg ==null){
        Fluttertoast.showToast(msg: "Profile Image is Missing!");
      }
      else if(degreeImg ==null){
        Fluttertoast.showToast(msg: "Degree Image is Missing!");
      }
      else if(idFrontImg ==null){
        Fluttertoast.showToast(msg: "Front Id Card Image is Missing!");
      }
      else if(idBackImg==null){
        Fluttertoast.showToast(msg: "Back Id Card Image is Missing!");
      }
      else if(selectCourses == null){
        Fluttertoast.showToast(msg: "Courses are Missing!");
      }
      else if(currentLatitude == null || currentLongitude == null){
        Fluttertoast.showToast(msg: "Current Lucation is Missing!");
      }
      else{
        setState(() {
          isLoading = true;
        });
        TutorAuth tutorauth = TutorAuth(
          TutorName: nameC.text,
          TutorDescription: desC.text,
          location: currentCity,
          courses: selectCourses,
          profileImg: profileImg,
          degreeImg: degreeImg,
          idFrontImg: idFrontImg,
          idBackImg: idBackImg,
          role: "tutor",
          ratePoint: 0.0,
          phoneNumber: phoneNumber,
          blocksms: "Please Wait admin will approve your account as soon as possible.",
          tutorClass: tutorClass,
          latitude: currentLatitude,
          longitude: currentLongitude,
          deviceToken: "null",
        );
        tutorauth.uploadimg();
      }
    }
    else{
      Fluttertoast.showToast(msg: "Something is Wrong.");
    }

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
    if(currentLongitude != null && currentLatitude != null){
      Fluttertoast.showToast(msg: "Your Current Lucation is Saved");
    }
    print(currentLatitude);
    print(currentLongitude);
  }


  Future<void> _showMyDialog(BuildContext context,String imgType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera OR Gallery'),
          content: Text("Choose Location"),
          actions: <Widget>[
            IconButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                  final pickedFile = await ImagePicker()
                      .getImage(source: ImageSource.camera);
                  setState(() {
                    if(imgType == "profile"){
                      profileImg = File(pickedFile!.path);
                    }
                    if(imgType == "degree"){
                      degreeImg = File(pickedFile!.path);
                    }
                    if(imgType == "frontId"){
                      idFrontImg = File(pickedFile!.path);
                    }
                    if(imgType == "backId"){
                      idBackImg = File(pickedFile!.path);
                    }
                  });
                },
                icon: Icon(Icons.camera_alt)),
            IconButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                  final pickedFile = await ImagePicker()
                      .getImage(source: ImageSource.gallery);
                  setState(() {
                    if(imgType == "profile"){
                      profileImg = File(pickedFile!.path);
                    }
                    if(imgType == "degree"){
                      degreeImg = File(pickedFile!.path);
                    }
                    if(imgType == "frontId"){
                      idFrontImg = File(pickedFile!.path);
                    }
                    if(imgType == "backId"){
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
}
