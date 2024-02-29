import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.text});

  final void Function() onPressed;
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      padding: const EdgeInsets.all(20),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
