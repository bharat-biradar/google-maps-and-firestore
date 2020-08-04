import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Database_Service{
  final databaserefernce=Firestore.instance;

  Future<Set<Marker>> getmarkers() async{
    Set<Marker> markers=HashSet();
    await databaserefernce
        .collection("markers")
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
      snapshot.documents.forEach((doc) {
        markers.add(Marker(
            infoWindow: InfoWindow(
                title: doc.data["percentage"]
            ),
            markerId: MarkerId(doc.data["name"]),
            position: LatLng(
                doc.data["location"].latitude, doc.data["location"].longitude)));
      })
    });
    return markers;
  }
}