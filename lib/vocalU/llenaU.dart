import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalU/unepalabra.dart';
import 'package:letra_x_letra/vocalU/BurbujaU.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const llenaU());
}

class llenaU extends StatelessWidget {
  const llenaU({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UvasScreen(),
    );
  }
}

class UvasScreen extends StatefulWidget {
  const UvasScreen({super.key});

  @override
  State<UvasScreen> createState() => _UvasScreenState();
}

class _UvasScreenState extends State<UvasScreen> {
  int filledCircles = 0;
  final int totalCircles = 10;
  List<bool> buttonVisibility = List.generate(10, (_) => true);
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.setSource(
      AssetSource('audios/VocalU/SELECCIONA LAS LETRA.m4a'),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _fillNextCircle(int index) {
    if (filledCircles < totalCircles && buttonVisibility[index]) {
      setState(() {
        filledCircles++;
        buttonVisibility[index] = false;
      });
    }
  }

  void _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalU/SELECCIONA LAS LETRA.m4a'),
      );
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar with X button on the left
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => unepla()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: filledCircles / totalCircles,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orange,
                        minHeight: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Speaker icon and instruction text
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: _playAudio,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Coloca las letras que contengan la 'U'",
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
            // U shape and grapes emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(150, 200),
                  painter: UShapePainter(filledCircles: filledCircles),
                ),
                const SizedBox(width: 20),
                const Text("🍇 UVAS", style: TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 20),
            // Grid of buttons with only "U"
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(totalCircles, (index) {
                  return buttonVisibility[index]
                      ? ElevatedButton(
                        onPressed: () => _fillNextCircle(index),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.pink[100],
                        ),
                        child: const Text("U", style: TextStyle(fontSize: 18)),
                      )
                      : const SizedBox.shrink();
                }),
              ),
            ),
            // Arrow button (appears when all circles are filled)
            if (filledCircles == totalCircles)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BurbujaUScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UShapePainter extends CustomPainter {
  final int filledCircles;

  UShapePainter({required this.filledCircles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.pink[100]!
          ..style = PaintingStyle.fill;

    const circleRadius = 15.0;
    final positions = [
      Offset(size.width * 0.2, size.height * 0.1),
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.9),
      Offset(size.width * 0.6, size.height * 0.9),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.1),
    ];

    for (int i = 0; i < positions.length; i++) {
      canvas.drawCircle(positions[i], circleRadius, paint);
      if (i < filledCircles) {
        final textPainter = TextPainter(
          text: const TextSpan(
            text: "u",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            positions[i].dx - textPainter.width / 2,
            positions[i].dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
