import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: VowelsScreen());
  }
}

class VowelsScreen extends StatefulWidget {
  @override
  _VowelsScreenState createState() => _VowelsScreenState();
}

class _VowelsScreenState extends State<VowelsScreen> {
  ui.Image? _footprintImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final imageProvider = AssetImage('assets/footprint.png');
    final completer = Completer<ui.Image>();
    final imageStream = imageProvider.resolve(ImageConfiguration());
    ImageStreamListener? listener;

    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      imageStream.removeListener(listener!);
    });

    imageStream.addListener(listener);
    _footprintImage = await completer.future;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Unidad 1, Sección 1 - Vocales',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Stack(
        children: [
          _buildCrownAndVowels(),
          if (_footprintImage != null)
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: FootprintsPainter(_footprintImage!),
            ),
        ],
      ),
    );
  }

  Widget _buildCrownAndVowels() {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildVowel("A", Colors.red, Offset(50, 50)),
        _buildVowel("E", Colors.green, Offset(250, 150)),
        _buildVowel("I", Colors.blue, Offset(50, 250)),
        _buildVowel("O", Colors.orange, Offset(250, 350)),
        _buildVowel("U", Colors.purple, Offset(50, 450)),
        Spacer(),
        Image.asset('assets/crown.png', width: 100, height: 100),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVowel(String letter, Color color, Offset position) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Icon(Icons.star, color: Colors.yellow, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class FootprintsPainter extends CustomPainter {
  final ui.Image footprintImage;

  FootprintsPainter(this.footprintImage);

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(90, 90),
      Offset(270, 190),
      Offset(90, 290),
      Offset(270, 390),
      Offset(90, 490),
    ];
    final paint = Paint();

    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      final distance = (end - start).distance;
      final steps = (distance / 30).floor();

      for (int j = 0; j < steps; j++) {
        final t = j / steps;
        final x = start.dx + (end.dx - start.dx) * t;
        final y = start.dy + (end.dy - start.dy) * t;
        final dx = end.dx - start.dx;
        final dy = end.dy - start.dy;
        final angle = math.atan2(dy, dx);

        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        canvas.drawImageRect(
          footprintImage,
          Rect.fromLTWH(
            0,
            0,
            footprintImage.width.toDouble(),
            footprintImage.height.toDouble(),
          ),
          Rect.fromCenter(center: Offset.zero, width: 20, height: 20),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
