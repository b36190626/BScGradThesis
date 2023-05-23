import 'package:markit/AddData.dart';
import 'package:markit/MarkItHomePage.dart';
import 'package:markit/ShowDataPage.dart';
import 'package:markit/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ShowVipPlusFree.dart';

final AuthService _authService = AuthService();
final FirebaseAuth _auth = FirebaseAuth.instance;

class ShowMarks extends StatefulWidget {
  @override
  _ShowMarksState createState() => _ShowMarksState();
}

class _ShowMarksState extends State<ShowMarks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Marked Locations")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddData()));
          },
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: RichText(
                    text: TextSpan(children: [
                  TextSpan(text: 'Hello ${_auth.currentUser?.displayName}! '),
                  TextSpan(
                      text: _authService.check(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green)),
                ])),
                accountEmail: Text("${_auth.currentUser?.email}"),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo.jpg"),
                ),
              ),
              ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarkItHomePage()));
                },
              ),
              ListTile(
                title: Text('My Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.person),
              ),
              const Divider(thickness: 0.6, color: Colors.brown),
              ListTile(
                title: Text('Log Out'),
                onTap: () {
                  _authService.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                leading: Icon(Icons.remove_circle),
              ),
            ],
          ),
        ),
        body: _authService.checkVipBool() == true
            ? ShowVipPlusFree()
            : ShowDataPage());
  }
}
