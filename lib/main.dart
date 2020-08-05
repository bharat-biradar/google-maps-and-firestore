import 'dart:collection';

import 'package:dustbin_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'dustbin',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Set<Marker> allmarkers = HashSet<Marker>();
  GoogleMapController _googleMapController;
  BitmapDescriptor icon;
  Database_Service database_service = Database_Service();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dustbin'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: LatLng(26.47064, 73.11449), zoom: 17),
                markers: allmarkers,
              )),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 7,
            right: MediaQuery.of(context).size.width / 20,
            child: InkWell(
              onTap: () {
                updatedata();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black87),
                child: Icon(
                  Icons.refresh,
                  color: Colors.blue,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onMapCreated(GoogleMapController controller) async {
    _googleMapController = controller;
    allmarkers = await database_service.getmarkers();
    setState(() {
      allmarkers;
      print(allmarkers.toString());
    });
  }

  updatedata() async {
    allmarkers = await database_service.updatemarkers();

    setState(() {
      allmarkers;
    });
  }


}
