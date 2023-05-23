import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markit/AddData.dart';
import 'package:markit/services/AuthService.dart';

import 'LoginPage.dart';
import 'ShowMarks.dart';

final AuthService _authService = AuthService();
final FirebaseAuth _auth = FirebaseAuth.instance;

class MarkItHomePage extends StatelessWidget {
  const MarkItHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
        backgroundColor: Colors.brown,
      ),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MarkItHomePage()));
              },
            ),
            ListTile(
              title: Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
              leading: Icon(Icons.person),
            ),
            const Divider(thickness: 0.6, color: Colors.grey),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                _authService.signOut();
                Fluttertoast.showToast(
                    msg: "Succesfully LoggedOut!",
                    timeInSecForIosWeb: 2,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[600],
                    textColor: Colors.white,
                    fontSize: 14);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              leading: Icon(Icons.remove_circle),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 95.0,
                  backgroundColor: Colors.lime,
                  backgroundImage: AssetImage("assets/images/logo.jpg"),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.brown,
                          alignment: Alignment.center,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: const Text('Mark !T'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddData()));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.brown,
                          alignment: Alignment.center,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: const Text('Show Marks'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowMarks()));
                      },
                    ),
                  ],
                ),
                Text(
                  "Mark !T to remember where was that thing(?) located!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 3,
                    fontSize: 14,
                    color: Colors.brown[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
