import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markit/services/UserDataDBService.dart';

class GMapPage extends StatefulWidget {
  var getStatus;
  var getPos;
  GMapPage(this.getPos, this.getStatus, {Key? key}) : super(key: key);

  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final UserDataDBService _showDataService = UserDataDBService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final List<Marker> _markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    // List<Marker> list =
    //       // markerId: MarkerId(_markers),
    //       // position: LatLng(widget.getPos.latitude, widget.getPos.longitude),
    //       // infoWindow: InfoWindow(title: "${widget.getStatus}")),
    //  ];
    // _markers.addAll(getMarkerData());
  }

  @override
  Widget build(BuildContext context) {
    void initMarker(specify, specifyId) async {
      var markerIdVal = specifyId;
      final MarkerId markerId = MarkerId(markerIdVal);
      final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(title: specify['status']),
      );
      setState(() {
        markers[markerId] = marker;
        //print(markerId);
      });
    }

    getMarkerData() {
      _showDataService
          .getMarkerQueryFreeWithoutVip()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          initMarker(doc.data(), doc.id);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Go!"),
      ),
      body: SafeArea(
        child: GoogleMap(
          markers: Set<Marker>.of(markers.values),
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.getPos.latitude, widget.getPos.longitude),
              zoom: 7),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          // markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            getMarkerData();
          },
        ),
      ),
    );
  }
}
