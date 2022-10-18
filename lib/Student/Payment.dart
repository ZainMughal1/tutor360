import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';
import '../Styles/EditTexts.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final priceC = TextEditingController();
  String tutorUid = Get.arguments;
  final _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2('Jazz Cash Payment'),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image.asset('images/jazz.png'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return "Enter price";
                    }
                    if(int.parse(v) <0){
                      return "price cannot be minus";
                    }
                  },
                  controller: priceC,
                  decoration: txtDec("0.0", "Enter Price"),
                ),
                SizedBox(
                  height: 10,
                ),
                Buttons().b1(() async {
                  if(_keyForm.currentState!.validate()){
                    await jazzPayment(double.parse(priceC.text));
                  }

                }, "Pay Now")
              ],
            ),
          ),
        ),
      ),
    );
  }

  addStudentInClass() async {
    List previousClassStudentsIds = [];
    String stuId = _auth.currentUser!.uid;
    await _firestore
        .collection('/TutorData')
        .doc(tutorUid)
        .get()
        .then((value) => {
              previousClassStudentsIds = value.data()!['Class'],
              print(previousClassStudentsIds),
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
    bool flag = true;
    for (int i = 0; i < previousClassStudentsIds.length; i++) {
      if (previousClassStudentsIds[i] == stuId) {
        flag = false;
        break;
      }
    }
    if (flag == true) {
      previousClassStudentsIds.add(stuId);
      await _firestore
          .collection('TutorData')
          .doc(tutorUid)
          .update({
            'Class': previousClassStudentsIds,
          })
          .then((value) => {
                Fluttertoast.showToast(msg: "Successfully Add in Class"),
              })
          .catchError((e) {
            Fluttertoast.showToast(msg: e);
          });
    } else {
      Fluttertoast.showToast(msg: "Your Already add in Tutor class");
    }
  }

  jazzPayment(double price) async {
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(Duration(days: 1)));
    String tre = "T" + dateandtime;
    int priceInt = price.toInt();
    String pp_Amount = priceInt.toString();
    String pp_BillReference = "billRef";
    String pp_Description = "Fee payment";
    String pp_Language = "EN";
    String pp_MerchantID = "MC44214";
    String pp_Password = "0314xye2t5";

    String pp_ReturnURL =
        "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    String pp_ver = "1.1";
    String pp_TxnCurrency = "PKR";
    String pp_TxnDateTime = dateandtime.toString();
    String pp_TxnExpiryDateTime = dexpiredate.toString();
    String pp_TxnRefNo = tre.toString();
    String pp_TxnType = "MWALLET";
    String ppmpf_1 = "1";
    String ppmpf_2 = "2";
    String ppmpf_3 = "3";
    String ppmpf_4 = "4";
    String ppmpf_5 = "5";
    String IntegeritySalt = "9zv82196w4";
    String and = '&';
    String superdata = IntegeritySalt +
        and +
        pp_Amount +
        and +
        pp_BillReference +
        and +
        pp_Description +
        and +
        pp_Language +
        and +
        pp_MerchantID +
        and +
        pp_Password +
        and +
        pp_ReturnURL +
        and +
        pp_TxnCurrency +
        and +
        pp_TxnDateTime +
        and +
        pp_TxnExpiryDateTime +
        and +
        pp_TxnRefNo +
        and +
        pp_TxnType +
        and +
        pp_ver +
        and +
        ppmpf_1 +
        and +
        ppmpf_2 +
        and +
        ppmpf_3 +
        and +
        ppmpf_4 +
        and +
        ppmpf_5;

    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    String base64Mac = base64.encode(sha256Result.bytes);
    var url = Uri.parse(
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction');
    var response = await http.post(url, body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": pp_Language,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_TxnRefNo": tre,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime": dexpiredate,
      "pp_ReturnURL": pp_ReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": "03237560427",
      "ppmpf_2": "03237560427",
      "ppmpf_3": "03237560427",
      "ppmpf_4": "03237560427",
      "ppmpf_5": "03237560427",
    });

    print("response=>");
    print(response.body);
    print("${pp_Amount}");
    if (response.statusCode == 200) {
      await addStudentInClass();
      Fluttertoast.showToast(
          msg: "Payment Approved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: c1,
          textColor: Colors.white,
          fontSize: 16.0);
      // syncToMysql();
      // UserCredentials();

    } //if
  }
}
