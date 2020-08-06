import 'package:dustbin_project/constants.dart';
import 'package:dustbin_project/services/database.dart';
import 'package:dustbin_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';

class Mapbox_nav extends StatefulWidget {
  @override
  _Mapbox_navState createState() => _Mapbox_navState();
}

class _Mapbox_navState extends State<Mapbox_nav> {
  String _platformVersion = 'Unknown';
  MapboxNavigation _directions;
  List<WayPoint> waypoints=<WayPoint>[];
  double _distanceRemaining, _durationRemaining;
  bool _arrived = false;
  Database_Service database_service=Database_Service();


  @override
  void initState() {
    super.initState();
    initPlatformState();
    getwaypoints();
  }

  getwaypoints() async{
    print("called navigation waypoints");
    waypoints=await database_service.getwaypoints();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              boxshadow(5.0, 5.0, 10.0, 0.5, Colors.grey[500]),
                              boxshadow(-1.0, -1.0, 10.0, 0.5, Colors.white)
                            ]),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [text(constants.bincount, 22.0,Colors.black),SizedBox(height: 5,),text(Database_Service.binc.toString(), 25.0,Colors.deepPurpleAccent)],

                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              boxshadow(5.0, 5.0, 10.0, 0.5, Colors.grey[500]),
                              boxshadow(-1.0, -1.0, 10.0, 0.5, Colors.white)
                            ]),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [text(constants.fbins, 22.0,Colors.black),SizedBox(height: 5,),text(Database_Service.flbinc.toString(), 25.0,Colors.deepPurpleAccent)],
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              boxshadow(5.0, 5.0, 10.0, 1.5, Colors.grey[500]),
                              boxshadow(-1.0, -1.0, 10.0, .5, Colors.white)
                            ]),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [text(constants.fiftybins, 22.0,Colors.black),SizedBox(height: 5,),text(Database_Service.fbinc.toString(), 25.0,Colors.deepPurpleAccent)],

                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              boxshadow(5.0, 5.0, 10.0, 1.5, Colors.grey[500]),
                              boxshadow(-1.0, -1.0, 10.0, .5, Colors.white)
                            ]),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [text(constants.ebins, 22.0,Colors.black),SizedBox(height: 5,),text(Database_Service.ebinc.toString(), 25.0,Colors.deepPurpleAccent)],
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          RaisedButton(
            child: Text("Start Navigation"),
            onPressed: () async {
              await _directions.startNavigation(
                  origin: waypoints[0],
                  destination: waypoints[1],
                  mode: MapBoxNavigationMode.drivingWithTraffic,
                  simulateRoute: true,
                  language: "German",
                  units: VoiceUnits.metric);
            },
          ),
          SizedBox(
            height: 60,
          ),
        ]),
      ),
    );
  }
}
