import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markit/GMapPage.dart';
import 'package:markit/ShowMarks.dart';
import 'package:markit/services/AuthService.dart';
import 'package:markit/services/UserDataDBService.dart';
import 'package:markit/EditPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'GMapPageV.dart';

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  final UserDataDBService _showDataService = UserDataDBService();
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  isMember() {
    if (_authService.checkVipBool() == true) {
      return null;
    } else if (_authService.checkVipBool() == false) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: StreamBuilder<QuerySnapshot>(
        stream: _showDataService.queryFreeWithoutVip(),
        builder: (context, snapShot) {
          return !snapShot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapShot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot getDoc = snapShot.data!.docs[index];
                    const Center(child: CircularProgressIndicator());
                    Future<void> _showChoiceDialog(BuildContext context) {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text(
                                  "Are you sure to delete?",
                                  textAlign: TextAlign.center,
                                ),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                content: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            const Center(
                                                child:
                                                    CircularProgressIndicator());
                                            _showDataService
                                                .removeStatus(getDoc.id)
                                                .then((value) {
                                              Fluttertoast.showToast(
                                                  msg: "Data has been deleted!",
                                                  timeInSecForIosWeb: 2,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor:
                                                      Colors.grey[600],
                                                  textColor: Colors.white,
                                                  fontSize: 14);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShowMarks()));
                                            });
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                height: 3,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                height: 3,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )));
                          });
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * .27,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.brown, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxWidth: 255, maxHeight: 125),
                                      child: Text(
                                        maxLines: 6,
                                        "${index + 1} - Author: ${getDoc['user']} -\n\n${getDoc['status']}",
                                        //"\n\nLatitude: ${getDoc['location'].latitude}° N\nLongitude: ${getDoc['location'].longitude}° E\n",
                                        style: const TextStyle(
                                            height: 1,
                                            fontSize: 15,
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      child: Image.network(
                                        getDoc['image'] ??
                                            const CircularProgressIndicator(),
                                        height: 120.0,
                                        width: 90.0,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                        onTap: () => {
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => _authService
                                                                  .checkVipBool() ==
                                                              true
                                                          ? GMapPage(
                                                              (getDoc[
                                                                  'location']),
                                                              (getDoc[
                                                                  'status']))
                                                          : GMapPage(
                                                              (getDoc[
                                                                  'location']),
                                                              (getDoc[
                                                                  'status']))))
                                            },
                                        child: const Icon(
                                          Icons.directions,
                                          size: 35,
                                          color: Colors.brown,
                                        )),
                                    InkWell(
                                        onTap: () => {
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditPage(getDoc.id)))
                                            },
                                        child: const Icon(
                                          Icons.edit_note_rounded,
                                          size: 35,
                                          color: Colors.brown,
                                        )),
                                    InkWell(
                                        onTap: () {
                                          _showChoiceDialog(context);
                                        },
                                        child: const Icon(
                                          Icons.delete_rounded,
                                          size: 35,
                                          color: Colors.brown,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        },
      ),
    );
  }
//   void _onDeleteButtonPressed(,)
// }
//   void _onEditButtonPressed(,)
// }
//   void _onGetRouteButtonPressed(,)
// }
}
