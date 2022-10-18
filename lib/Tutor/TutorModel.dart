import 'package:flutter/material.dart';

class TutorModel {
  String? name,
      description,
      profilepic,
      degreepic,
      idfrontpic,
      idbackpic,
      uid,
      role,
      location,
      phonenumber,
      blocksms,
      deviceToken;

  bool? status, report;
  List? courses, name_index_search,tutoClass;
  double? ratepoint,latitude,longitude;
  TutorModel({
    this.name,
    this.description,
    this.profilepic,
    this.degreepic,
    this.idfrontpic,
    this.idbackpic,
    this.status,
    this.report,
    this.uid,
    this.courses,
    this.name_index_search,
    this.role,
    this.ratepoint,
    this.phonenumber,
    this.blocksms,
    this.location,
    this.tutoClass,
    this.latitude,
    this.longitude,
    this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'ProfilePic': profilepic,
      'Description': description,
      'DegreePic': degreepic,
      'IdBackPic': idbackpic,
      'IdFrontPic': idfrontpic,
      'status': status,
      'Uid': uid,
      'Courses': courses,
      'Name_search_index': name_index_search,
      'Role': role,
      'Report': report,
      'RatePoint': ratepoint,
      'PhoneNumber': phonenumber,
      'BlockSMS': blocksms,
      "Location": location,
      "Class": tutoClass,
      "Latitude": latitude,
      "Longitude": longitude,
      "DeviceToken": deviceToken,
    };
  }
}
