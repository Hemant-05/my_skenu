import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Screens/HomeScreen.dart';
import '../Core/Constant/StringConstant.dart';
import '../Core/Util/MyColors.dart';
import 'AuthSelectScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    go();
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
