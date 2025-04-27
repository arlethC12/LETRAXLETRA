import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LetterColoringScreen(),
    );
  }
}

class LetterColoringScreen extends StatefulWidget {
  const LetterColoringScreen({super.key});

  @override
  _LetterColoringScreenState createState() => _LetterColoringScreenState();
}

class _LetterColoringScreenState extends State<LetterColoringScreen> {
  final List<List<String>> letters = [
    ['E', 'e', 'E', 'e'],
    ['e', 'E', 'e', 'E'],
    ['E', 'e', 'E', 'e'],
    ['e', 'E', 'e', 'E'],
  ];

  late List<List<bool>> isColored;
  late List<List<double>> coloringProgress; // Progreso de coloreado
  bool allColored = false;

  @override
  void initState() {
    super.initState();
    isColored = List.generate(
      letters.length,
      (i) => List.generate(letters[i].length, (j) => false),
    );
    coloringProgress = List.generate(
      letters.length,
      (i) => List.generate(letters[i].length, (j) => 0.0),
    );
  }

  void checkAllColored() {
    setState(() {
      allColored = coloringProgress.every(
        (row) => row.every((progress) => progress >= 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with X and progress bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.orange),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.5,
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
            // Instruction text
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Selecciona la letra mayúscula y minúscula\npintando el color que corresponde',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Image at the top
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.asset(
                'assets/crayonE.jpg', // Imagen de crayón
                height: 100,
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
            // Grid of letters with painting effect
            Expanded(
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: letters.length * letters[0].length,
                  itemBuilder: (context, index) {
                    int row = index ~/ letters[0].length;
                    int col = index % letters[0].length;
                    String letter = letters[row][col];
                    double progress = coloringProgress[row][col];

                    return GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          if (progress < 1.0) {
                            coloringProgress[row][col] += 0.05;
                            if (coloringProgress[row][col] > 1.0) {
                              coloringProgress[row][col] = 1.0;
                            }
                          }
                          checkAllColored();
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            painter: CirclePainter(
                              progress: progress,
                              letter: letter,
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        progress >= 1.0
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (progress >= 1.0)
                            Positioned(
                              right: -5,
                              top: -5,
                              child: Transform.rotate(
                                angle: -0.8,
                                child: Icon(
                                  Icons.edit,
                                  color:
                                      letter == 'E'
                                          ? Colors.blue
                                          : Colors.purple,
                                  size: 30,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom button
            if (allColored)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {},
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

class CirclePainter extends CustomPainter {
  final double progress;
  final String letter;

  CirclePainter({required this.progress, required this.letter});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = letter == 'E' ? Colors.blue : Colors.purple
          ..style = PaintingStyle.fill;

    if (progress > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
        -90 * 3.1415927 / 180, // Inicia en la parte superior
        2 * 3.1415927 * progress, // Avanza según el progreso
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
