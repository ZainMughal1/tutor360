import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Styles/Buttons.dart';
import '../Styles/Clrs.dart';
class AskRoll extends StatefulWidget {
  const AskRoll({Key? key}) : super(key: key);

  @override
  State<AskRoll> createState() => _AskRollState();
}

class _AskRollState extends State<AskRoll> {
  Buttons buttons = Buttons();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea(
       child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Stack(
               children: [
                 Container(
                   width: 200,
                   height: 200,
                   padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
                   decoration: BoxDecoration(
                       color: c1,
                       borderRadius: BorderRadius.only(bottomRight: Radius.circular(200))
                   ),
                   child: Text("WellCome",
                     style: GoogleFonts.dancingScript(
                       textStyle: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 40,
                           color: Colors.white
                       ),
                     ),
                   ),
                 ),
                 Image.asset('images/man.png'),
                 Positioned(
                   right: 0,
                   child: IconButton(
                       padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                       onPressed: (){
                         Get.toNamed('/AdminLogin');
                       },
                       icon: Icon(
                         Icons.admin_panel_settings_sharp,
                         color: c1,
                         size: 40,
                       )),),
               ],
             ),
             SizedBox(height: 70,),
             Text("Login As",
               textAlign: TextAlign.center,
               style: GoogleFonts.yanoneKaffeesatz(
                 textStyle: TextStyle(
                     fontSize: 40,
                     color: c1,
                     fontWeight: FontWeight.bold

                 ),
               ),),
             SizedBox(height: 40,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 buttons.b1((){
                   Get.toNamed('/OTPVerification',arguments: "student");
                 }, "Student"),
                 buttons.b1((){
                   Get.toNamed('/OTPVerification',arguments:"tutor");
                 }, "Tutor"),
               ],
             ),
           ],
         ),
       ),
     ),
    );
  }

}
// body: Center(
// child: Container(
// padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// Text(
// "I AM",
// style: TextStyle(
// color: c1,
// fontSize: 35,
// fontWeight: FontWeight.bold),
// ),
//
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// buttons.b1(() {
// Get.toNamed('/OTPVerification',arguments: "student");
//
// }, "Student"),
// buttons.b1(() {
// Get.toNamed('/OTPVerification',arguments:"tutor");
// // Get.toNamed('/TutorProfile',arguments:"tutor");
//
// }, "Tutor"),
// ],
// )
// ],
// ),
// ),
// ),