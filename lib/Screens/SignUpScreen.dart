import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_skenu/Auth/firebaseAuth.dart';
import 'package:my_skenu/Core/Util/ShowSnackbar.dart';
import 'package:my_skenu/Screens/SelectTabScreen.dart';
import '../Core/Util/MyColors.dart';
import '../Core/Util/PickImage.dart';
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
  final _authMethods = FirebaseAuthMethods();
  Uint8List? image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    userNameController.dispose();
    passController.dispose();
    conPassController.dispose();
  }

  void _pickImage() async {
    try {
      Uint8List file = await pickImage(ImageSource.gallery);
      setState(() {
        image = file;
      });
    } catch (e) {
      print(' =-=---=-=-=-=-=-=-=-=-=-=-=-=-=-= \n $e');
    }
  }

  void _signUpUser() async {
    String email = emailController.text.trim();
    String pass = passController.text.trim();
    String conPass = conPassController.text.trim();
    String name = userNameController.text.trim();
    if (email.isNotEmpty &&
        pass.isNotEmpty &&
        conPass == pass &&
        image != null) {
      setState(() {
        _isLoading = true;
      });
      String str = await _authMethods.signInWithEmail(
        email: email,
        pass: pass,
        name: name,
        context: context,
        file: image!,
      );
      if (str != 'success') {
        showSnackBar(context, str);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          SelectTabScreen.route(),
           (route) => false,
        );
      }
    } else {
      if (conPass != pass) {
        showSnackBar(context, 'Password not matched!');
      } else if (image == null) {
        showSnackBar(context, 'Select profile picture...');
      } else {
        showSnackBar(context, 'Enter email & pass');
      }
    }
    setState(() {
      _isLoading = false;
    });
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: image != null
                              ? MyColors.transparent
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image(
                                  image: MemoryImage(
                                    image!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 100,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                      fun: _signUpUser,
                      textColor: Colors.white,
                    )
                  ]),
                ),
              ),
            ),
    );
  }
}
