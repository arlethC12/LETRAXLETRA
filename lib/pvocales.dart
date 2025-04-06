import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async'; // Importar dart:async para usar Completer
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
    try {
      final imageProvider = AssetImage('assets/footprint.png');
      final completer =
          Completer<ui.Image>(); // Ahora Completer debería estar definido
      final imageStream = imageProvider.resolve(ImageConfiguration());
      ImageStreamListener? imageStreamListener;
      imageStreamListener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          completer.complete(info.image);
          imageStream.removeListener(imageStreamListener!);
        },
        onError: (exception, stackTrace) {
          completer.completeError(exception, stackTrace);
        },
      );
      imageStream.addListener(imageStreamListener);
      _footprintImage = await completer.future;
      setState(() {});
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'VOCALES',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20),
              Stack(
                children: [
                  Positioned(
                    left: 50,
                    top: 20,
                    child: _buildLetter('A', Colors.red),
                  ),
                  Positioned(
                    right: 50,
                    top: 100,
                    child: _buildLetter('E', Colors.green),
                  ),
                  Positioned(
                    left: 50,
                    top: 200,
                    child: _buildLetter('O', Colors.orange),
                  ),
                  Positioned(
                    left: 50,
                    top: 300,
                    child: _buildLetter('U', Colors.yellow),
                  ),
                  Positioned(
                    right: 50,
                    top: 0,
                    child: Image.asset(
                      'assets/tiger.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Positioned(left: 20, top: 50, child: _buildStars()),
                  Positioned(right: 20, top: 150, child: _buildStars()),
                  Positioned(left: 20, top: 250, child: _buildStars()),
                  Positioned(left: 20, top: 350, child: _buildStars()),
                  if (_footprintImage != null)
                    CustomPaint(
                      size: Size(double.infinity, 400),
                      painter: FootprintsPainter(_footprintImage!),
                    ),
                ],
              ),
              Spacer(),
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.mic, size: 40, color: Colors.black),
                    Icon(Icons.book, size: 40, color: Colors.black),
                    Icon(Icons.home, size: 40, color: Colors.black),
                    Icon(Icons.brush, size: 40, color: Colors.black),
                    Icon(Icons.videogame_asset, size: 40, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLetter(String letter, Color color) {
    return Container(
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
    );
  }

  Widget _buildStars() {
    return Row(
      children: List.generate(
        3,
        (index) => Icon(Icons.star, color: Colors.yellow, size: 30),
      ),
    );
  }
}

class FootprintsPainter extends CustomPainter {
  final ui.Image footprintImage;

  FootprintsPainter(this.footprintImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final points = [
      Offset(90, 60), // A
      Offset(300, 140), // E
      Offset(90, 240), // O
      Offset(90, 340), // U
    ];

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
