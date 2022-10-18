import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Styles/Clrs.dart';

class WellcomeSearch extends StatelessWidget {
  const WellcomeSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.person_search_outlined,color: c1,size: 150,),
                        SizedBox(height: 20,),
                        Text("Search Tutor By Nearby location, Name, city & by courses",
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
                  Icon(Icons.circle_outlined,size: 15,),
                  Icon(Icons.circle,size: 15,color: c1,),
                  Icon(Icons.circle_outlined,size: 15,),
                  Icon(Icons.circle_outlined,size: 15,),
                  IconButton(onPressed: (){
                    Get.toNamed('/WellcomeSelect');
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
