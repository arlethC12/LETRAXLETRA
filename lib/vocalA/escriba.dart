import 'package:flutter/material.dart';
import 'compalabra.dart'; // Asegúrate de que compalabra.dart esté en la misma carpeta o ajusta la ruta
import 'vocala.dart'; // Importa vocala.dart (ajusta la ruta si es necesario)

void main() {
  runApp(const MyApp());
}

// Definimos una clase raíz para gestionar el MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/letter_tracing',
      routes: {
        '/letter_tracing': (context) => LetterTracingScreen(),
        '/compalabra': (context) => CompalabraScreen(),
        '/vocala':
            (context) => const VocalAPage(), // Añade la ruta para vocala.dart
      },
    );
  }
}

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({super.key});

  @override
  _LetterTracingScreenState createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen> {
  List<Offset?> points = [];
  Offset? currentPencilPos;
  bool isValid = false;
  String feedbackMessage = 'Dibuja la letra A.';
  bool isUpperCase = true;

  // Regiones clave para la "A" mayúscula
  List<Rect> getKeyRegionsForUpperCaseA(Size canvasSize) {
    double width = canvasSize.width;
    double height = canvasSize.height;
    double margin = 20.0; // Margen de tolerancia

    return [
      // Diagonal izquierda: desde (0.3w, 0.8h) a (0.5w, 0.2h)
      Rect.fromPoints(
        Offset(0.3 * width - margin, 0.8 * height - margin),
        Offset(0.5 * width + margin, 0.2 * height + margin),
      ),
      // Diagonal derecha: desde (0.7w, 0.8h) a (0.5w, 0.2h)
      Rect.fromPoints(
        Offset(0.5 * width - margin, 0.2 * height - margin),
        Offset(0.7 * width + margin, 0.8 * height + margin),
      ),
      // Trazo horizontal: desde (0.35w, 0.5h) a (0.65w, 0.5h)
      Rect.fromPoints(
        Offset(0.35 * width - margin, 0.5 * height - margin),
        Offset(0.65 * width + margin, 0.5 * height + margin),
      ),
    ];
  }

  // Regiones clave para la "a" minúscula
  List<Rect> getKeyRegionsForLowerCaseA(Size canvasSize) {
    double width = canvasSize.width;
    double height = canvasSize.height;
    double margin = 20.0; // Margen de tolerancia

    return [
      // Círculo (cuerpo de la "a")
      Rect.fromCenter(
        center: Offset(0.5 * width, 0.4 * height),
        width: 0.3 * width + 2 * margin,
        height: 0.3 * height + 2 * margin,
      ),
      // Trazo vertical
      Rect.fromPoints(
        Offset(0.65 * width - margin, 0.4 * height),
        Offset(0.65 * width + margin, 0.7 * height),
      ),
    ];
  }

  // Validar el dibujo
  void validateDrawing(Size canvasSize) {
    if (points.isEmpty) {
      setState(() {
        isValid = false;
        feedbackMessage = 'Dibuja la letra ${isUpperCase ? "A" : "a"}.';
      });
      return;
    }

    List<Rect> keyRegions =
        isUpperCase
            ? getKeyRegionsForUpperCaseA(canvasSize)
            : getKeyRegionsForLowerCaseA(canvasSize);
    List<int> pointsInRegion = List.filled(keyRegions.length, 0);

    for (var point in points) {
      if (point == null) continue;
      for (int i = 0; i < keyRegions.length; i++) {
        if (keyRegions[i].contains(point)) {
          pointsInRegion[i]++;
        }
      }
    }

    // Requerir al menos 15 puntos en cada región para considerarla cubierta
    bool allRegionsCovered = pointsInRegion.every((count) => count >= 15);

    setState(() {
      isValid = allRegionsCovered;
      feedbackMessage =
          allRegionsCovered
              ? '¡Letra ${isUpperCase ? "A" : "a"} dibujada correctamente!'
              : 'Dibuja la letra ${isUpperCase ? "A" : "a"} como en la imagen.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      // Navegar a vocala.dart y reemplazar la pantalla actual
                      Navigator.pushReplacementNamed(context, '/vocala');
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: isValid ? 1.0 : 0.2,
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

            // Instrucción
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    'Escribe la letra ${isUpperCase ? "A" : "a"}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Imagen de referencia
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  isUpperCase ? 'assets/letraA.jpg' : 'assets/letraA.jpg',
                  fit: BoxFit.contain,
                  opacity: const AlwaysStoppedAnimation(0.5),
                ),
              ),
            ),

            // Retroalimentación
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                feedbackMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: isValid ? Colors.green : Colors.red,
                ),
              ),
            ),

            // Botón para alternar entre A y a
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUpperCase = true;
                        points.clear();
                        currentPencilPos = null;
                        isValid = false;
                        feedbackMessage = 'Dibuja la letra A.';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isUpperCase ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('A mayúscula'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUpperCase = false;
                        points.clear();
                        currentPencilPos = null;
                        isValid = false;
                        feedbackMessage = 'Dibuja la letra a.';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isUpperCase ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('a minúscula'),
                  ),
                ],
              ),
            ),

            // Pizarra para dibujar
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double canvasWidth = constraints.maxWidth * 1.1;
                  double canvasHeight = canvasWidth * 0.8;

                  canvasWidth = canvasWidth.clamp(0, constraints.maxWidth);
                  canvasHeight = canvasHeight.clamp(0, constraints.maxHeight);

                  return Center(
                    child: Container(
                      width: canvasWidth,
                      height: canvasHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          // Área de dibujo
                          Positioned.fill(
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                Offset localPosition = box.globalToLocal(
                                  details.globalPosition,
                                );
                                if (localPosition.dx >= 0 &&
                                    localPosition.dx <= canvasWidth &&
                                    localPosition.dy >= 0 &&
                                    localPosition.dy <= canvasHeight) {
                                  setState(() {
                                    points.add(localPosition);
                                    currentPencilPos = localPosition;
                                  });
                                }
                              },
                              onPanEnd: (_) {
                                setState(() {
                                  points.add(null);
                                  currentPencilPos = null;
                                  validateDrawing(
                                    Size(canvasWidth, canvasHeight),
                                  );
                                });
                              },
                              child: CustomPaint(
                                painter: LetterPainter(points),
                                child: Container(),
                              ),
                            ),
                          ),
                          // Lápiz
                          if (currentPencilPos != null)
                            Positioned(
                              left: currentPencilPos!.dx - 12,
                              top: currentPencilPos!.dy - 24,
                              child: const Icon(
                                Icons.create,
                                color: Color.fromARGB(255, 209, 132, 17),
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botones
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        points.clear();
                        currentPencilPos = null;
                        isValid = false;
                        feedbackMessage =
                            'Dibuja la letra ${isUpperCase ? "A" : "a"}.';
                      });
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Borrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await Navigator.pushNamed(context, '/compalabra');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al navegar: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text('Siguiente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
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
    Paint paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
