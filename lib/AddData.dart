import 'dart:ffi';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markit/services/AuthService.dart';
import 'package:markit/services/UserDataDBService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddData extends StatefulWidget {
  AddData({Key? key}) : super(key: key);

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  late LatLng _curLoc;
  late Position getCurLoc;
  late GeoPoint _location;
  TextEditingController dataController = TextEditingController();
  final UserDataDBService _addDataService = UserDataDBService();
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ImagePicker _pickerImage = ImagePicker();
  dynamic _pickImage;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  PickedFile profileImage = PickedFile("/storage/1807-1B03/Download/logo.jpg");

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    if (profileImage != null) {
      return CircleAvatar(
          backgroundImage: FileImage(File(profileImage.path)),
          radius: height * 0.06);
    } else {
      if (_pickImage != null) {
        return CircleAvatar(
          backgroundImage: NetworkImage(_pickImage),
          radius: height * 0.06,
        );
      } else {
        return CircleAvatar(
          backgroundImage: const AssetImage("assets/images/logo.jpg"),
          radius: height * 0.06,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Description"),
          backgroundColor: Colors.brown,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height * .3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.brown, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                          controller: dataController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText:
                                "Please write something to make you remember...",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: imagePlace(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                getCurrentPosition();
                                Fluttertoast.showToast(
                                    msg: "Current Position Updated!",
                                    timeInSecForIosWeb: 2,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.grey[600],
                                    textColor: Colors.white,
                                    fontSize: 14);
                              },
                              child: const Icon(
                                Icons.location_on,
                                size: 30,
                                color: Colors.brown,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                              onTap: () => {
                                    const Center(
                                        child: CircularProgressIndicator(
                                      value: 1,
                                    )),
                                    _onImageButtonPressed(
                                      ImageSource.camera,
                                      context: context,
                                    )
                                  },
                              child: const Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.brown,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () => {
                                    const Center(
                                        child: CircularProgressIndicator(
                                      value: 1,
                                    )),
                                    _onImageButtonPressed(ImageSource.gallery,
                                        context: context)
                                  },
                              child: const Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.brown,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 25),
              child: InkWell(
                onTap: () async {
                  _addDataService
                      .addData(
                          dataController.text,
                          profileImage,
                          _location,
                          _auth.currentUser?.displayName,
                          await _addDataService.fetchUserMod())
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: "Data has been added!",
                        timeInSecForIosWeb: 2,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[600],
                        textColor: Colors.white,
                        fontSize: 14);
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown, width: 2),
                      //color: colorPrimaryShade,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                        child: Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<Position> _determinePos() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void getCurrentPosition() async {
    var a = Geolocator.getPositionStream();
    a.last.toString();
    //listen event(to force currentLocation instead of cached LastKnownLoc)
    getCurLoc = await _determinePos();
    setState(() {
      _curLoc = LatLng(getCurLoc.latitude, getCurLoc.longitude);
      GeoPoint location = GeoPoint(_curLoc.latitude, _curLoc.longitude);
      _location = location;
    });
    _curLoc != null
        ? print("${_location.latitude} ° N ${_location.longitude} ° W")
        : Text("Location not Found");
  }

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile = await _pickerImage.getImage(source: source);
      setState(() {
        profileImage = pickedFile!;
        if (profileImage != null) {}
      });
    } catch (e) {
      setState(() {
        _pickImage = e;
        print("Image Error:  $_pickImage");
      });
    }
  }
}
