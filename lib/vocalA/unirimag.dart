import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for audio playback
import 'burbujaA.dart'; // Importación del archivo burbujaA
import 'caritaselet.dart'; // Importación del archivo caritaselet
import 'dart:math'; // Added for shuffling

void main() {
  runApp(UnirimagScreen());
}

class UnirimagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MatchingScreen(),
    );
  }
}

class MatchingScreen extends StatefulWidget {
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final List<Map<String, String>> items = [
    {'emoji': '🐝', 'word': 'abeja'},
    {'emoji': '🕷️', 'word': 'araña'},
    {'emoji': '🌈', 'word': 'arcoíris'},
    {'emoji': '💧', 'word': 'agua'},
    {'emoji': '🐿️', 'word': 'ardilla'},
  ];

  late List<Map<String, String>> shuffledWords; // List to hold shuffled words
  Map<int, int> connections = {};
  int? selectedEmojiIndex;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Added for audio playback

  @override
  void initState() {
    super.initState();
    // Shuffle the words list when the state is initialized
    shuffledWords = List.from(items)..shuffle(Random());
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose audio player
    super.dispose();
  }

  // Verificar si todas las uniones están completas
  bool get _isLessonComplete {
    return connections.length == items.length &&
        items.asMap().entries.every((entry) {
          int index = entry.key;
          String word = entry.value['word']!;
          return connections.containsKey(index) &&
              items[connections[index]!]['word'] == word;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso con "X", más ancha y con bordes circulares
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navegación a la pantalla caritaselet.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      height: 11, // Barra más ancha
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          7.5,
                        ), // Bordes circulares
                        child: LinearProgressIndicator(
                          value: 0.8,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Ícono de bocina y texto
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.black, size: 24),
                    onPressed: () async {
                      await _audioPlayer.play(
                        AssetSource('audios/VocalA/Une con una línea lo.m4a'),
                      ); // Play audio
                    },
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Selecciona un emoji y conéctalo con su palabra correspondiente',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: LinePainter(
                      connections: connections,
                      items: items,
                      shuffledWords: shuffledWords,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(items.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEmojiIndex = index;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                items[index]['emoji']!,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          );
                        }),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(shuffledWords.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedEmojiIndex != null) {
                                  // Find the index of the word in the original items list
                                  int wordIndex = items.indexWhere(
                                    (item) =>
                                        item['word'] ==
                                        shuffledWords[index]['word'],
                                  );
                                  if (items[selectedEmojiIndex!]['word'] ==
                                      shuffledWords[index]['word']) {
                                    connections[selectedEmojiIndex!] =
                                        wordIndex;
                                    selectedEmojiIndex = null;
                                  }
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                shuffledWords[index]['word']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón de flecha (solo aparece si la lección está completa)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  _isLessonComplete
                      ? IconButton(
                        onPressed: () {
                          // Navegación a la pantalla en burbujaA.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BurbujaAScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: const CircleBorder(),
                        ),
                      )
                      : SizedBox.shrink(), // No mostrar nada si la lección no está completa
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Map<int, int> connections;
  final List<Map<String, String>> items;
  final List<Map<String, String>> shuffledWords;

  LinePainter({
    required this.connections,
    required this.items,
    required this.shuffledWords,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    connections.forEach((emojiIndex, wordIndex) {
      final emojiOffset = Offset(
        size.width * 0.25, // Coordenadas aproximadas para emojis
        size.height * (0.15 + emojiIndex * 0.18),
      );
      // Find the index of the word in the shuffledWords list
      int shuffledWordIndex = shuffledWords.indexWhere(
        (item) => item['word'] == items[wordIndex]['word'],
      );
      final wordOffset = Offset(
        size.width * 0.75, // Coordenadas aproximadas para palabras
        size.height * (0.15 + shuffledWordIndex * 0.18),
      );

      canvas.drawLine(emojiOffset, wordOffset, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
