import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
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
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.all(20),
        filled: true,
        fillColor: Colors.black,
        hintText: text,
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: buttonsColor)),
      ),
    );
  }
}
