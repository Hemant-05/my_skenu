import 'package:flutter/material.dart';
import 'package:my_skenu/Provider/UserProvider.dart';
import 'package:my_skenu/Screens/SelectTabScreen.dart';
import 'package:provider/provider.dart';
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
    super.initState();
    if(widget.isLoggedIn){
      fetchData();
    }
    go();
  }

  void fetchData() async {
    UserProvider _provider = Provider.of(context,listen: false);
    await _provider.refreshUser();
  }
  void go() async {
    await Future.delayed(
      const Duration(
        seconds: 3,
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
        SelectTabScreen.route(),
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
