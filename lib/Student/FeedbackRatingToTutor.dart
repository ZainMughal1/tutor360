import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class FeedbackRatingToTutor extends StatefulWidget {
  const FeedbackRatingToTutor({Key? key}) : super(key: key);

  @override
  State<FeedbackRatingToTutor> createState() => _FeedbackRatingToTutorState();
}

class _FeedbackRatingToTutorState extends State<FeedbackRatingToTutor> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? studentName;
  String tutorID = Get.arguments;
  Icon icn1 = Icon(Icons.star_border);
  Icon icn2 = Icon(Icons.star_border);
  Icon icn3 = Icon(Icons.star_border);
  Icon icn4 = Icon(Icons.star_border);
  Icon icn5 = Icon(Icons.star_border);
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  int count = 0;
  bool isLoading = false;
  TextEditingController feedbackC = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  List<int> totalRateSum = [];
  double averageOfRating =0;
  int sum=0;
  bool repeatFlag = true;
  String docId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Feedback for Tutor"),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10,left: 5,right: 5),
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _keyForm,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    star1Fun();
                                  },
                                  icon: icn1,
                                  color: c1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    star2Fun();
                                  },
                                  icon: icn2,
                                  color: c1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    star3Fun();
                                  },
                                  icon: icn3,
                                  color: c1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    star4Fun();
                                  },
                                  icon: icn4,
                                  color: c1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    star5Fun();
                                  },
                                  icon: icn5,
                                  color: c1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: feedbackC,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Please Write your Feedback.";
                                } else if (v.length < 50) {
                                  return "Write atleast 50 words.";
                                } else if (v.length > 300) {
                                  return "Only 300 words you can write";
                                }
                              },
                              minLines: 6,
                              maxLines: 10,
                              autofocus: true,
                              decoration: txtDec("Feedback", "Feedback"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Buttons().b1(() async{

                                if (_keyForm.currentState!.validate()){
                                  paymentDoneCheck();
                                }
                            }, "Submit"),
                          ],
                        )),
                  ),
                ),
              ),
            ),
    );
  }


  paymentDoneCheck()async{
    List classStudentIds = [];
    String stuId = _auth.currentUser!.uid;
    await _firestore
        .collection('/TutorData')
        .doc(tutorID)
        .get()
        .then((value) => {
      classStudentIds = value.data()!['Class'],
      print(classStudentIds),
    })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
    bool flag = false;
    for (int i = 0; i < classStudentIds.length; i++) {
      if (classStudentIds[i] == _auth.currentUser!.uid) {
        flag = true;
        break;
      }
    }
    if(flag== true){
      if(count!=0){
        setState(() {
          isLoading = true;
        });
        if(await feedbackResponse()){
          await checkDoubleFeedback();
          if(repeatFlag== true){
            submitFun();
          }
          else{
            await updateFeedback();
          }
        }//if
        else{
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Sorry Your Feedback is Fake");
        }
      }else{
        Fluttertoast.showToast(msg: "Give Rating.");
      }
    }
    else{
      Fluttertoast.showToast(msg: "First get enroll in class.");
    }
  }

  Future<bool> feedbackResponse() async {
    final msg = feedbackC.text;
    var url = Uri.parse("https://fake-review-check.herokuapp.com/");
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      'review': msg,
    });
    var resp = response.body;
    log(resp.toString());
    var decodedJson = json.decode(resp);
    var predictionn = decodedJson['predicted'];
    var responses = jsonDecode(response.body);
    var prediction = responses['result']['predicted'];
    predictionn = prediction.toString();
    print("${predictionn} this the single response");
    if(predictionn == "1"){
      return true;
    }
    else{
      return false;
    }
  } //feedbackResponse

  checkDoubleFeedback()async{
    int docNum = 0;
    await _firestore.collection('TutorFeedbacks').where('TutorId', isEqualTo: tutorID).get()
        .then((value) => {
          value.docs.forEach((element) {
            if(_auth.currentUser!.uid == element['StudentId']){
              docId = value.docs[docNum].reference.id.toString();
              setState(() {
                repeatFlag = false;
              });
              return;
            }
            docNum++;
          })
    }).catchError((e){
      setState(() {
        repeatFlag = false;
      });
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    });
  }
  updateFeedback()async{
    if (count == 0) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Please Give Rating");
    } else {
      await getTutorName();
      await _firestore
          .collection('TutorFeedbacks')
          .doc(docId)
          .update({
        'StudentName': studentName.toString(),
        'StudentId': _auth.currentUser!.uid,
        'TutorId': tutorID.toString(),
        'Feedback': feedbackC.text.toString(),
        'Rating': count.toInt(),
      })
          .then((value)async{
        Fluttertoast.showToast(msg: "Successfully Updated feedback");
        await getAllRatingOfTutor();
        Navigator.pop(context);
      })
          .catchError((e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: e);
      });
    }
  }
  submitFun() async {
    if (count == 0) {
      Fluttertoast.showToast(msg: "Please Give Rating");
    } else {
      await getTutorName();
      await _firestore
          .collection('TutorFeedbacks')
          .add({
            'StudentName': studentName.toString(),
            'StudentId': _auth.currentUser!.uid,
            'TutorId': tutorID.toString(),
            'Feedback': feedbackC.text.toString(),
            'Rating': count.toInt(),
          })
          .then((value)async{
                Fluttertoast.showToast(msg: "Successfully submit feedback");
                await getAllRatingOfTutor();
                Navigator.pop(context);
              })
          .catchError((e) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: e);
          });
    }
  }

  getAllRatingOfTutor()async{
    await _firestore.collection('TutorFeedbacks').where('TutorId', isEqualTo: tutorID).get().then((value) =>
    {
      value.docs.forEach((element) {
        totalRateSum.add(element['Rating']);

      })
    });
    for(int i=0;i<totalRateSum.length;i++){
      // print(totalRateSum[i]);
      sum+=totalRateSum[i];
    }
    averageOfRating = sum/totalRateSum.length;
    // print("sum $sum");
    // print("length ${totalRateSum.length}");
    // print("Average Rating points== $averageOfRating");
    UpdateTutorRating();
  }

  UpdateTutorRating()async{
    await _firestore.collection('TutorData').doc(tutorID)
        .update({
      'RatePoint': averageOfRating,
    }).then((value) => {
      Fluttertoast.showToast(msg: "Updated User Rating Points"),
    }).catchError((e){
      Fluttertoast.showToast(msg: e);
    });
  }
  getTutorName() async {
    await _firestore
        .collection('StudentData')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
              studentName = value.data()!['Name'],
            })
        .catchError((e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error get Tutor Name.");
    });
  }

  void star1Fun() {
    if (star1 == false) {
      setState(() {
        star1 = true;
        icn1 = Icon(Icons.star);
        count = 1;
      });
    } else {
      setState(() {
        star2 = false;
        star3 = false;
        star4 = false;
        star5 = false;
        icn2 = Icon(Icons.star_border);
        icn3 = Icon(Icons.star_border);
        icn4 = Icon(Icons.star_border);
        icn5 = Icon(Icons.star_border);
        count = 1;
      });
    }
  }

  void star2Fun() {
    if (star2 == false) {
      setState(() {
        star1 = true;
        star2 = true;
        icn1 = Icon(Icons.star);
        icn2 = Icon(Icons.star);
        count = 2;
      });
    } else {
      setState(() {
        star3 = false;
        star4 = false;
        star5 = false;
        icn3 = Icon(Icons.star_border);
        icn4 = Icon(Icons.star_border);
        icn5 = Icon(Icons.star_border);
        count = 2;
      });
    }
  }

  void star3Fun() {
    if (star3 == false) {
      setState(() {
        star1 = true;
        star2 = true;
        star3 = true;
        icn1 = Icon(Icons.star);
        icn2 = Icon(Icons.star);
        icn3 = Icon(Icons.star);
        count = 3;
      });
    } else {
      setState(() {
        star4 = false;
        star5 = false;
        icn4 = Icon(Icons.star_border);
        icn5 = Icon(Icons.star_border);
        count = 3;
      });
    }
  }

  void star4Fun() {
    if (star4 == false) {
      setState(() {
        star1 = true;
        star2 = true;
        star3 = true;
        star4 = true;
        icn1 = Icon(Icons.star);
        icn2 = Icon(Icons.star);
        icn3 = Icon(Icons.star);
        icn4 = Icon(Icons.star);
        count = 4;
      });
    } else {
      setState(() {
        star5 = false;
        icn5 = Icon(Icons.star_border);
        count = 4;
      });
    }
  }

  void star5Fun() {
    if (star5 == false) {
      setState(() {
        star1 = true;
        star2 = true;
        star3 = true;
        star4 = true;
        star5 = true;
        icn1 = Icon(Icons.star);
        icn2 = Icon(Icons.star);
        icn3 = Icon(Icons.star);
        icn4 = Icon(Icons.star);
        icn5 = Icon(Icons.star);
        count = 5;
      });
    } else {
      setState(() {});
    }
  }
}
