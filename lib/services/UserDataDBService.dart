import 'dart:ffi';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:markit/Model/UserData.dart';
import 'package:markit/services/StorageService.dart';

class UserDataDBService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mediaUrl = "";

  //Add data function
  Future<UserData> addData(String status, PickedFile pickedFile,
      GeoPoint location, String? user, bool isVip) async {
    var ref = _fireStore.collection("UserData");

    mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));

    var documentRef = await ref.add({
      'status': status,
      'image': mediaUrl,
      'location': GeoPoint(location.latitude, location.longitude),
      'isVip': isVip,
      'user': user,
    });

    return UserData(
        id: documentRef.id,
        status: status,
        image: mediaUrl,
        location: GeoPoint(location.latitude, location.longitude),
        isVip: isVip,
        user: user);
  }

  //Show data function
  Stream<QuerySnapshot> getStatus() {
    var ref = _fireStore.collection("UserData").snapshots();
    return ref;
  }

  //fetch data func
  CollectionReference<Object?> fetchData() {
    CollectionReference ref = _fireStore.collection("UserData");
    return ref;
  }

  //fetch user func

  Future<bool> fetchUserMod() async {
    var snapshot =
        await _fireStore.collection('Users').doc(_auth.currentUser?.uid).get();
    bool isVip = (snapshot["isVip"]) as bool;
    return isVip;
  }

// One Function with 2 Queries
  Stream<List<QuerySnapshot>> queryCurrentVipPlusFree() {
    Stream frees = _fireStore
        .collection('UserData')
        .where('isVip', isEqualTo: false)
        .snapshots();
//fetched Free user's entries
    Stream currentVip = _fireStore
        .collection('UserData')
        .where('user', isEqualTo: _auth.currentUser?.displayName)
        .snapshots();
//fetched only current VIP user's entries, not allowed to see other VIP's
    return StreamZip([(frees as dynamic), (currentVip as dynamic)]);
  }

  queryCurrentV1ipPlusFree() {
    return _fireStore
        .collection('UserData')
        .where('isVip', isEqualTo: true)
        .where('user', isEqualTo: _auth.currentUser?.displayName)
        .snapshots();
  }

  queryFreeWithoutVip() {
    return _fireStore
        .collection('UserData')
        .where('isVip', isEqualTo: false)
        .snapshots();
  }

  getMarkerQueryFreeWithoutVip() {
    return _fireStore
        .collection('UserData')
        //.where('isVip', isEqualTo: true)
        .get();
  }

  //Edit data function
  Future<void> editStatus(String docId, String status) {
    return _fireStore.collection("UserData").doc(docId).update(
      {'status': status},
    );
  }

  //markervip
  Stream<List<QuerySnapshot>> markerQueryCurrentVipPlusFree() {
    Stream frees = _fireStore
        .collection('UserData')
        .where('isVip', isEqualTo: false)
        .snapshots();
    Stream currentVip = _fireStore
        .collection('UserData')
        .where('user', isEqualTo: _auth.currentUser?.displayName)
        .snapshots();

    return StreamZip([(frees as dynamic), (currentVip as dynamic)]);
  }

  //Delete data function
  Future<void> removeStatus(String docId) {
    var ref = _fireStore.collection("UserData").doc(docId).delete();

    return ref;
  }
}
