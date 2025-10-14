import 'package:flutter/material.dart';

class Letter {
  final String letter;
  final double x;
  final Animation<double> animation;

  Letter({required this.letter, required this.x, required this.animation});
}
