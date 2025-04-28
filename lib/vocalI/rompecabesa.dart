import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  Map<String, bool> partPlaced = {
    'top': false,
    'middle': false,
    'bottom': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso con X ajustada
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      minHeight: 8.0,
                    ),
                  ),
                ),
                Positioned(
                  left: 2,
                  top: 1,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: const Color.fromARGB(255, 24, 23, 21),
                      size: 25,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Arma el siguiente rompecabezas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (partPlaced['top']! ||
                        partPlaced['middle']! ||
                        partPlaced['bottom']!)
                      CustomPaint(
                        size: Size(200, 350),
                        painter: ICompletePainter(
                          showTop: partPlaced['top']!,
                          showMiddle: partPlaced['middle']!,
                          showBottom: partPlaced['bottom']!,
                        ),
                      ),
                    if (!partPlaced['top']!)
                      Positioned(
                        left: 50,
                        top: 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              partPlaced['top'] = true;
                            });
                          },
                          child: PuzzlePart(
                            label: "Parte Superior",
                            painter: ITopPartPainter(),
                            size: Size(100, 25),
                          ),
                        ),
                      ),
                    if (!partPlaced['middle']!)
                      Positioned(
                        right: 50,
                        bottom: 100,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              partPlaced['middle'] = true;
                            });
                          },
                          child: PuzzlePart(
                            label: "Parte Media",
                            painter: IMiddlePartPainter(),
                            size: Size(35, 125),
                          ),
                        ),
                      ),
                    if (!partPlaced['bottom']!)
                      Positioned(
                        left: 30,
                        bottom: 150,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              partPlaced['bottom'] = true;
                            });
                          },
                          child: PuzzlePart(
                            label: "Parte Inferior",
                            painter: IBottomPartPainter(),
                            size: Size(100, 25),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.orange,
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pintar la "I" completa con colores diferentes
class ICompletePainter extends CustomPainter {
  final bool showTop;
  final bool showMiddle;
  final bool showBottom;

  ICompletePainter({
    required this.showTop,
    required this.showMiddle,
    required this.showBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    if (showTop) {
      Paint topPaint =
          Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.fill;
      Path topPath = Path();
      topPath.addRect(Rect.fromLTWH(0, 0, width, 50));
      canvas.drawPath(topPath, topPaint);
    }

    if (showMiddle) {
      Paint middlePaint =
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.fill;
      Path middlePath = Path();
      middlePath.addRect(
        Rect.fromLTWH(width * 0.35, 50, width * 0.3, height - 100),
      );
      canvas.drawPath(middlePath, middlePaint);
    }

    if (showBottom) {
      Paint bottomPaint =
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.fill;
      Path bottomPath = Path();
      bottomPath.addRect(Rect.fromLTWH(0, height - 50, width, 50));
      canvas.drawPath(bottomPath, bottomPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Pintores de piezas individuales (solo borde)
class ITopPartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IMiddlePartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IBottomPartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Widget de pieza de puzzle
class PuzzlePart extends StatelessWidget {
  final String label;
  final CustomPainter painter;
  final Size size;

  const PuzzlePart({
    required this.label,
    required this.painter,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width + 20,
      height: size.height + 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 2)),
        ],
      ),
      child: CustomPaint(
        painter: painter,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
