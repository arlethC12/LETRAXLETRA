import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalO/seleccionaimagen.dart'; // Importa seleccionaimagen.dart
import 'package:letra_x_letra/vocalO/videovocalO.dart'; // Importa videovocalO.dart

void main() {
  runApp(const OescribePage());
}

// Definimos una clase raíz para gestionar el MaterialApp
class OescribePage extends StatelessWidget {
  const OescribePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LetterTracingScreen(),
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
  String feedbackMessage = 'Dibuja la letra O.';
  bool isUpperCase = true;
  bool isUpperCaseCompleted = false; // Track uppercase O completion
  bool isLowerCaseCompleted = false; // Track lowercase o completion

  // Regiones clave para la "O" mayúscula
  List<Rect> getKeyRegionsForUpperCaseO(Size canvasSize) {
    double width = canvasSize.width;
    double height = canvasSize.height;
    double margin = 25.0; // Margen de tolerancia
    double centerX = 0.5 * width;
    double centerY = 0.5 * height;
    double radius = 0.35 * width; // Radio aproximado de la O mayúscula

    // Dividimos el círculo en 8 regiones rectangulares alrededor de la circunferencia
    return [
      // Superior
      Rect.fromCenter(
        center: Offset(centerX, centerY - radius),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Superior-derecha
      Rect.fromCenter(
        center: Offset(centerX + radius * 0.707, centerY - radius * 0.707),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Derecha
      Rect.fromCenter(
        center: Offset(centerX + radius, centerY),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Inferior-derecha
      Rect.fromCenter(
        center: Offset(centerX + radius * 0.707, centerY + radius * 0.707),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Inferior
      Rect.fromCenter(
        center: Offset(centerX, centerY + radius),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Inferior-izquierda
      Rect.fromCenter(
        center: Offset(centerX - radius * 0.707, centerY + radius * 0.707),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Izquierda
      Rect.fromCenter(
        center: Offset(centerX - radius, centerY),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
      // Superior-izquierda
      Rect.fromCenter(
        center: Offset(centerX - radius * 0.707, centerY - radius * 0.707),
        width: 0.2 * width + 2 * margin,
        height: 0.2 * height + 2 * margin,
      ),
    ];
  }

  // Regiones clave para la "o" minúscula
  List<Rect> getKeyRegionsForLowerCaseO(Size canvasSize) {
    double width = canvasSize.width;
    double height = canvasSize.height;
    double margin = 20.0; // Margen de tolerancia
    double centerX = 0.5 * width;
    double centerY = 0.55 * height; // Ligeramente más abajo para minúscula
    double radius = 0.25 * width; // Radio más pequeño para la o minúscula

    // Dividimos el círculo en 8 regiones rectangulares
    return [
      // Superior
      Rect.fromCenter(
        center: Offset(centerX, centerY - radius),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Superior-derecha
      Rect.fromCenter(
        center: Offset(centerX + radius * 0.707, centerY - radius * 0.707),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Derecha
      Rect.fromCenter(
        center: Offset(centerX + radius, centerY),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Inferior-derecha
      Rect.fromCenter(
        center: Offset(centerX + radius * 0.707, centerY + radius * 0.707),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Inferior
      Rect.fromCenter(
        center: Offset(centerX, centerY + radius),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Inferior-izquierda
      Rect.fromCenter(
        center: Offset(centerX - radius * 0.707, centerY + radius * 0.707),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Izquierda
      Rect.fromCenter(
        center: Offset(centerX - radius, centerY),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
      // Superior-izquierda
      Rect.fromCenter(
        center: Offset(centerX - radius * 0.707, centerY - radius * 0.707),
        width: 0.15 * width + 2 * margin,
        height: 0.15 * height + 2 * margin,
      ),
    ];
  }

  // Validar el dibujo
  void validateDrawing(Size canvasSize) {
    if (points.isEmpty) {
      setState(() {
        isValid = false;
        feedbackMessage = 'Dibuja la letra ${isUpperCase ? "O" : "o"}.';
      });
      return;
    }

    List<Rect> keyRegions =
        isUpperCase
            ? getKeyRegionsForUpperCaseO(canvasSize)
            : getKeyRegionsForLowerCaseO(canvasSize);
    List<int> pointsInRegion = List.filled(keyRegions.length, 0);

    for (var point in points) {
      if (point == null) continue;
      for (int i = 0; i < keyRegions.length; i++) {
        if (keyRegions[i].contains(point)) {
          pointsInRegion[i]++;
        }
      }
    }

    // Requerir al menos 10 puntos en cada región para considerarlas cubiertas
    bool allRegionsCovered = true;
    for (int i = 0; i < pointsInRegion.length; i++) {
      if (pointsInRegion[i] < 10) {
        allRegionsCovered = false;
        break;
      }
    }

    setState(() {
      isValid = allRegionsCovered;
      if (allRegionsCovered) {
        if (isUpperCase) {
          isUpperCaseCompleted = true;
        } else {
          isLowerCaseCompleted = true;
        }
        feedbackMessage =
            '¡Letra ${isUpperCase ? "O" : "o"} dibujada correctamente!';
      } else {
        feedbackMessage =
            'Dibuja la letra ${isUpperCase ? "O" : "o"} como en la imagen.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLessonCompleted = isUpperCaseCompleted && isLowerCaseCompleted;

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
                      // Navegar a la pantalla de videovocalO.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const VocalOPage(
                                characterImagePath: '',
                                username: '',
                              ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value:
                            isLessonCompleted
                                ? 1.0
                                : (isUpperCaseCompleted || isLowerCaseCompleted)
                                ? 0.6
                                : 0.2,
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
                    'Escribe la letra ${isUpperCase ? "O" : "o"}',
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
                  isUpperCase ? 'assets/letraO.jpg' : 'assets/letraO.jpg',
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

            // Botón para alternar entre O y o
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
                        feedbackMessage = 'Dibuja la letra O.';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isUpperCase ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('O mayúscula'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUpperCase = false;
                        points.clear();
                        currentPencilPos = null;
                        isValid = false;
                        feedbackMessage = 'Dibuja la letra o.';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isUpperCase ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('o minúscula'),
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
                            'Dibuja la letra ${isUpperCase ? "O" : "o"}.';
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
                  if (isLessonCompleted)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navegar a la pantalla de seleccionaimagen.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => selectimagenO(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
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
