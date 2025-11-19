import 'package:flutter/material.dart';
import 'package:letra_x_letra/modulo1exam/leccion1.dart';
import 'package:letra_x_letra/modulo1exam/leccion3.dart'; // ← Importamos Lección 3

void main() => runApp(const Leccion2());

class Leccion2 extends StatelessWidget {
  const Leccion2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WordGameScreen(),
    );
  }
}

class WordGameScreen extends StatefulWidget {
  const WordGameScreen({super.key});

  @override
  State<WordGameScreen> createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> {
  final String correctWord = "PÁJARO";
  List<String?> userAnswer = List.filled(6, null);
  List<String> availableLetters = ['P', 'Á', 'J', 'R', 'O', 'A', 'E', 'L', 'I'];
  List<bool> usedLetters = List.filled(9, false);

  @override
  void initState() {
    super.initState();
    _shuffleLetters();
  }

  void _shuffleLetters() {
    setState(() {
      availableLetters.shuffle();
    });
  }

  void _onLetterTap(int index) {
    if (usedLetters[index]) return;

    int emptyIndex = userAnswer.indexOf(null);
    if (emptyIndex != -1) {
      setState(() {
        userAnswer[emptyIndex] = availableLetters[index];
        usedLetters[index] = true;
      });
      _checkIfComplete();
    }
  }

  void _onAnswerTap(int index) {
    if (userAnswer[index] == null) return;

    String letter = userAnswer[index]!;
    int availableIndex = availableLetters.indexOf(letter);
    if (availableIndex != -1) {
      setState(() {
        userAnswer[index] = null;
        usedLetters[availableIndex] = false;
      });
    }
  }

  void _checkIfComplete() {
    if (!userAnswer.contains(null)) {
      String guess = userAnswer.join();
      if (guess == correctWord) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Correcto!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // ← NUEVA FUNCIÓN: Verifica si está completo y correcto
  bool _isComplete() {
    return userAnswer.join() == correctWord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === Barra superior: X, Progreso ===
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  // Botón X → Ir a Lección 1
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const Leccion1(
                                characterImagePath: '',
                                username: '',
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Barra de progreso
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.4,
                        backgroundColor: Color.fromARGB(255, 224, 224, 224),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // === Imagen del pájaro ===
            Expanded(
              flex: 3,
              child: Center(
                child: Image.asset(
                  'assets/bird.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === Casillas para la palabra ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double boxSize = (constraints.maxWidth - 40) / 6;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return GestureDetector(
                        onTap: () => _onAnswerTap(index),
                        child: Container(
                          width: boxSize - 8,
                          height: boxSize - 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _getBoxColor(index),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            userAnswer[index] ?? '',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // === Instrucciones ===
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "ESCRIBE Y COMPLETA LA PALABRA CON LA VOCAL QUE CORRESPONDA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // === Letras disponibles (9 letras) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double itemWidth = (constraints.maxWidth - 40) / 3;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: List.generate(9, (index) {
                      bool isUsed = usedLetters[index];
                      return GestureDetector(
                        onTap: () => _onLetterTap(index),
                        child: Container(
                          width: itemWidth - 12,
                          height: itemWidth - 12,
                          decoration: BoxDecoration(
                            color:
                                isUsed
                                    ? Colors.grey.shade300
                                    : _getLetterColor(index % 6),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            availableLetters[index],
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color:
                                  isUsed ? Colors.grey.shade600 : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // === Botón siguiente → Solo si está correcto ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      _isComplete()
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Leccion3(),
                              ),
                            );
                          }
                          : null, // Deshabilitado si no está correcto
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _getBoxColor(int index) {
    String? letter = userAnswer[index];
    if (letter == null) return Colors.white;
    int correctIndex = correctWord.indexOf(letter);
    if (correctIndex == index) {
      return Colors.green;
    } else if (correctWord.contains(letter)) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getLetterColor(int index) {
    const colors = [
      Color(0xFF6C63FF), // P
      Color(0xFFFF6B6B), // Á
      Color(0xFF4ECDC4), // J
      Color(0xFFFFD93D), // R
      Color(0xFF95E1D3), // O
      Color(0xFFF38181), // A
    ];
    return colors[index % colors.length];
  }
}
