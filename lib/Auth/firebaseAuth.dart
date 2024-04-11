import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Screens/AuthSelectScreen.dart';
import '../Core/Util/ShowSnackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);
  final FirebaseFirestore _firesotre = FirebaseFirestore.instance;

  //EMAIL SIGN IN
  Future<User?> signInWithEmail(
      {required String email,
        required String pass,
        required String name,
        required BuildContext context}) async {
    User? user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: pass))
          .user;
      if (user != null) {
        user.updateDisplayName(name);
        await _firesotre
            .collection('users')
            .doc(user.uid)
            .set({
          'name': name,
          'email': email,
          'status': "Unavailable",
          'uid' : _auth.currentUser?.uid,
        });
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'weak password');
      } else {
        showSnackBar(context, e.message!);
      }
    }
    return user;
  }

  //LOGIN
  Future<User?> logInWithEmail(
      {required String email,
        required String pass,
        required BuildContext context}) async {
    User? user;
    try {
      user =
          (await _auth.signInWithEmailAndPassword(email: email, password: pass))
              .user;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return user;
  }
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // LOG OUT
  Future<void> logOut(BuildContext context) async {
    try {
      await _auth
          .signOut()
          .then((value) => {Navigator.pushAndRemoveUntil(context, AuthSelectScreen.route(),(route) => false,),});
    } catch (e) {
      showSnackBar(context, "Error while Logging out !!");
    }
  }
}