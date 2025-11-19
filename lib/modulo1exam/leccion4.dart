import 'package:flutter/material.dart';
import 'package:letra_x_letra/modulo1exam/leccion3.dart'; // ← Lección 3
import 'package:letra_x_letra/modulo1exam/leccion5.dart'; // ← Lección 5

void main() => runApp(const Leccion4());

class Leccion4 extends StatelessWidget {
  const Leccion4({super.key});

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
  final String correctWord = "IGUANA";
  List<String?> userAnswer = List.filled(6, null);
  List<String> availableLetters = ['I', 'G', 'U', 'A', 'N', 'A', 'L', 'O', 'E'];
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
            content: Text("¡Correcto! ¡Eres un genio!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // ← Verifica si está completa y correcta
  bool _isComplete() => userAnswer.join() == correctWord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === Barra superior: X + Progreso ===
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  // X → Ir a Lección 3
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Leccion3(),
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
                        color: Colors.black54,
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
                        value: 0.6,
                        backgroundColor: Color.fromARGB(255, 223, 222, 222),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // === Imagen de la iguana ===
            Expanded(
              flex: 3,
              child: Center(
                child: Image.asset(
                  'assets/iguana.jpg',
                  width: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === Cajas para la palabra ===
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
                              color: const Color.fromARGB(255, 245, 243, 243),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(
                                  255,
                                  97,
                                  167,
                                  51,
                                ).withOpacity(0.6),
                                offset: const Offset(2, 2),
                                blurRadius: 0,
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-2, -2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            userAnswer[index] ?? '',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
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
                  color: Color.fromARGB(255, 97, 97, 97),
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // === Letras disponibles (9) ===
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
                                    : _getLetterColor(index),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            availableLetters[index],
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color:
                                  isUsed ? Colors.grey.shade600 : Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
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
                                builder: (context) => const Leccion5(),
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                    shadowColor: Colors.orange.shade900,
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

  // === Color de caja: base, verde si correcto, naranja si está en palabra, rojo si no ===
  Color _getBoxColor(int index) {
    String? letter = userAnswer[index];
    if (letter == null) {
      return const Color.fromARGB(255, 214, 193, 193); // Rojo base
    }

    int correctIndex = correctWord.indexOf(letter);
    if (correctIndex == index) {
      return const Color(0xFF04DD4C); // Verde brillante (correcto)
    } else if (correctWord.contains(letter)) {
      return const Color(0xFFFF6B00); // Naranja (está, pero mal lugar)
    } else {
      return const Color(0xFFE53935); // Rojo (no está)
    }
  }

  // === Colores vibrantes para letras disponibles ===
  Color _getLetterColor(int index) {
    const colors = [
      Color(0xFF6C63FF), // Morado
      Color(0xFFFF6B6B), // Rosa
      Color(0xFF4ECDC4), // Turquesa
      Color(0xFFFFD93D), // Amarillo
      Color(0xFF95E1D3), // Verde agua
      Color(0xFFF38181), // Coral
      Color(0xFF42A5F5), // Azul
      Color(0xFFFF9800), // Naranja
      Color(0xFFAB47BC), // Púrpura
    ];
    return colors[index % colors.length];
  }
}
