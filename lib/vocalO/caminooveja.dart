import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  List<Offset> points = []; // Lista para almacenar los puntos de la línea
  bool isDrawing = false;
  bool showSheepAtGrass =
      false; // Controla la aparición de la oveja en el pasto
  bool showSmallSheep = true; // Controla la visibilidad de las ovejas pequeñas
  bool showNextButton = false; // Controla la aparición del botón con flecha
  Offset sheepPosition =
      Offset
          .zero; // Posición actual de las ovejas pequeñas durante la animación
  AnimationController? _controller;
  Animation<double>? _animation;
  int currentPointIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duración de la animación
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: 1).animate(_controller!)
          ..addListener(() {
            if (points.isNotEmpty && currentPointIndex < points.length - 1) {
              setState(() {
                double progress = _animation!.value;
                int totalPoints = points.length;
                int targetIndex = (progress * (totalPoints - 1)).floor();
                if (targetIndex != currentPointIndex) {
                  currentPointIndex = targetIndex;
                  sheepPosition = points[currentPointIndex];
                }
              });
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                showSmallSheep = false; // Oculta las ovejas pequeñas
                showSheepAtGrass = true; // Muestra la oveja grande en el pasto
                showNextButton = true; // Muestra el botón con flecha
              });
            }
          });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void startSheepAnimation() {
    if (points.isNotEmpty) {
      sheepPosition = points[0]; // Inicia en el primer punto del trazo
      currentPointIndex = 0;
      _controller?.reset();
      _controller?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Barra de progreso y "X"
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      // Acción para cerrar
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Texto de instrucción
            const Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Text(
                'Traza la línea para que la ovejita pueda comer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Elementos de la pantalla
            const Positioned(
              top: 120,
              left: 50,
              child: Text(
                'O',
                style: TextStyle(fontSize: 100, color: Colors.orange),
              ),
            ),
            if (showSmallSheep &&
                (_controller == null ||
                    !_controller!.isAnimating)) // Ovejas pequeñas iniciales
              const Positioned(
                top: 120,
                right: 50,
                child: Text('🐑🐑', style: TextStyle(fontSize: 40)),
              ),
            if (_controller != null &&
                _controller!.isAnimating) // Ovejas pequeñas moviéndose
              Positioned(
                left: sheepPosition.dx - 40,
                top: sheepPosition.dy - 40,
                child: const Text('🐑🐑', style: TextStyle(fontSize: 40)),
              ),
            const Positioned(
              bottom: 50,
              left: 50,
              child: Text(
                'O',
                style: TextStyle(fontSize: 100, color: Colors.orange),
              ),
            ),
            if (showSheepAtGrass) // Oveja grande en el pasto
              const Positioned(
                bottom: 20, // Misma posición que el pasto
                right: 110, // Misma posición que el pasto
                child: Text('🐑', style: TextStyle(fontSize: 60)),
              ),
            const Positioned(
              bottom: 20,
              right: 110, // Posición del pasto
              child: Text('🌱🌱🌱', style: TextStyle(fontSize: 40)),
            ),
            // Área para dibujar la línea
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    isDrawing = true;
                    points.clear();
                    points.add(details.localPosition);
                  });
                },
                onPanUpdate: (details) {
                  if (isDrawing) {
                    setState(() {
                      points.add(details.localPosition);
                    });
                  }
                },
                onPanEnd: (details) {
                  setState(() {
                    isDrawing = false;
                  });
                  startSheepAnimation(); // Inicia la animación de las ovejas
                },
                child: CustomPaint(painter: LinePainter(points)),
              ),
            ),
            // Botón de flecha (aparece cuando la oveja llega al pasto)
            if (showNextButton)
              Positioned(
                bottom: 40,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    // Acción para el botón de flecha
                  },
                  child: const Icon(
                    Icons.arrow_forward, // Flecha hacia la derecha
                    color: Colors.white, // Flecha blanca
                  ),
                  backgroundColor: Colors.orange, // Botón naranja
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Clase para dibujar la línea
class LinePainter extends CustomPainter {
  final List<Offset> points;

  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    if (points.isNotEmpty) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
