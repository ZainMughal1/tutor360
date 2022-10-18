import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  String phoneNumber = Get.arguments;
  Buttons b = Buttons();
  File? currentImg;
  String? url;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final nameC = TextEditingController();
  bool isLoading = false;
  final _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar1("Make Profile", () {}),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
        key: _keyForm,
            child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          _showMyDialog(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: c1,
                          child: CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: currentImg != null
                                  ? Image.file(
                                      currentImg!,
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
                            return "Enter Name";
                          }
                          if(v.length>20){
                            return "Name Length Extended.";
                          }
                        },
                        controller: nameC,
                        decoration: txtDec("Name", "Name"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      b.b1(() async {
                        checkValidation();
                      }, "SAVE"),
                    ],
                  ),
                ),
              ),
          ),
    );
  }

  checkValidation(){
    if(_keyForm.currentState!.validate()){
      if(currentImg==null){
        Fluttertoast.showToast(msg: "Profile Image is Missing.");
      }
      else{
        setState(() {
          isLoading = true;
        });
        uploadimg();
      }
    }
  }
  Future uploadimg() async {
    String fileName = basename(currentImg!.path);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final ref = firebaseStorage.ref().child('StudentsProfileImages/$fileName');
    await ref.putFile(currentImg!);
    url = await ref.getDownloadURL();
    setState(() {});
    Fluttertoast.showToast(msg: url.toString());
    dataupload(nameC.text, url!);
  }

  Future dataupload(String name, String url) async {
    List<String> splitList = name.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 1; j <= splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    User? _user = _auth.currentUser;
    _firestore
        .collection("StudentData")
        .doc(_user!.uid)
        .set({
          'Name': name,
          'ProfileImg': url,
          'Name_search_index': indexList,
          'Role': "student",
          'status': true,
          'Report': false,
          'PhoneNumber': phoneNumber,
          'Uid': _user.uid,
          'BlockSMS': "Your Account has blocked because of reports against you.",
          'DeviceToken': "null",
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "SuccessFully Save Data"),
              ofLoading(),
              storeRoleInLocalStorage(),
              Get.offAllNamed('/TutorSearch'),
            })
        .catchError((e) {
          Fluttertoast.showToast(msg: e);
          print("EEERRROORR $e");
        });
  }

  void ofLoading() {
    setState(() {
      isLoading = false;
    });
  }


  void storeRoleInLocalStorage(){
    GetStorage storage = GetStorage();
    storage.write('role', "student");
  }



  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Gallery'),
          content: Text("Choose Location"),
          actions: <Widget>[
            IconButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                  final pickedFile = await ImagePicker()
                      .getImage(source: ImageSource.camera);
                  setState(() {
                    currentImg = File(pickedFile!.path);
                  });
                },
                icon: Icon(Icons.camera_alt)),
            IconButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                  final pickedFile = await ImagePicker()
                      .getImage(source: ImageSource.gallery);
                  setState(() {
                    currentImg = File(pickedFile!.path);
                  });
                },
                icon: Icon(Icons.image)),
          ],
        );
      },
    );
  }
}
