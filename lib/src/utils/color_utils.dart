import 'package:flutter/material.dart';
import 'dart:math';

int max = 10;

List<Color> colorList = [
  Colors.amber.shade400,
  Colors.blue,
  Colors.brown.shade400,
  Colors.deepOrange.shade400,
  Colors.deepPurple.shade400,
  Colors.green,
  Colors.pink.shade300,
];

Color getRandomColor() {
  int randomNumber = Random().nextInt(colorList.length);
  return colorList[randomNumber];
}
