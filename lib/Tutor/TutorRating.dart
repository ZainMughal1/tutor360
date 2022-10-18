import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Styles/AppBar.dart';
import '../Styles/Clrs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class TutorRating extends StatefulWidget {
  const TutorRating({Key? key}) : super(key: key);

  @override
  State<TutorRating> createState() => _TutorRatingState();
}

class _TutorRatingState extends State<TutorRating> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  dynamic getargData = Get.arguments;
  late String useruid;
  late List<int> totalRating;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  double ones = 0;
  double twos = 0;
  double threes = 0;
  double fours = 0;
  double fives = 0;
  double maxNumber = 0;
  calculateGraphPoints(){
    for(int r in totalRating){
      if(r==1){
        ones++;
      }
      else if(r==2){
        twos++;
      }
      else if(r==3){
        threes++;
      }
      else if(r==4){
        fours++;
      }
      else if(r==5){
        fives++;
      }
    }
    print("one: $ones");
    print("two: $twos");
    print("three: $threes");
    print("four: $fours");
    print("five: $fives");
    data = [
      _ChartData('One', ones),
      _ChartData('Two', twos),
      _ChartData('Three', threes),
      _ChartData('Four', fours),
      _ChartData('Five', fives)
    ];
    if(ones>maxNumber){
      maxNumber = ones;
    }
    if(twos>maxNumber){
      maxNumber = twos;
    }
    if(threes>maxNumber){
      maxNumber = threes;
    }
    if(fours>maxNumber){
      maxNumber = fours;
    }
    if(fives>maxNumber){
      maxNumber = fives;
    }

    maxNumber = maxNumber+10;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalRating = Get.arguments[0];
    useruid = Get.arguments[1];
    print(totalRating);
    _tooltip = TooltipBehavior(enable: true);
    calculateGraphPoints();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("All Rating and Feedbacks"),
      body: Column(
        children: [
          SizedBox(height: 5,),
          Text("Tutor Rating Report",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: c1

          ),),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(minimum: 0, maximum: maxNumber, interval: 1),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Rating : Persons',
                      color: Color.fromRGBO(8, 142, 255, 1))
                ])
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              height: 0,
              thickness: 2,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('TutorFeedbacks')
                    .where('TutorId', isEqualTo: useruid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("snapshot has Error");
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const SizedBox(
                        child: Center(
                          child: Text("Waiting"),
                        ),
                      );
                    case ConnectionState.none:
                      return Text("OOps no data present.");
                    default:
                      return ListView(
                        children: snapshot.data!.docs.map((e) {
                          return ListTile(
                            title: Text(e['StudentName']),
                            subtitle: Text(
                              e['Feedback'],
                              textAlign: TextAlign.justify,
                            ),
                            trailing: rateFun(e['Rating'], c1),
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget rateFun(int count, Color c) {
    return Container(
        child: count == 1
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
          ],
        )
            : count == 2
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
          ],
        )
            : count == 3
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
          ],
        )
            : count == 4
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star_border, color: c),
          ],
        )
            : count == 5
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
            Icon(Icons.star, color: c),
          ],
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
            Icon(Icons.star_border, color: c),
          ],
        ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
