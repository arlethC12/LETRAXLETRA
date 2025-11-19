import 'package:flutter/material.dart';
import 'package:letra_x_letra/modulo1exam/leccion5.dart'; // ← Lección 5
import 'package:letra_x_letra/modulo1exam/leccion7.dart'; // ← Lección 7

void main() => runApp(const Leccion6());

class Leccion6 extends StatelessWidget {
  const Leccion6({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const VocalMatchingScreen(),
    );
  }
}

class VocalMatchingScreen extends StatefulWidget {
  const VocalMatchingScreen({super.key});

  @override
  State<VocalMatchingScreen> createState() => _VocalMatchingScreenState();
}

class _VocalMatchingScreenState extends State<VocalMatchingScreen> {
  String? selectedUpper;
  final Map<String, String> correctPairs = {
    'U': 'u',
    'O': 'o',
    'E': 'e',
    'A': 'a',
    'I': 'i',
  };
  final Map<String, Color> matchedColors = {};

  // ← Verifica si todas están completas
  bool get _isComplete => matchedColors.length == 5;

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
                  // X → Ir a Lección 5
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Leccion5(),
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
                        value: 0.3,
                        backgroundColor: Color.fromARGB(255, 226, 226, 226),
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

            const SizedBox(height: 20),

            // === Instrucción ===
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "TOCA LA VOCAL MAYÚSCULA Y LUEGO HAZLA COINCIDIR CON LA MINÚSCULA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 42),

            // === Vocales de arriba (sin overflow) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUpperCircle('U'),
                  _buildUpperCircle('O'),
                  _buildUpperCircle('E'),
                  _buildUpperCircle('A'),
                  _buildUpperCircle('I'),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // === Vocales de abajo (orden aleatorio) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLowerCircle('o'),
                  _buildLowerCircle('i'),
                  _buildLowerCircle('a'),
                  _buildLowerCircle('u'),
                  _buildLowerCircle('e'),
                ],
              ),
            ),

            const Spacer(),

            // === Botón siguiente → Solo si están todas emparejadas ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      _isComplete
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Leccion7(),
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
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // === Círculo mayúscula ===
  Widget _buildUpperCircle(String v) {
    bool isMatched = matchedColors.containsKey(v.toLowerCase());
    return GestureDetector(
      onTap:
          isMatched
              ? null
              : () {
                setState(() {
                  selectedUpper = selectedUpper == v ? null : v;
                });
              },
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getUpperColor(v),
          border: Border.all(
            color: selectedUpper == v ? Colors.black : Colors.transparent,
            width: 3,
          ),
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
          v,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // === Círculo minúscula ===
  Widget _buildLowerCircle(String v) {
    String upper = v.toUpperCase();
    bool isMatched = matchedColors.containsKey(v);
    Color circleColor = isMatched ? matchedColors[v]! : Colors.grey.shade300;
    Color textColor = isMatched ? Colors.white : Colors.black54;

    return GestureDetector(
      onTap:
          isMatched
              ? null
              : () {
                if (selectedUpper != null && correctPairs[selectedUpper] == v) {
                  setState(() {
                    matchedColors[v] = _getUpperColor(selectedUpper!);
                    selectedUpper = null;
                  });
                  if (_isComplete) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("¡Perfecto! ¡Todas unidas!"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  }
                } else if (selectedUpper != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("¡Incorrecto! Intenta otra vez"),
                      backgroundColor: Colors.red,
                      duration: Duration(milliseconds: 800),
                    ),
                  );
                  setState(() => selectedUpper = null);
                }
              },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          v,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // === Colores por vocal mayúscula ===
  Color _getUpperColor(String v) {
    return {
      'U': const Color(0xFF2196F3), // Azul
      'O': const Color(0xFFFF5722), // Naranja
      'E': const Color(0xFF4CAF50), // Verde
      'A': const Color(0xFFE91E63), // Rosa
      'I': const Color(0xFF9C27B0), // Púrpura
    }[v]!;
  }
}
