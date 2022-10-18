
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Clrs.dart';
import 'TextStyles.dart';

Widget imageLabel(String name){
  return Container(
    width: Get.width,
    padding: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
        color: c1,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
    ),
    child: Text(name,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: w1
      ),
    ),
  );
}
AppBar appbar1(String name,backfun){
  return AppBar(
    backgroundColor: c1,
    title: Text(name,style: txt1,),
    leading: IconButton(
      onPressed: backfun,
      icon: Icon(Icons.arrow_back,size: 30,),
    ),
  );
}

AppBar appbar2(String name){
  return AppBar(
    backgroundColor: c1,
    title: Text(name,style: txt1,),
  );
}

AppBar appbar3(String name,fun){
  return AppBar(
    backgroundColor: c1,
    title: Text(name,style: txt1,),
    actions: [
      IconButton(onPressed: fun, icon: Icon(Icons.chat)),
    ],
  );
}
AppBar appbar4(String name,fun){
  return AppBar(
    backgroundColor: c1,
    title: Text(name,style: txt1,),
    actions: [
      IconButton(onPressed: fun, icon: Icon(Icons.logout))
    ],
  );
}
AppBar appbar5(String name,fun){
  return AppBar(
    backgroundColor: c1,
    title: Text(name,style: txt1,),
    actions: [
      IconButton(onPressed: fun, icon: Icon(Icons.edit_rounded)),
    ],
  );
}
