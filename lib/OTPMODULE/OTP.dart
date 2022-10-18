import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';

enum FormStateC {
  phoneState,
  otpState,
}

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key}) : super(key: key);

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final phoneC = TextEditingController();
  final otpC = TextEditingController();
  FormStateC currentState = FormStateC.phoneState;
  final _keyScaffold = GlobalKey<ScaffoldState>();
  final _keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Buttons b = Buttons();
  String? verificationId;
  String role = Get.arguments;
  String phoneNumber = "+92";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaffold,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : currentState == FormStateC.phoneState
          ? phoneForm()
          : otpForm(),
    );
  }

// phone form State
  phoneForm() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: phoneC,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v!.isEmpty) {
                    return "Enter Phone Number";
                  }
                  if (v.length < 11 || v.length > 11) {
                    return "Please correct your Number";
                  }
                },
                decoration: txtDec("0345...", "Phone Number"),
              ),
              SizedBox(
                height: 30,
              ),
              b.b1(() async {
                if (_keyForm.currentState!.validate()) {
                  NumberCurrection();
                  setState(() {
                    isLoading = true;
                  });
                  await _auth
                      .verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted: (phoneCredentials) async {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      verificationFailed: (verificationFailed) async {
                        setState(() {
                          isLoading = false;
                        });
                        Get.snackbar("Failed", "Verification Failed.");
                      },
                      codeSent: (verificationId, resedCode) async {
                        setState(() {
                          isLoading = false;
                          this.verificationId = verificationId;
                          currentState = FormStateC.otpState;
                          phoneNumber = "+92";
                        });
                      },
                      codeAutoRetrievalTimeout:
                          (codeAutoRetrievalTimeout) async {})
                      .catchError((e) {
                    print("EEERROORR: $e");
                  });
                }
              }, "SENT"),
            ],
          ),
        ),
      ),
    );
  }

//Otp form state
  otpForm() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: otpC,
                validator: (v) {
                  if (v!.isEmpty) {
                    return "Enter OTP";
                  }
                },
                decoration: txtDec("", "OTP Code"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 30,
              ),
              Buttons().b1((){
                PhoneAuthCredential credentials =
                PhoneAuthProvider.credential(
                    verificationId: verificationId!, smsCode: otpC.text);
                SignInWithPhoneAuthCredentials(credentials);
              }, "VERIFY"),
            ],
          ),
        ),
      ),
    );
  }

  SignInWithPhoneAuthCredentials(PhoneAuthCredential credential) async {
    setState(() {
      isLoading = true;
    });

    try {
      final authCredential = await _auth.signInWithCredential(credential);
      if (authCredential.user != null) {
        if (role == "student") {
          print("Rrrrooolll: $role");
          await CheckStudentStatusIfExist();
        }
        else {
          print("Rrrrooolll: $role");
          await CheckTutorStatusIfExist();
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Failed", "errrorr $e");
    }
  }

  NumberCurrection() {
    String fieldnumber = phoneC.text;
    for (int i = 0; i < fieldnumber.length; i++) {
      if (i != 0) {
        phoneNumber += fieldnumber[i];
      }
    }

    print(phoneNumber);
  }

  CheckTutorStatusIfExist() async {
    final tutorsnapshot =
    await _firestore.collection('TutorData').doc(_auth.currentUser!.uid).get();
    if (tutorsnapshot.exists) {
      GetStorage storage = GetStorage();
      storage.write('role', "tutor");
      Map<String, dynamic> data = tutorsnapshot.data() as Map<String, dynamic>;
      bool report = await data['Report'];
      bool status = await data['status'];

      if (report == true || status == false) {
        Fluttertoast.showToast(msg: "Sorry Your Number Is Blocked Or Admin not Approved your Profile.");
        Get.offAllNamed('/TutorBlock');
      }
      else {
        Get.offAllNamed('/TutorHome');
      }
    }
    else {
      Get.offAllNamed('/TutorProfile', arguments: phoneC.text);
    }
  }

  CheckStudentStatusIfExist() async {
    final studentsnapshot =
    await _firestore.collection('StudentData').doc(_auth.currentUser!.uid).get();
    if (studentsnapshot.exists) {
      GetStorage storage = GetStorage();
      storage.write('role', "student");
      Map<String, dynamic> data = studentsnapshot.data() as Map<String, dynamic>;
      bool report = await data['Report'];
      bool status = data['status'];
      if (report == true || status == false) {
        Fluttertoast.showToast(msg: "Sorry Your Number Is Blocked");
        Get.offAllNamed('/AskRoll');
      }
      else {
        Get.offAllNamed('/TutorSearch');
      }
    }
    else {
      Get.toNamed('/StudentProfile', arguments: phoneC.text);
    }
  }
}
