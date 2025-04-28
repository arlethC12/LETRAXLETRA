import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina la etiqueta de debug
      home: WordCompletionGame(),
    );
  }
}

class WordCompletionGame extends StatefulWidget {
  @override
  _WordCompletionGameState createState() => _WordCompletionGameState();
}

class _WordCompletionGameState extends State<WordCompletionGame> {
  List<String?> slots = [null, null, null]; // Para los 3 huecos de las palabras
  List<String> draggableLetters = ['U', 'U', 'U']; // Letras arrastrables
  bool isCompleted = false;

  void checkCompletion() {
    if (slots.every((slot) => slot == 'U')) {
      setState(() {
        isCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close),
        title: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.5, // Ajusta según el progreso
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 8,
              ),
            ),
            SizedBox(height: 16), // Más espacio para bajar el texto
            Text(
              'Completa la palabra con la vocal',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fila 1: 🍇 _ va
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🍇', style: TextStyle(fontSize: 40)),
              SizedBox(width: 10),
              DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    slots[0] = data;
                  });
                  checkCompletion();
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 30,
                    height: 30,
                    color: slots[0] == null ? Colors.grey[300] : Colors.blue,
                    child: Center(
                      child: Text(
                        slots[0] ?? '',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              Text('va', style: TextStyle(fontSize: 40, color: Colors.pink)),
            ],
          ),
          SizedBox(height: 20),
          // Fila 2: 💅 _ ñas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('💅', style: TextStyle(fontSize: 40)),
              SizedBox(width: 10),
              DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    slots[1] = data;
                  });
                  checkCompletion();
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 30,
                    height: 30,
                    color: slots[1] == null ? Colors.grey[300] : Colors.blue,
                    child: Center(
                      child: Text(
                        slots[1] ?? '',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              Text('ñas', style: TextStyle(fontSize: 40, color: Colors.pink)),
            ],
          ),
          SizedBox(height: 20),
          // Fila 3: 1️⃣ _ no
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('1️⃣', style: TextStyle(fontSize: 40)),
              SizedBox(width: 10),
              DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    slots[2] = data;
                  });
                  checkCompletion();
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 30,
                    height: 30,
                    color: slots[2] == null ? Colors.grey[300] : Colors.blue,
                    child: Center(
                      child: Text(
                        slots[2] ?? '',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              Text('no', style: TextStyle(fontSize: 40, color: Colors.pink)),
            ],
          ),
          SizedBox(height: 40),
          // Letras arrastrables
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                draggableLetters.map((letter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Draggable<String>(
                      data: letter,
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.purple,
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      feedback: Container(
                        width: 40,
                        height: 40,
                        color: Colors.purple.withOpacity(0.5),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 40),
          // Botón de flecha (aparece al completar, naranja con flecha blanca)
          if (isCompleted)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Fondo naranja
                foregroundColor: Colors.white, // Icono blanco
              ),
              child: Icon(Icons.arrow_forward),
            ),
        ],
      ),
    );
  }
}
