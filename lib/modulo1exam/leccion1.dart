import 'package:flutter/material.dart';
import 'package:letra_x_letra/pvocales.dart';
import 'leccion2.dart';

void main() {
  runApp(const Leccion1(characterImagePath: '', username: ''));
}

class Leccion1 extends StatelessWidget {
  const Leccion1({
    super.key,
    required String characterImagePath,
    required String username,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.orange),
              onPressed: () {},
            ),
          ),
          title: const SizedBox.shrink(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  // Acción para cerrar
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const VowelsScreen(
                            characterImagePath: '',
                            username: '',
                            token: '',
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: const VocalMatchingScreen(),
      ),
    );
  }
}

class VocalMatchingScreen extends StatefulWidget {
  const VocalMatchingScreen({super.key});

  @override
  State<VocalMatchingScreen> createState() => _VocalMatchingScreenState();
}

class _VocalMatchingScreenState extends State<VocalMatchingScreen> {
  // Mapa: emoji -> vocal correcta
  final Map<String, String> _correctAnswers = {
    "🍇": "U",
    "🐘": "E",
    "🧸": "O",
    "🦎": "I",
    "🐝": "A",
  };

  // Estado actual de los círculos (qué letra tiene cada uno)
  final Map<String, String?> _currentAnswers = {
    "🍇": null,
    "🐘": null,
    "🧸": null,
    "🦎": null,
    "🐝": null,
  };

  // Letras disponibles para arrastrar
  Set<String> _availableLetters = {"A", "E", "I", "O", "U"};

  // Contador de aciertos
  int get _correctCount =>
      _currentAnswers.entries
          .where((e) => e.value != null && _correctAnswers[e.key] == e.value)
          .length;

  int get _totalImages => _correctAnswers.length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Barra de progreso
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _correctCount / _totalImages,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Instrucción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Text(
              "OBSERVA Y ARRASTRA LA VOCAL QUE CORRESPONDE EN EL CÍRCULO DE CADA IMAGEN.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDD6B20),
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Fila de imágenes con círculos debajo
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageWithCircle("🍇", "U"),
                  _buildImageWithCircle("🐘", "E"),
                  _buildImageWithCircle("🧸", "O"),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageWithCircle("🦎", "I"),
                  _buildImageWithCircle("🐝", "A"),
                  const SizedBox(width: 60),
                ],
              ),
            ],
          ),

          const SizedBox(height: 50),

          // Vocales arrastrables
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                _availableLetters
                    .map((letter) => _DraggableVowel(letter: letter))
                    .toList(),
          ),

          const Spacer(),

          // Botón de siguiente
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _correctCount == _totalImages
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Leccion2(),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildImageWithCircle(String emoji, String correctVowel) {
    final currentLetter = _currentAnswers[emoji];

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 50)),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  currentLetter != null
                      ? (currentLetter == correctVowel
                          ? Colors.green
                          : Colors.red)
                      : Colors.grey.shade400,
              width: 3,
            ),
          ),
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Center(
                child:
                    currentLetter != null
                        ? Text(
                          currentLetter,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                currentLetter == correctVowel
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        )
                        : (candidateData.isNotEmpty
                            ? Text(
                              candidateData[0]!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color:
                                    candidateData[0] == correctVowel
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            )
                            : const SizedBox()),
              );
            },
            onWillAccept: (data) {
              // Solo aceptar si es la vocal correcta
              return data == correctVowel;
            },
            onAccept: (data) {
              setState(() {
                // Buscar si esta letra ya está en otro círculo
                final previousKey =
                    _currentAnswers.entries
                        .firstWhere(
                          (e) => e.value == data,
                          orElse: () => const MapEntry("", null),
                        )
                        .key;

                // Liberar el círculo anterior si existe
                if (previousKey.isNotEmpty) {
                  _currentAnswers[previousKey] = null;
                  _availableLetters.add(data);
                }

                // Colocar en el nuevo círculo
                _currentAnswers[emoji] = data;
                _availableLetters.remove(data);
              });
            },
          ),
        ),
      ],
    );
  }
}

class _DraggableVowel extends StatelessWidget {
  final String letter;

  const _DraggableVowel({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: letter,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      feedback: Material(
        elevation: 6,
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange.shade200, width: 3),
        ),
      ),
    );
  }
}
