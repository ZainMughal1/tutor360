import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Styles/AppBar.dart';
import 'Styles/TextStyles.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("About Us"),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(),
              Text("Developer",textAlign: TextAlign.start,style: txt2),
              Text("Muhammad Zain Afzal",textAlign: TextAlign.end,style: txt3),
              Text("Shams ud Din",textAlign: TextAlign.end,style: txt3),
              Divider(),
              Text("Document Manager",textAlign: TextAlign.start,style: txt2),
              Text("Hamad Naveed",textAlign: TextAlign.end,style: txt3),
              Text("Rana Ali Raza",textAlign: TextAlign.end,style: txt3),
              Divider(),
              Text("Super Adviser",textAlign: TextAlign.start,style: txt2),
              Text("Hamza Sarwar",textAlign: TextAlign.end,style: txt3),
              Divider(),
              Text("Contacts",textAlign: TextAlign.start,style: txt2),
              Text("+923450421875",textAlign: TextAlign.end,style: txt3),
              Text("casualcodetech@gmail.com",textAlign: TextAlign.end,style: txt3),
            ],
          ),
        ),
      ),
    );
  }
}
