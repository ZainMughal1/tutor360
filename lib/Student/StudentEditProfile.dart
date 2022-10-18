import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Admin/FullScreenImage.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';
import 'package:path/path.dart';

import '../Styles/TextStyles.dart';

class StudentEditProfile extends StatefulWidget {
  const StudentEditProfile({Key? key}) : super(key: key);

  @override
  State<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final nameC = TextEditingController();
  Buttons b = Buttons();
  File? currentImg;
  String? url;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
        msg:
            "Double tap for full Profile Picture View & Single for Edit Picture");
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('StudentData');
    return Scaffold(
      appBar: appbar2("Edit Profile"),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: users.doc(_auth.currentUser!.uid).get(),
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
                              onTap: () async {
                                _showMyDialog(context);
                              },
                              onDoubleTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return FullScreenImage(
                                      imageUrl: data['ProfileImg']);
                                }));
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
                                        : Image.network(
                                            data['ProfileImg'],
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
                            Text(data['PhoneNumber'],style: txt1,),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: nameC,
                              decoration: txtDec(data['Name'], data['Name']),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            b.b1(() async {
                              setState(() {
                                isLoading = true;
                              });
                              if (currentImg == null && nameC.text.isEmpty) {
                                ofLoading();
                                Fluttertoast.showToast(
                                    msg: "Please First Edit Profile");
                              } else if (nameC.text.isEmpty) {
                                uploadimg(data['Name']);
                              } else if (currentImg == null) {
                                dataupdate(nameC.text, data['ProfileImg']);
                              } else {
                                uploadimg(nameC.text);
                              }
                            }, "Update Profile"),
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
  
  Future uploadimg(String name) async {
    String fileName = basename(currentImg!.path);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final ref = firebaseStorage.ref().child('StudentsProfileImages/$fileName');
    await ref.putFile(currentImg!);
    url = await ref.getDownloadURL();
    setState(() {});
    Fluttertoast.showToast(msg: url.toString());
    dataupdate(name, url!);
  }

  Future dataupdate(String name, String url) async {
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
        .update({
          'Name': name,
          'ProfileImg': url,
          'Name_search_index': indexList,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "SuccessFully Save Data"),
              ofLoading(),
              Get.offAllNamed('/TutorSearch'),
            })
        .catchError((e) {
          ofLoading();
          Fluttertoast.showToast(msg: e);
          print("EEERRROORR $e");
        });
  }

  void ofLoading() {
    setState(() {
      isLoading = false;
    });
  }



  Future<void> _showMyDialog(BuildContext context) async {
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
