import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'UserDataDBService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserDataDBService _dataService = UserDataDBService();
//Sign in
  Future<User?> signIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      toastMsg("Login Succesfull");
      return user.user;
    } on FirebaseAuthException catch (e) {
      toastMsg("$e");
      return Future.error(FirebaseAuthException);
    }
  }

//toast msg
  void toastMsg(String tMsg) {
    Fluttertoast.showToast(
        msg: tMsg,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 14);
  }

//Sign out
  signOut() async {
    toastMsg("Succesfully LoggedOut!");
    return await _auth.signOut();
  }

  String? text;
  bool? a;
//isVip
  Future<String?> checkVip() async {
    if (await _dataService.fetchUserMod() == true) {
      text = "[ VIP Member ]";
      a = true;
    } else {
      text = "[ Free Member ]";
      a = false;
    }
    return text;
  }

  String? check() {
    checkVip();
    return text;
  }

  bool? checkVipBool() {
    checkVip();
    return a;
  }

//Reset User
  Future resetUser(String mail) async {
    try {
      await _auth.sendPasswordResetEmail(email: mail);
      toastMsg("verification E-Mail Sent");
    } on FirebaseAuthException catch (e) {
      toastMsg("$e");
    }
  }

//Create user
  Future<User?> createUser(
      String name, String email, String password, bool isVip) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection("Users").doc(user.user?.uid).set({
        'userName': name,
        'Email': email,
        'isVip': isVip,
      });
      await user.user?.updateDisplayName(name);
      toastMsg("User Created Successfully!");
      return user.user;
    } on FirebaseAuthException catch (e) {
      toastMsg("$e");
      return Future.error(FirebaseAuthException);
    }
  }
}
