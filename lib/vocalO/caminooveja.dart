import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalO/seleccionaimagen.dart';
import 'package:letra_x_letra/vocalO/unirpieza.dart';
import 'package:audioplayers/audioplayers.dart';

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
  List<Offset> points = [];
  bool isDrawing = false;
  bool showSheepAtGrass = false;
  bool showSmallSheep = true;
  bool showNextButton = false;
  bool isGameCompleted = false;
  Offset sheepPosition = Offset.zero;
  AnimationController? _controller;
  Animation<double>? _animation;
  int currentPointIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

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
                isGameCompleted = true;
              });
            }
          });
    // Play audio on init
    _playAudio();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _audioPlayer.dispose(); // Dispose audio player
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

  // Function to play audio
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalO/Traza la línea para .m4a'),
      );
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Barra de progreso y "X" (adjusted top position)
            Positioned(
              top: 20, // Increased from 10 to 20
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
                        size: 30,
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
                        minHeight: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Texto de instrucción con ícono de audio (adjusted top position)
            Positioned(
              top: 80, // Increased from 60 to 80
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up, size: 24),
                    onPressed: _playAudio, // Replay audio on tap
                  ),
                  const Flexible(
                    child: Text(
                      'Traza la línea para que la ovejita pueda comer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Elementos de la pantalla
            const Positioned(
              top: 120,
              left: 50,
              child: Text(
                'O',
                style: TextStyle(fontSize: 80, color: Colors.orange),
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
                style: TextStyle(fontSize: 80, color: Colors.orange),
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
            // Área para dibujar la línea
            Positioned(
              top: 100,
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
