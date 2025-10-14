import 'package:flutter/material.dart';

const Map<String, String> vowelEmojis = {
  'A': '🍎',
  'E': '🐘',
  'I': '🍦',
  'O': '🍊',
  'U': '🦄',
};

const Map<String, Color> vowelColors = {
  'A': Colors.red,
  'E': Colors.blue,
  'I': Colors.pink,
  'O': Colors.orange,
  'U': Colors.purple,
};

const int gameTime = 60;

abstract class BaseGame extends StatefulWidget {
  final VoidCallback onComplete;
  BaseGame({required this.onComplete});
}
