import 'package:flutter/material.dart';
import 'package:my_skenu/Screens/HomeScreen.dart';
import '../Core/Constant/StringConstant.dart';
import '../Core/Util/MyColors.dart';
import 'AuthSelectScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.isLoggedIn});

  static route({required bool isLoggedIn}) => MaterialPageRoute(
        builder: (context) => SplashScreen(
          isLoggedIn: isLoggedIn,
        ),
      );
  final bool isLoggedIn;

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
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    if (!widget.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        AuthSelectScreen.route(),
      );
    } else {
      Navigator.pushReplacement(
        context,
        HomeScreen.route(),
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
