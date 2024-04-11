import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Auth/firebaseAuth.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Screens/HomeScreen.dart';
import '../Core/Util/MyColors.dart';
import '../Widgets/AuthButton.dart';
import '../Widgets/SignUpTextFormField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController conPassController = TextEditingController();
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  final _authMethods = FirebaseAuthMethods(FirebaseAuth.instance);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    userNameController.dispose();
    passController.dispose();
    conPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.purpul,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Register with Skenu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.yellow,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              SignUpTextFormField(
                controller: userNameController,
                hintText: 'User Name',
                isObscure: false,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 30,
              ),
              SignUpTextFormField(
                controller: emailController,
                hintText: 'Email',
                isObscure: false,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 30,
              ),
              SignUpTextFormField(
                controller: passController,
                hintText: 'Password',
                isObscure: true,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 30,
              ),
              SignUpTextFormField(
                controller: conPassController,
                hintText: 'Confirm Password',
                isObscure: true,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Text(
                    'Agree terms and condition',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AuthButton(
                color: MyColors.darkBlue,
                text: 'Register',
                fun: () async {
                  String email = emailController.text.trim();
                  String pass = passController.text.trim();
                  String conPass = conPassController.text.trim();
                  String name = userNameController.text.trim();
                  if (pass == conPass) {
                    final user = await _authMethods.signInWithEmail(
                      email: email,
                      pass: pass,
                      name: name,
                      context: context,
                    );
                    if (user != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen.route(),
                        ),
                        (route) => false,
                      );
                    }
                  } else {
                    showSnackBar(context, 'Password not matched!');
                  }
                },
                textColor: Colors.white,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
