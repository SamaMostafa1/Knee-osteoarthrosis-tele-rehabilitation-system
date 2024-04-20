import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextField(maxLength: 30,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),       // الشكل وانت مش دايس على تيكست فيلد
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),      // الشكل وانت دايس على تيكست فيلد
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            filled: true,
            fillColor: Colors.grey.shade300,        // لون باك جراوند بتاع تيكست فيلد
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
