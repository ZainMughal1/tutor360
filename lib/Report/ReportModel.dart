import 'dart:io';

class ReportModel{
  String? reportText;
  String? reporterId;
  String? victomId;
  String? urlEvidanceImg;
  String? reporterName;
  String? victomName;
  String? id;

  ReportModel({this.reportText,this.urlEvidanceImg,this.reporterId,this.victomId,this.reporterName,this.victomName});

  Map<String,dynamic> toMap(){
    return {
      'ReportText': reportText,
      'EvidanceImg': urlEvidanceImg,
      'ReporterId': reporterId,
      'VictomId': victomId,
      'ReporterName': reporterName,
      'VictomName': victomName,
      'ID': "null",
    };
  }

}