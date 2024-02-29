import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.text,
    required this.controller,
    this.keyboardType,
  });
  final String text;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.right,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: textBorderColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
        filled: true,
        fillColor: Colors.black,
        hintText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
