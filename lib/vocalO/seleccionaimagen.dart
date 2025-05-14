import 'package:flutter/material.dart';
import 'caminooveja.dart';
import 'Oescribe.dart';
import 'package:audioplayers/audioplayers.dart'; // Importar audioplayers

void main() {
  runApp(selectimagenO());
}

class selectimagenO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Lista de emojis y su estado (seleccionado o no)
  List<Map<String, dynamic>> emojis = [
    {'emoji': '🐻', 'startsWithO': true, 'selected': false}, // Oso
    {'emoji': '✏️', 'startsWithO': false, 'selected': false},
    {'emoji': '💻', 'startsWithO': false, 'selected': false},
    {'emoji': '🐑', 'startsWithO': true, 'selected': false}, // Oveja
    {'emoji': '🦧', 'startsWithO': true, 'selected': false}, // Orangután
    {'emoji': '🐴', 'startsWithO': false, 'selected': false},
    {'emoji': '🦦', 'startsWithO': false, 'selected': false}, // Nutria
    {'emoji': '👁️', 'startsWithO': true, 'selected': false}, // Ojo
  ];

  bool showNextButton = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Instancia de AudioPlayer

  @override
  void dispose() {
    _audioPlayer.dispose(); // Liberar recursos del audio
    super.dispose();
  }

  // Función para reproducir el audio
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalO/rodea con un circulo.m4a'),
      );
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OescribePage()),
                      );
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Texto de instrucción con ícono de bocina
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.black, size: 24),
                    onPressed: _playAudio, // Reproducir audio al presionar
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Rodea con un círculo las figuras que empiecen con la letra O',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CaminoOveja()),
                    );
                  },
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                  backgroundColor: Colors.orange,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
