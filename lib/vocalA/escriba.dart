import 'package:flutter/material.dart';

void main() => runApp(EscribaScreen());

class EscribaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LetterTracingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LetterTracingScreen extends StatefulWidget {
  @override
  _LetterTracingScreenState createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen> {
  List<Offset?> points = [];
  Offset? currentPencilPos;

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.8;
    final double imageHeight = 300;
    final double horizontalMargin =
        (MediaQuery.of(context).size.width - imageWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior con progreso y botón de salir
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.orange),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: 0.1,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Texto de instrucción con ícono de audio
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Icon(Icons.volume_up, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Escribe la letra A',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Área de dibujo con imagen y lápiz
            Expanded(
              child: Center(
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Stack(
                    children: [
                      // Imagen guía con opacidad
                      Opacity(
                        opacity: 0.2,
                        child: Image.asset(
                          'assets/letraA.jpg',
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.red.withOpacity(0.1),
                              child: const Center(
                                child: Text(
                                  'No se pudo cargar la imagen\nVerifica assets/letraA.jpg',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Área para pintar
                      GestureDetector(
                        onPanUpdate: (details) {
                          RenderBox box =
                              context.findRenderObject() as RenderBox;
                          Offset localPosition = box.globalToLocal(
                            details.globalPosition,
                          );

                          double dx = localPosition.dx;
                          double dy =
                              localPosition.dy - 160; // ajuste por padding

                          if (dx >= horizontalMargin &&
                              dx <= horizontalMargin + imageWidth &&
                              dy >= 0 &&
                              dy <= imageHeight) {
                            setState(() {
                              points.add(Offset(dx - horizontalMargin, dy));
                              currentPencilPos = Offset(
                                dx - horizontalMargin,
                                dy,
                              );
                            });
                          }
                        },
                        onPanEnd: (_) {
                          setState(() {
                            points.add(null);
                            currentPencilPos = null;
                          });
                        },
                        child: CustomPaint(
                          painter: LetterPainter(points),
                          child: Container(),
                        ),
                      ),

                      // Ícono de lápiz donde se está dibujando
                      if (currentPencilPos != null)
                        Positioned(
                          left: currentPencilPos!.dx - 10,
                          top: currentPencilPos!.dy - 20,
                          child: const Icon(
                            Icons.create,
                            color: Color.fromARGB(255, 209, 132, 17),
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Botón de siguiente (por ahora borra el trazo)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    points.clear();
                    currentPencilPos = null;
                  });
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LetterPainter extends CustomPainter {
  final List<Offset?> points;

  LetterPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pathPaint =
        Paint()
          ..color = const Color.fromARGB(255, 12, 13, 14)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, pathPaint);
      }
    }
  }

  @override
  bool shouldRepaint(LetterPainter oldDelegate) => true;
}
