import 'dart:collection';

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
  bool fetchinfdata = true;
  final databaseReference = Firestore.instance;
  GoogleMapController _googleMapController;

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
                onMapCreated: onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: LatLng(26.47064, 73.11449),zoom: 17),
                markers: allmarkers,
              )),
          Positioned(
            top: MediaQuery.of(context).size.height/28,
            right: MediaQuery.of(context).size.width/15,
            child: InkWell(
              onTap: (){
                updatedata();
              },
              child: Container(
                padding: EdgeInsets.all(5),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                   color: Colors.black87
                ),
                child: Icon(Icons.refresh,color: Colors.blue,size: 35,),
              ),
            ),
          )
        ],
      ),
    );
  }

  onMapCreated(GoogleMapController controller) async{
    _googleMapController = controller;
    await databaseReference
        .collection("markers")
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
      snapshot.documents.forEach((doc) {
        allmarkers.add(Marker(
          infoWindow: InfoWindow(
            title: doc.data["percentage"]
          ),
            markerId: MarkerId(doc.data["name"]),
            position: LatLng(
                doc.data["location"].latitude, doc.data["location"].longitude)));
      })
    });
    setState(()  {
      allmarkers;
      print(allmarkers.toString());
    });
  }

  updatedata() async{
    Set<Marker> markers_set = HashSet<Marker>();

    await databaseReference
        .collection("markers")
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
      snapshot.documents.forEach((doc) {
        markers_set.add(Marker(
            infoWindow: InfoWindow(
                title: doc.data["percentage"]
            ),
            markerId: MarkerId(doc.data["name"]),
            position: LatLng(
                doc.data["location"][0], doc.data["location"][1])));
      })
    });
    allmarkers=markers_set;

    setState(()  {
    });

  }

  Widget loadmap() {
    CollectionReference markers = Firestore.instance.collection('markers');

    return StreamBuilder<QuerySnapshot>(
        stream: markers.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("some error");
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();

          return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(19.0760, 72.8777)),
            markers: Set.from(allmarkers),
          );
        });
  }



}


