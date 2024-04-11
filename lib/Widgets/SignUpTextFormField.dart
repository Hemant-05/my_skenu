import 'package:flutter/material.dart';
import '../Core/Util/MyColors.dart';

class SignUpTextFormField extends StatelessWidget {
  const SignUpTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isObscure,
    required this.textColor,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      color: MyColors.darkBlue,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.darkBlue,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.darkBlue,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.darkBlue,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.darkBlue,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.all(8),
          hintStyle: TextStyle(color: textColor),
          fillColor: MyColors.darkBlue,
        ),
        style: TextStyle(color: textColor, fontSize: 18),
        obscureText: isObscure,
        validator: (value) {
          if (value != null) {
            return '$hintText is missing';
          }
        },
      ),
    );
  }
}
