import 'package:flutter/material.dart';

const Color buttonsColor = Color.fromARGB(255, 65, 51, 190);

const Color textBorderColor = Color.fromARGB(255, 206, 226, 225);

const Color deptColor = Colors.orange;

const Color payingColor = Colors.green;

const double dialogFontSize = 25;

// this function will convert the money to give it fraction to read it
String moneyFraction(double number) {
  String s = number.toStringAsFixed(0);
  int count = 1;

  for (int i = s.length - 1; i >= 0; i--) {
    if (count == 3) {
      String sub = s.substring(i);
      sub = ',$sub';
      s = s.substring(0, i);
      s = '$s$sub';
      count = 0;
    }
    count++;
  }
  if (s.startsWith(',')) {
    s = s.substring(1);
  }
  if (s.startsWith('-')) {
    s = s.substring(2);
    s = '-$s';
  }
  return '$s د.ع';
}

const TextStyle scackBarTextStyle =
    TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w400);
