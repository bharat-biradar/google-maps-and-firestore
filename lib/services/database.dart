import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Database_Service {
  final databaserefernce = Firestore.instance;
  BitmapDescriptor empty;
  BitmapDescriptor full;
  BitmapDescriptor twenty;
  BitmapDescriptor fifty;
  BitmapDescriptor ninety;
  static int binc = 0;
  static int ebinc = 0;
  static int fbinc = 0;
  static int flbinc = 0;

  Future<void> loadicons() async {
    print("loading started");
    empty = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "icons/empty.png");
    full = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "icons/full.png");
    twenty = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "icons/twentyper.png");
    fifty = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "icons/fiftyper.png");
    ninety = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "icons/ninetyper.png");
    print("loading done");
  }

  Future<Set<Marker>> getmarkers() async {

    await loadicons();
    Set<Marker> markers = HashSet();
    await databaserefernce
        .collection("markers")
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
              snapshot.documents.forEach((doc) {
                BitmapDescriptor icon = geticon(doc.data["percentage"]);
                markers.add(Marker(
                    icon: icon,
                    infoWindow:
                        InfoWindow(title: doc.data["percentage"].toString()),
                    markerId: MarkerId(doc.data["name"]),
                    position: LatLng(doc.data["location"].latitude,
                        doc.data["location"].longitude)));
              }),
      binc=snapshot.documents.length,
            });
    return markers;
  }

  Future<Set<Marker>> updatemarkers() async {
    Set<Marker> markers = HashSet();
    await databaserefernce
        .collection("markers")
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
              snapshot.documents.forEach((doc) {
                BitmapDescriptor icon = geticon(doc.data["percentage"]);

                markers.add(Marker(
                    icon: icon,
                    infoWindow:
                        InfoWindow(title: doc.data["percentage"].toString()),
                    markerId: MarkerId(doc.data["name"]),
                    position: LatLng(doc.data["location"].latitude,
                        doc.data["location"].longitude)));
              })
            });
    return markers;
  }

  BitmapDescriptor geticon(nor) {
    var percentage = double.parse(nor.toString());
    if (percentage < 10.0) {
      ebinc = ebinc + 1;
      return empty;
    } else if (percentage < 50.0) {
      return twenty;
    } else if (percentage < 75.0) {
      fbinc = fbinc + 1;
      return fifty;
    } else if (percentage < 90.0) {
      fbinc = fbinc + 1;
      return ninety;
    } else {
      flbinc = flbinc + 1;
      return full;
    }
  }
}


