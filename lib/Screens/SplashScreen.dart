import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Screens/HomeScreen.dart';
import '../Core/Constant/StringConstant.dart';
import '../Core/Error/ServerException.dart';
import '../Core/Util/MyColors.dart';
import '../Core/Util/UserModel.dart';
import 'AuthSelectScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserModel model;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    go();
  }

  void getUserDetails() async {
    final _auth = FirebaseAuth.instance;
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      try {
        model = UserModel.fromJson(snapshot.data()!);
      } catch (e) {
        throw ServerException(error: e.toString());
      }
    } else {
      throw ServerException(error: 'Retry');
    }
  }
  void go() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );
    if(auth.currentUser == null) {
      Navigator.pushAndRemoveUntil(
        context,
        AuthSelectScreen.route(),
            (route) => false,
      );
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        HomeScreen.route(),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.yellow,
      body: const Center(
        child: Image(
          height: 80,
          image: AssetImage(
            icon,
          ),
        ),
      ),
    );
  }
}
