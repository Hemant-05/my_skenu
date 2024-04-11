import 'package:flutter/material.dart';

import '../Core/Util/MyColors.dart';

class LogInTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;

  const LogInTextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isObscure});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: 3,
            color: MyColors.yellow,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: 3,
            color: MyColors.yellow,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: 3,
            color: MyColors.yellow,
          ),
        ),
      ),
      obscureText: isObscure,
      validator: (value) {
        if (value != null) {
          return '$hintText is missing';
        }
      },
    );
  }
}
