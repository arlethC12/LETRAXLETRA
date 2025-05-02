import 'package:flutter/material.dart';
import 'dart:math';
import 'package:letra_x_letra/vocalO/unirpieza.dart';
import 'package:letra_x_letra/vocalO/BurbujaO.dart';

void main() {
  runApp(Helado());
}

class Helado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: PuzzleScreen());
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  bool isPuzzleCompleted = false;
  List<bool> piecesPlaced = [
    false,
    false,
    false,
    false,
  ]; // Cono, verde, amarillo, morado

  void checkPuzzleCompletion() {
    setState(() {
      isPuzzleCompleted = piecesPlaced.every((placed) => placed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  //navega a unirpueza.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnirpiezaO()),
                  );
                },
              ),
            ),
            Positioned(
              top: 10,
              left: 50,
              right: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value:
                      piecesPlaced.where((placed) => placed).length /
                      piecesPlaced.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  minHeight: 10,
                ),
              ),
            ),
            Center(
              child:
                  isPuzzleCompleted
                      ? _buildCompletedIceCream()
                      : _buildPuzzlePieces(),
            ),
            if (isPuzzleCompleted)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      // Navegar a BurbujaO.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BurbujaOScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzlePieces() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Draggable<int>(
              data: 1,
              child:
                  piecesPlaced[1]
                      ? SizedBox.shrink()
                      : _buildIceCreamBall(
                        Colors.green,
                        hasEar: true,
                        showLetterO: true,
                      ),
              feedback: _buildIceCreamBall(
                Colors.green,
                hasEar: true,
                showLetterO: true,
              ),
            ),
            Draggable<int>(
              data: 2,
              child:
                  piecesPlaced[2]
                      ? SizedBox.shrink()
                      : _buildIceCreamBall(Colors.yellow, hasEyes: true),
              feedback: _buildIceCreamBall(Colors.yellow, hasEyes: true),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Draggable<int>(
              data: 0,
              child: piecesPlaced[0] ? SizedBox.shrink() : _buildCone(),
              feedback: _buildCone(),
            ),
            Draggable<int>(
              data: 3,
              child:
                  piecesPlaced[3]
                      ? SizedBox.shrink()
                      : _buildIceCreamBall(Colors.purple, hasZeroEyes: true),
              feedback: _buildIceCreamBall(Colors.purple, hasZeroEyes: true),
            ),
          ],
        ),
        SizedBox(height: 50),
        DragTarget<int>(
          onAccept: (data) {
            setState(() {
              piecesPlaced[data] = true;
              checkPuzzleCompletion();
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 150,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text("Arrastra las piezas aquí")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCompletedIceCream() {
    return Container(
      width: 150,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(bottom: 0, child: _buildCone()),
          Positioned(
            bottom: 80,
            child: _buildIceCreamBall(Colors.yellow, hasEyes: true),
          ),
          Positioned(
            bottom: 120,
            child: _buildIceCreamBall(Colors.purple, hasZeroEyes: true),
          ),
          Positioned(
            bottom: 160,
            child: _buildIceCreamBall(
              Colors.green,
              hasEar: true,
              showLetterO: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCone() {
    return Container(
      width: 100,
      height: 100,
      child: CustomPaint(painter: ConePainter()),
    );
  }

  Widget _buildIceCreamBall(
    Color color, {
    bool hasEar = false,
    bool hasEyes = false,
    bool hasZeroEyes = false,
    bool showLetterO = false,
  }) {
    return Container(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: IceCreamBallPainter(
          color: color,
          hasEar: hasEar,
          hasEyes: hasEyes,
          hasZeroEyes: hasZeroEyes,
          showLetterO: showLetterO,
        ),
      ),
    );
  }
}

class ConePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.brown;
    final path = Path();
    path.moveTo(size.width / 2, size.height); // Punta
    path.lineTo(0, 0); // Lado izquierdo
    path.lineTo(size.width, 0); // Lado derecho
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    for (int i = 1; i < 5; i++) {
      double y = i * size.height / 5;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width - (i * size.width / 5), y),
        paint,
      );
      canvas.drawLine(
        Offset(i * size.width / 5, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IceCreamBallPainter extends CustomPainter {
  final Color color;
  final bool hasEar;
  final bool hasEyes;
  final bool hasZeroEyes;
  final bool showLetterO;

  IceCreamBallPainter({
    required this.color,
    this.hasEar = false,
    this.hasEyes = false,
    this.hasZeroEyes = false,
    this.showLetterO = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dibuja círculo perfecto
    canvas.drawCircle(center, radius, paint);

    // Dibujar la oreja (bola verde)
    if (hasEar) {
      final earPaint = Paint()..color = color;
      final earPath = Path();
      earPath.moveTo(size.width / 2, 0);
      earPath.lineTo(size.width / 2 - 20, -30);
      earPath.lineTo(size.width / 2 + 20, -30);
      earPath.close();
      canvas.drawPath(earPath, earPaint);
    }

    // Dibujar la letra "O" (bola verde)
    if (showLetterO) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: "O",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(center.dx - 8, center.dy));
    }

    // Dibujar ojos (bola amarilla)
    if (hasEyes) {
      final eyePaint = Paint()..color = Colors.black;
      canvas.drawCircle(Offset(size.width / 3, size.height / 3), 8, eyePaint);
      canvas.drawCircle(
        Offset(2 * size.width / 3, size.height / 3),
        8,
        eyePaint,
      );

      final whitePaint = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(size.width / 3 + 2, size.height / 3 - 2),
        4,
        whitePaint,
      );
      canvas.drawCircle(
        Offset(2 * size.width / 3 + 2, size.height / 3 - 2),
        4,
        whitePaint,
      );
    }

    // Dibujar "0o" (bola morada)
    if (hasZeroEyes) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: "0o",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(center.dx - 12, center.dy - 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
