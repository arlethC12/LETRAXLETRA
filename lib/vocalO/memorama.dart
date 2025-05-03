// Importación de paquetes necesarios
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:letra_x_letra/vocalO/unirpieza.dart';
import 'package:letra_x_letra/vocalO/BurbujaO.dart';

// Función principal que ejecuta la app
void main() {
  runApp(Oso());
}

// Widget principal que lanza la pantalla del memorama
class Oso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug
      home: MemoramaScreen(), // Pantalla principal
    );
  }
}

// Widget con estado para controlar el juego
class MemoramaScreen extends StatefulWidget {
  @override
  _MemoramaScreenState createState() => _MemoramaScreenState();
}

class _MemoramaScreenState extends State<MemoramaScreen> {
  List<CardItem> cards = []; // Lista de cartas
  List<bool> isFlipped = []; // Estado de cada carta (volteada o no)
  List<bool> isMatched = []; // Estado de coincidencia de las cartas
  int firstCardIndex = -1; // Índice de la primera carta seleccionada
  int secondCardIndex = -1; // Índice de la segunda carta seleccionada
  bool isProcessing = false; // Controla si se está evaluando un par

  @override
  void initState() {
    super.initState();
    initializeCards(); // Inicializa las cartas al iniciar
  }

  // Inicializa y mezcla las cartas del memorama
  void initializeCards() {
    final items = [
      {'text': 'O', 'emoji': 'O'},
      {'text': 'Oso', 'emoji': '🐻'},
      {'text': 'Oruga', 'emoji': '🐛'},
      {'text': 'Oreja', 'emoji': '👂'},
      {'text': 'Oveja', 'emoji': '🐑'},
    ];

    // Se duplican las cartas para tener pares y luego se mezclan
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
          ..shuffle(); // Mezcla aleatoriamente

    // Inicializa listas de control
    isFlipped = List<bool>.filled(cards.length, false);
    isMatched = List<bool>.filled(cards.length, false);
  }

  // Función que se ejecuta al voltear una carta
  void flipCard(int index) {
    if (isMatched[index] || isFlipped[index] || isProcessing) return;

    setState(() {
      isFlipped[index] = true;
    });

    // Si es la primera carta seleccionada
    if (firstCardIndex == -1) {
      firstCardIndex = index;
    }
    // Si es la segunda carta seleccionada
    else if (secondCardIndex == -1 && firstCardIndex != index) {
      secondCardIndex = index;
      setState(() {
        isProcessing = true;
      });

      // Espera un segundo para mostrar las cartas volteadas
      Future.delayed(Duration(seconds: 1), () {
        bool isMatch =
            cards[firstCardIndex].emoji == cards[secondCardIndex].emoji;

        setState(() {
          // Si las cartas coinciden
          if (isMatch) {
            isMatched[firstCardIndex] = true;
            isMatched[secondCardIndex] = true;
          } else {
            // Si no coinciden, se voltean de nuevo
            isFlipped[firstCardIndex] = false;
            isFlipped[secondCardIndex] = false;
          }
          // Reinicia los índices
          firstCardIndex = -1;
          secondCardIndex = -1;
          isProcessing = false;
        });
      });
    }
  }

  // Construcción visual de la pantalla del memorama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Botón de cerrar y regresar a la pantalla anterior
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
            // Barra de progreso al lado del botón de cerrar
            Positioned(
              top: 25,
              left: 70,
              width: 250, // Ancho fijo para la barra de progreso
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
            // Contenido principal
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                ), // Ajuste para subir el contenido
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícono de bocina y texto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.volume_up,
                          color: const Color.fromARGB(255, 10, 10, 9),
                          size: 30,
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
                    // Rejilla de cartas
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 columnas
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
                    // Muestra mensaje de completado y botón para continuar
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

// Clase que representa cada carta del memorama
class CardItem {
  final String text; // Texto descriptivo
  final String emoji; // Emoji o símbolo que representa
  final bool isImage; // Indica si es imagen o letra

  CardItem({required this.text, required this.emoji, required this.isImage});
}
