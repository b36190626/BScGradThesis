import 'package:cloud_firestore/cloud_firestore.dart';

//Modelling UserData
class UserData {
  String id;
  String status;
  String image;
  String? user;
  GeoPoint location;
  bool isVip;
  UserData(
      {required this.id,
      required this.status,
      required this.image,
      required this.location,
      required this.user,
      required this.isVip});

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        id: snapshot.id,
        status: snapshot["status"],
        image: snapshot["image"],
        location: snapshot["location"],
        user: snapshot["user"],
        isVip: snapshot["isVip"]);
  }
}
