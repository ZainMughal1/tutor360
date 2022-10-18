import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Clrs.dart';

InputDecoration txtDec(String hnt,String labl){
  return InputDecoration(
    alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: c1, width: 1.5),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c1,width: 1.6)
      ),
      border: OutlineInputBorder(),
      hintText: hnt,
      label: Text(labl),
      labelStyle: GoogleFonts.ptSerif(
        textStyle: TextStyle(
            color: c1,
            fontWeight: FontWeight.bold
        )
      )
  );
}


InputDecoration searchtxtDec(String hnt,String labl,suff){
  return InputDecoration(
      suffixIcon:IconButton(
        icon: Icon(Icons.clear,color: c1,),
        onPressed: suff,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: c1, width: 1.5),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c1,width: 1.6)
      ),
      border: OutlineInputBorder(),
      hintText: hnt,
      label: Text(labl),
      labelStyle: GoogleFonts.ptSerif(
          textStyle: TextStyle(
              color: c1,
              fontWeight: FontWeight.bold
          )
      )
  );
}
