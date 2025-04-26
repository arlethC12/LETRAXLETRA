import 'dart:ui';
import 'package:flutter/material.dart';
import 'burbujaA.dart'; // Importación del archivo burbujaA
import 'caritaselet.dart'; // Importación del archivo caritaselet

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

  Map<int, int> connections = {};
  int? selectedEmojiIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Selecciona un emoji y conéctalo con su palabra correspondiente',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: LinePainter(connections: connections),
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
                        children: List.generate(items.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedEmojiIndex != null &&
                                    items[selectedEmojiIndex!]['word'] ==
                                        items[index]['word']) {
                                  connections[selectedEmojiIndex!] = index;
                                  selectedEmojiIndex = null;
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                items[index]['word']!,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () {
                  // Navegación a la pantalla en burbujaA.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BurbujaAScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Map<int, int> connections;

  LinePainter({required this.connections});

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
      final wordOffset = Offset(
        size.width * 0.75, // Coordenadas aproximadas para palabras
        size.height * (0.15 + wordIndex * 0.18),
      );

      canvas.drawLine(emojiOffset, wordOffset, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
