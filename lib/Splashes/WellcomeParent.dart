import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../Styles/Clrs.dart';
class WellcomeParent extends StatefulWidget {
  const WellcomeParent({Key? key}) : super(key: key);

  @override
  State<WellcomeParent> createState() => _WellcomeParentState();
}

class _WellcomeParentState extends State<WellcomeParent> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('images/searchtutor.png',
                        color: c1,
                        height: Get.height * 0.4,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("Search Select & Study",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ptSerif(
                      textStyle: TextStyle(
                        fontSize: Get.width *0.1,
                        color: c1,
                      ),
                    ),),
                    SizedBox(height: 30,),
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.circle,size: 15,color: c1,),
                  Icon(Icons.circle_outlined,size: 15,),
                  Icon(Icons.circle_outlined,size: 15,),
                  Icon(Icons.circle_outlined,size: 15,),
                  IconButton(onPressed: (){
                    Get.toNamed('/WellcomeSearch');
                  }, icon: Icon(Icons.chevron_right,size: 30,color: c1,))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
