import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Auth/firebaseAuth.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Screens/HomeScreen.dart';
import '../Core/Constant/StringConstant.dart';
import '../Core/Util/MyColors.dart';
import '../Widgets/AuthButton.dart';
import '../Widgets/LogInTextFormField.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const LogInScreen(),
      );

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuthMethods(FirebaseAuth.instance);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                background,
              ),
            ),
          ),
          child: Center(
            // Container for login form
            child: Container(
              height: 450,
              width: 330,
              padding: const EdgeInsets.all(35.0),
              // Add padding for aesthetics
              decoration: BoxDecoration(
                color: Colors.white, // Set background color
                borderRadius:
                    BorderRadius.circular(10.0), // Add rounded corners
              ),
              child: Column(
                // mainAxisSize: MainAxisSize.min, // Restrict column size
                children: [
                  const SizedBox(height: 30.0),
                  // Text for "Sign in to your account" (optional)
                  const Text(
                    'Sign in to your account',
                    style: TextStyle(
                      fontSize: 16, // Adjust font size as needed
                    ),
                  ),
                  const SizedBox(height: 30.0), // Add spacing between elements
                  // Text field for email
                  LogInTextFormField(
                    controller: emailController,
                    hintText: 'Email',
                    isObscure: false,
                  ),
                  const SizedBox(height: 30.0), // Add spacing between elements
                  // Text field for password
                  LogInTextFormField(
                    controller: passController,
                    hintText: 'Password',
                    isObscure: true,
                  ),
                  const SizedBox(height: 40.0), // Add spacing between elements
                  AuthButton(
                      color: MyColors.purpul,
                      text: 'LOG IN',
                      fun: () {
                        String email = emailController.text.trim();
                        String pass = passController.text.trim();
                        if (pass.isNotEmpty && email.isNotEmpty) {
                          _auth.logInWithEmail(
                            email: email,
                            pass: pass,
                            context: context,
                          );
                          print('logged in');
                          Navigator.pushAndRemoveUntil(context, HomeScreen.route() , (route) => false);
                        } else {
                          showSnackBar(context, 'enter email & pass');
                        }
                      },
                      textColor: Colors.white),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Forget password',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
