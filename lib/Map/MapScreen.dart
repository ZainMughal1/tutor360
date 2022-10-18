import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Styles/AppBar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List tutorInfo;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(32.156212575238825, 74.18709888012881),
    zoom: 15,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tutorInfo = Get.arguments;
  }
  @override
  Widget build(BuildContext context) {
    cameraPosition = CameraPosition(
      target: LatLng(tutorInfo[0], tutorInfo[1]),
      zoom: 15,
    );
    return Scaffold(
      appBar: appbar2(tutorInfo[2]),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        markers: {
          Marker(
            markerId: MarkerId(tutorInfo[2]),
            position: LatLng(tutorInfo[0], tutorInfo[1]),
            infoWindow: const InfoWindow(
                title: 'Tutor',
                snippet: 'This is tutor location'),
            icon: BitmapDescriptor.fromBytes(tutorInfo[3]),
          ),

        },

      ),
    );
  }
}
