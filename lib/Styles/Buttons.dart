import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Clrs.dart';
import 'Clrs.dart';
class Buttons{
  // Widget b1(onpress, String name){
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: c1,
  //     ),
  //     child: Text(name, style: txtstyle1,),
  //   );
  // }
  Widget b1(onpress, String name){
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 5),
              color: Colors.grey,
              blurRadius: 7,
              ),
        ]
      ),
      child: Material(
        color: c1,
        borderRadius:BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: MaterialButton(
          minWidth: 120,
          onPressed: onpress,
          child: Text(name,style: txtstyle1,),
        ),
      ),
    );
  }


  TextStyle txtstyle1 = GoogleFonts.ptSerif(
    textStyle: TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold
    )
  );


  Widget b2(onpress, String name,context){
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width/6,
      height: 35,
      color: c1,
      onPressed: onpress,
      child: Text(name,style: txtstyle2,),
    );
  }

  TextStyle txtstyle2 = GoogleFonts.ptSerif(
    textStyle: TextStyle(
        fontSize: 15,
        color: Colors.white,

    )
  );

  Widget b3(onpress, String name){
     return ElevatedButton.icon(
       style: ElevatedButton.styleFrom(
         primary: c1
       ),
         onPressed: onpress, icon: Icon(Icons.cloud_upload), label: Text(name));
  }
}