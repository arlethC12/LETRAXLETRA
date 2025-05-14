import 'package:flutter/material.dart';
import 'dart:math';
import 'package:letra_x_letra/vocalO/unirpieza.dart';
import 'package:letra_x_letra/vocalO/BurbujaO.dart';
import 'package:audioplayers/audioplayers.dart'; // Importar audioplayers

void main() {
  runApp(Oso());
}

class Oso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemoramaScreen(),
    );
  }
}

class MemoramaScreen extends StatefulWidget {
  @override
  _MemoramaScreenState createState() => _MemoramaScreenState();
}

class _MemoramaScreenState extends State<MemoramaScreen> {
  List<CardItem> cards = [];
  List<bool> isFlipped = [];
  List<bool> isMatched = [];
  int firstCardIndex = -1;
  int secondCardIndex = -1;
  bool isProcessing = false;

  // Agregar controlador de audio
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initializeCards();
  }

  // Función para reproducir el audio
  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalO/completa el siguient.m4a'),
      ); // Ruta del archivo de audio
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  void initializeCards() {
    final items = [
      {'text': 'O', 'emoji': 'O'},
      {'text': 'Oso', 'emoji': '🐻'},
      {'text': 'Oruga', 'emoji': '🐛'},
      {'text': 'Oreja', 'emoji': '👂'},
      {'text': 'Oveja', 'emoji': '🐑'},
    ];

    cards =
        List<CardItem>.from(
            items.map(
              (item) => CardItem(
                text: item['text']!,
                emoji: item['emoji']!,
                isImage: item['text'] != 'O',
              ),
            ),
          )
          ..addAll(
            List<CardItem>.from(
              items.map(
                (item) => CardItem(
                  text: item['text']!,
                  emoji: item['emoji']!,
                  isImage: item['text'] != 'O',
                ),
              ),
            ),
          )
          ..shuffle();

    isFlipped = List<bool>.filled(cards.length, false);
    isMatched = List<bool>.filled(cards.length, false);
  }

  void flipCard(int index) {
    if (isMatched[index] || isFlipped[index] || isProcessing) return;

    setState(() {
      isFlipped[index] = true;
    });

    if (firstCardIndex == -1) {
      firstCardIndex = index;
    } else if (secondCardIndex == -1 && firstCardIndex != index) {
      secondCardIndex = index;
      setState(() {
        isProcessing = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        bool isMatch =
            cards[firstCardIndex].emoji == cards[secondCardIndex].emoji;

        setState(() {
          if (isMatch) {
            isMatched[firstCardIndex] = true;
            isMatched[secondCardIndex] = true;
          } else {
            isFlipped[firstCardIndex] = false;
            isFlipped[secondCardIndex] = false;
          }
          firstCardIndex = -1;
          secondCardIndex = -1;
          isProcessing = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Liberar recursos del reproductor de audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnirpiezaO()),
                  );
                },
              ),
            ),
            Positioned(
              top: 25,
              left: 70,
              width: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: isMatched.where((m) => m).length / cards.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  minHeight: 10,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.volume_up,
                            color: const Color.fromARGB(255, 10, 10, 9),
                            size: 30,
                          ),
                          onPressed:
                              _playSound, // Llamar a la función para reproducir el audio
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Completa el siguiente memorama',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => flipCard(index),
                          child: Card(
                            color:
                                isMatched[index]
                                    ? const Color.fromARGB(255, 213, 235, 209)
                                    : (isFlipped[index]
                                        ? Colors.white
                                        : Colors.grey),
                            child: Center(
                              child:
                                  isFlipped[index] || isMatched[index]
                                      ? Text(
                                        cards[index].emoji,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                        ),
                                      )
                                      : Icon(Icons.question_mark, size: 40),
                            ),
                          ),
                        );
                      },
                    ),
                    if (isMatched.every((matched) => matched))
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Completado',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BurbujaOScreen(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardItem {
  final String text;
  final String emoji;
  final bool isImage;

  CardItem({required this.text, required this.emoji, required this.isImage});
}
