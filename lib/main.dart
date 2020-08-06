import 'dart:collection';

import 'package:dustbin_project/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'views/navigation.dart';

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
    getpermission();
  }

  getpermission() async{
    print("asking locayions");
    var status= await Permission.location.status;
    if(status.isUndetermined){
      await Permission.location.request();
    }else if(status.isGranted){
      return;
    }else if(status.isPermanentlyDenied){
      await openAppSettings();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: LatLng(26.47064, 73.11449), zoom: 17),
                markers: allmarkers,
              )),
          Positioned(
            top: MediaQuery.of(context).size.height / 12,
            right: MediaQuery.of(context).size.width / 20,
            child: IconButton(
              icon: Icon(
                Icons.my_location,
                color: Colors.blueAccent,
                size: 35,
              ),
//              onPressed: showmylocation(),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 18,
            left: MediaQuery.of(context).size.width / 20,
            child: InkWell(
              onTap: () {
                updatedata();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: Icon(
                  Icons.refresh,
                  color: Colors.blue,
                  size: 35,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 7,
            right: MediaQuery.of(context).size.width / 50,
            child: InkWell(
              onTap: (){openmapbox(context);},
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50)

                ),
                child:  Icon(Icons.directions,size: 35,),
                ),
            ),
          ),

        ],
      ),
    );
  }

  onMapCreated(GoogleMapController controller) async {
    allmarkers = await database_service.getmarkers();
    setState(() {
      _googleMapController = controller;
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

  openmapbox(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Mapbox_nav()));
  }


}
