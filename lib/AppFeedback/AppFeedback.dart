import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';
import 'AppFeedbackAuth.dart';

class AppFeedback extends StatefulWidget {
  const AppFeedback({Key? key}) : super(key: key);

  @override
  State<AppFeedback> createState() => _AppFeedbackState();
}

class _AppFeedbackState extends State<AppFeedback> {
  final _keyForm = GlobalKey<FormState>();
  final feedbackC = TextEditingController();
  RxBool isLoading = true.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading.value = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Give Feedback"),
      body: Obx((){
        return isLoading == true? Center(child: CircularProgressIndicator(),): Container(
          width: Get.width,
          padding: EdgeInsets.all(10),
          child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: feedbackC,
                    validator: (v){
                      if(v!.isEmpty){
                        return "Please Enter Feedback";
                      }
                      if(v.length>500){
                        return "Maximum 500 character can enter";
                      }
                    },
                    minLines: 6,
                    maxLines: 10,
                    decoration: txtDec("Instruction i.e bug, feature or anything.", "Feedback"),
                  ),
                  SizedBox(height: 20,),
                  Buttons().b1(()async{
                    if(_keyForm.currentState!.validate()){
                      isLoading.value = true;
                      bool result = await AppFeedbackAuth().saveFeedback(feedbackC.text);
                      if(result==false){
                        isLoading.value = false;
                        Fluttertoast.showToast(msg: "Something is wrong.");
                      }
                    }
                  }, "Send"),
                ],
              )
          ),
        );
      }),
    );
  }
}
