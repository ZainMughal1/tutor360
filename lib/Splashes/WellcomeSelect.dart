import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../Styles/Clrs.dart';
class WellcomeSelect extends StatelessWidget {
  const WellcomeSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: Column(children: [
                Container(
                  child: Image.asset('images/chattutor.png',
                    height: Get.height * 0.36,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                SizedBox(height: 20,),
                Text("Select Tutor",style: GoogleFonts.ptSerif(
                  textStyle: TextStyle(
                    fontSize: Get.width *0.1,
                    color: c1,
                  ),
                ),),
                Text("view profile, Rating, Feedbacks, location & chat with tutor realtime as well.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSerif(
                    textStyle: TextStyle(
                      fontSize: Get.width *0.07,
                      color: c1,
                    ),
                  ),),
              ],),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.circle_outlined,size: 15,),
                  Icon(Icons.circle_outlined,size: 15,),
                  Icon(Icons.circle,size: 15,color: c1,),
                  Icon(Icons.circle_outlined,size: 15,),
                  IconButton(onPressed: (){
                    Get.toNamed('/WellcomeStudy');
                  }, icon: Icon(Icons.chevron_right,size: 30,color: c1,))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: (){
                    Get.back();
                  }, child: Text("Back")),
                  TextButton(onPressed: (){
                    Get.offAllNamed('/AskRoll');
                  }, child: Text("Skip"))
                ],)
            ],
          ),
        ),
      ),
    );
  }
}
