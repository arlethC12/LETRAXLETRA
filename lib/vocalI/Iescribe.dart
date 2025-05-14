import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Importa el paquete audioplayers
import 'package:letra_x_letra/vocalI/pintai.dart'; // Importa pintai.dart (contiene ColorPuzzleScreen)
import 'package:letra_x_letra/vocalI/videovocalI.dart'; // Importa videovocalI.dart

void main() {
  runApp(const IescribeEPage());
}

// Definimos una clase raíz para gestionar el MaterialApp
class IescribeEPage extends StatelessWidget {
  const IescribeEPage({super.key});

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
  String feedbackMessage = 'Dibuja la letra I.';
  bool isUpperCase = true;
  bool isUpperCaseCompleted = false; // Track uppercase I completion
  bool isLowerCaseCompleted = false; // Track lowercase i completion
  final AudioPlayer _audioPlayer = AudioPlayer(); // Instancia de AudioPlayer

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera los recursos del reproductor
    super.dispose();
  }

  // Función para reproducir el audio
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalI/Escribe la letra I .m4a'),
      );
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  // Regiones clave para la "I" mayúscula
  List<Rect> getKeyRegionsForUpperCaseI(Size canvasSize) {
    double width = canvasSize.width;
    double height = canvasSize.height;
    double marginVertical = 25.0; // Margen para la línea vertical
    double marginHorizontal =
        30.0; // Margen aumentado para las barras horizontales

    return [
      // Trazo vertical: desde (0.5w, 0.15h) a (0.5w, 0.85h)
      Rect.fromPoints(
        Offset(0.5 * width - marginVertical, 0.15 * height - marginVertical),
        Offset(0.5 * width + marginVertical, 0.85 * height + marginVertical),
      ),
      // Barra superior: desde (0.35w, 0.15h) a (0.65w, 0.15h)
      Rect.fromPoints(
        Offset(
          0.35 * width - marginHorizontal,
          0.15 * height - marginHorizontal,
        ),
        Offset(
          0.65 * width + marginHorizontal,
          0.15 * height + marginHorizontal,
        ),
      ),
      // Barra inferior: desde (0.35w, 0.85h) a (0.65w, 0.85h)
      Rect.fromPoints(
        Offset(
          0.35 * width - marginHorizontal,
          0.85 * height - marginHorizontal,
        ),
        Offset(
          0.65 * width + marginHorizontal,
          0.85 * height + marginHorizontal,
        ),
      ),
    ];
  }

  // Regiones clave para la "i" minúscula
  List<Rect> getKeyRegionsForLowerCaseI(Size canvasSize) {
    double width = canvasSize.width;
    double height = canvasSize.height;
    double margin = 20.0; // Margen de tolerancia

    return [
      // Trazo vertical: desde (0.5w, 0.4h) a (0.5w, 0.7h)
      Rect.fromPoints(
        Offset(0.5 * width - margin, 0.4 * height - margin),
        Offset(0.5 * width + margin, 0.7 * height + margin),
      ),
      // Punto superior: alrededor de (0.5w, 0.3h)
      Rect.fromCenter(
        center: Offset(0.5 * width, 0.3 * height),
        width: 0.1 * width + 2 * margin,
        height: 0.1 * height + 2 * margin,
      ),
    ];
  }

  // Validar el dibujo
  void validateDrawing(Size canvasSize) {
    if (points.isEmpty) {
      setState(() {
        isValid = false;
        feedbackMessage = 'Dibuja la letra ${isUpperCase ? "I" : "i"}.';
      });
      return;
    }

    List<Rect> keyRegions =
        isUpperCase
            ? getKeyRegionsForUpperCaseI(canvasSize)
            : getKeyRegionsForLowerCaseI(canvasSize);
    List<int> pointsInRegion = List.filled(keyRegions.length, 0);

    for (var point in points) {
      if (point == null) continue;
      for (int i = 0; i < keyRegions.length; i++) {
        if (keyRegions[i].contains(point)) {
          pointsInRegion[i]++;
        }
      }
    }

    // Requerir menos puntos para las barras horizontales (índices 1 y 2) de la I mayúscula
    bool allRegionsCovered = true;
    for (int i = 0; i < pointsInRegion.length; i++) {
      int minPoints =
          isUpperCase && i > 0 ? 5 : 15; // 5 para barras, 15 para vertical
      if (pointsInRegion[i] < minPoints) {
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
            '¡Letra ${isUpperCase ? "I" : "i"} dibujada correctamente!';
      } else {
        feedbackMessage =
            'Dibuja la letra ${isUpperCase ? "I" : "i"} como en la imagen.';
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
                      // Navegar a la pantalla de videovocalI.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const VocalIPage(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: _playAudio, // Reproduce el audio al presionar
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Escribe la letra ${isUpperCase ? "I" : "i"}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      maxLines: 2, // Permite hasta 2 líneas
                      overflow:
                          TextOverflow.ellipsis, // Maneja el desbordamiento
                    ),
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
                  isUpperCase ? 'assets/letraI.jpg' : 'assets/letraI.jpg',
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

            // Botón para alternar entre I y i
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
                        feedbackMessage = 'Dibuja la letra I.';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isUpperCase ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('I mayúscula'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isUpperCase = false;
                        points.clear();
                        currentPencilPos = null;
                        isValid = false;
                        feedbackMessage = 'Dibuja la letra i.';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isUpperCase ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('i minúscula'),
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
                            'Dibuja la letra ${isUpperCase ? "I" : "i"}.';
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
                        // Navegar a la pantalla de pintai.dart (ColorPuzzleScreen)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorPuzzleScreen(),
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
