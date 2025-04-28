import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta de debug
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Lista de emojis y su estado (seleccionado o no)
  List<Map<String, dynamic>> emojis = [
    {'emoji': '🐻', 'startsWithO': false, 'selected': false},
    {'emoji': '✏️', 'startsWithO': false, 'selected': false},
    {'emoji': '💻', 'startsWithO': false, 'selected': false},
    {'emoji': '🐑', 'startsWithO': true, 'selected': false}, // Oveja
    {'emoji': '🦧', 'startsWithO': true, 'selected': false}, // Orangután
    {'emoji': '🐴', 'startsWithO': false, 'selected': false},
    {'emoji': '🦦', 'startsWithO': true, 'selected': false}, // Nutria
    {'emoji': '👁️', 'startsWithO': true, 'selected': false}, // Ojo
  ];

  bool showNextButton = false;

  // Verifica si todos los emojis que empiezan con "O" están seleccionados
  void checkCompletion() {
    bool allSelected = true;
    for (var emoji in emojis) {
      if (emoji['startsWithO'] && !emoji['selected']) {
        allSelected = false;
        break;
      }
    }
    setState(() {
      showNextButton = allSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Barra de progreso y "X"
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      // Acción para cerrar
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Bordes redondeados
                      child: LinearProgressIndicator(
                        value: 0.3, // Valor fijo para la barra de progreso
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ), // Color naranja
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Texto de instrucción
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Text(
                'Rodea con un círculo las figuras que empiecen con la letra O',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Grid de emojis
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: emojis.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (emojis[index]['startsWithO']) {
                          setState(() {
                            emojis[index]['selected'] = true;
                          });
                          checkCompletion();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              emojis[index]['selected']
                                  ? Border.all(color: Colors.red, width: 3)
                                  : null,
                        ),
                        child: Center(
                          child: Text(
                            emojis[index]['emoji'],
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Botón de flecha (aparece al completar)
            if (showNextButton)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    // Acción para el botón de flecha
                  },
                  child: Icon(
                    Icons.arrow_forward, // Flecha hacia la derecha
                    color: Colors.white, // Flecha blanca
                  ),
                  backgroundColor: Colors.orange, // Botón naranja
                ),
              ),
          ],
        ),
      ),
    );
  }
}
