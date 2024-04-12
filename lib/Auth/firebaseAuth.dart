import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Core/Util/StorageMethods.dart';
import 'package:my_skenu/Core/Util/UserModel.dart';
import 'package:my_skenu/Screens/AuthSelectScreen.dart';
import '../Core/Util/ShowSnackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firesotre = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    DocumentSnapshot snapshot =
        await _firesotre.collection('users').doc(_auth.currentUser!.uid).get();
    return UserModel.fromSnap(snapshot);
  }

  //EMAIL SIGN IN
  Future<String> signInWithEmail({
    required String email,
    required String pass,
    required String name,
    required BuildContext context,
    required Uint8List file,
  }) async {
    User? user;
    String str = 'nothing';
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      ))
          .user;
      if (user != null) {
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        UserModel model = UserModel(
          email: email,
          name: name,
          uid: user.uid,
          follower: [],
          following: [],
          photoUrl: photoUrl,
        );
        await _firesotre.collection('users').doc(user.uid).set(
              model.toJson(),
            );
        str = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'weak password');
      } else {
        showSnackBar(context, e.message!);
      }
    } catch (e) {
      str = e.toString();
    }
    return str;
  }

  //LOGIN
  Future<String> logInWithEmail(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    String str = 'nothing';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      str = 'success';
    } on FirebaseAuthException catch (e) {
      str = e.toString();
      showSnackBar(context, e.message!);
    }
    return str;
  }

  // LOG OUT
  Future<void> logOut(BuildContext context) async {
    try {
      await _auth.signOut().then((value) => {
            Navigator.pushAndRemoveUntil(
              context,
              AuthSelectScreen.route(),
              (route) => false,
            ),
          });
    } catch (e) {
      showSnackBar(context, "Error while Logging out !!");
    }
  }
}
