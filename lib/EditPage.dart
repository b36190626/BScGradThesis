import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markit/ShowMarks.dart';

import 'package:markit/services/UserDataDBService.dart';

class EditPage extends StatefulWidget {
  final String docId;
  const EditPage(this.docId, {Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController dataController = TextEditingController();
  final UserDataDBService _editDataService = UserDataDBService();

  @override
  Widget build(BuildContext context) {
    var ref = _editDataService.fetchData();
    var getDoc = ref.doc("${widget.docId}");

    var size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
          backgroundColor: Colors.brown,
        ),
        body: Material(
          child: StreamBuilder<DocumentSnapshot>(
            stream: getDoc.snapshots(),
            builder: (context, AsyncSnapshot snapShot) {
              return !snapShot.hasData
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: size.height * .3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.brown, width: 2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextField(
                                        controller: dataController,
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText:
                                              ("${snapShot.data['status']}"),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          border: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapShot.data['image']),
                                        radius: height * 0.06,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                            onTap: () => {},
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 30,
                                              color: Colors.brown,
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () => {},
                                            child: const Icon(
                                              Icons.image_outlined,
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
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, bottom: 25),
                            child: InkWell(
                              onTap: () {
                                _editDataService
                                    .editStatus(
                                        widget.docId, dataController.text)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Edit Completed!",
                                      timeInSecForIosWeb: 2,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.grey[600],
                                      textColor: Colors.white,
                                      fontSize: 14);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowMarks()));
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.brown, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 20,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ]);
            },
          ),
        ));
  }
}
