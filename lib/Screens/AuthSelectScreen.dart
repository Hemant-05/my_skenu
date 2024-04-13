import 'package:flutter/material.dart';
import '../Core/Constant/StringConstant.dart';
import '../Core/Util/MyColors.dart';
import '../Widgets/AuthButton.dart';
import 'LogInScreen.dart';
import 'SignUpScreen.dart';

class AuthSelectScreen extends StatelessWidget {
  const AuthSelectScreen({super.key});
  static route()=> MaterialPageRoute(builder: (context) => const AuthSelectScreen(),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                background,
              ),
            ),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AuthButton(
                fun: () {
                  Navigator.push(context,LogInScreen.route());
                },
                color: MyColors.darkyellow,
                text: 'LOG IN WITH EMAIL',
                textColor: MyColors.purpul,),
            const SizedBox(
              height: 15,
            ),
            AuthButton(
              color: MyColors.purpul,
              text: 'REGISTER',
              fun: () {
                Navigator.push(context, SignUpScreen.route());
              },
              textColor: Colors.white,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
