import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalO/seleccionaimagen.dart';
import 'package:letra_x_letra/vocalO/unirpieza.dart';

void main() {
  runApp(CaminoOveja());
}

class CaminoOveja extends StatelessWidget {
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
  bool isGameCompleted = false; // Controla el estado del juego
  Offset sheepPosition = Offset.zero; // Posición actual de las ovejas pequeñas
  AnimationController? _controller;
  Animation<double>? _animation;
  int currentPointIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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
                showSmallSheep = false;
                showSheepAtGrass = true;
                showNextButton = true;
                isGameCompleted = true; // Marca el juego como completado
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
      sheepPosition = points[0];
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.all(16.0),
                        elevation: 0,
                      ),
                      onPressed: () {
                        print('Botón X presionado');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Botón X presionado')),
                        );
                        try {
                          print('Intentando navegar a selectimagenO');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => selectimagenO(),
                            ),
                          );
                          print('Navegación a selectimagenO exitosa');
                        } catch (e) {
                          print('Error al navegar a selectimagenO: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al navegar: $e')),
                          );
                        }
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30, // Tamaño reducido de la "X"
                      ),
                    ),
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
                        minHeight:
                            10, // Barra de progreso más ancha (altura aumentada)
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ), // Tamaño de fuente reducido
                textAlign: TextAlign.center,
              ),
            ),
            // Elementos de la pantalla
            const Positioned(
              top: 120,
              left: 50,
              child: Text(
                'O',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.orange,
                ), // Tamaño de letra "O" reducido
              ),
            ),
            if (showSmallSheep &&
                (_controller == null || !_controller!.isAnimating))
              const Positioned(
                top: 120,
                right: 50,
                child: Text('🐑🐑', style: TextStyle(fontSize: 40)),
              ),
            if (_controller != null && _controller!.isAnimating)
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
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.orange,
                ), // Tamaño de letra "O" reducido
              ),
            ),
            if (showSheepAtGrass)
              const Positioned(
                bottom: 20,
                right: 110,
                child: Text('🐑', style: TextStyle(fontSize: 60)),
              ),
            const Positioned(
              bottom: 20,
              right: 110,
              child: Text('🌱🌱🌱', style: TextStyle(fontSize: 40)),
            ),
            // Área para dibujar la línea (ajustada para no interferir con el botón)
            Positioned(
              top:
                  100, // Dejamos espacio para el botón y el texto de instrucción
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanStart:
                    isGameCompleted
                        ? null
                        : (details) {
                          setState(() {
                            isDrawing = true;
                            points.clear();
                            points.add(details.localPosition);
                          });
                        },
                onPanUpdate:
                    isGameCompleted
                        ? null
                        : (details) {
                          if (isDrawing) {
                            setState(() {
                              points.add(details.localPosition);
                            });
                          }
                        },
                onPanEnd:
                    isGameCompleted
                        ? null
                        : (details) {
                          setState(() {
                            isDrawing = false;
                          });
                          startSheepAnimation();
                        },
                child: CustomPaint(painter: LinePainter(points)),
              ),
            ),
            // Botón de flecha
            if (showNextButton)
              Positioned(
                bottom: 40,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UnirpiezaO()),
                    );
                  },
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                  backgroundColor: Colors.orange,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

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
