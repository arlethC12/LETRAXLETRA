import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Importar audioplayers
import 'package:letra_x_letra/vocalU/Uescribe.dart';
import 'package:letra_x_letra/vocalU/unepalabra.dart';

void main() {
  runApp(imagsel());
}

class imagsel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final List<String> emojis = [
    '🧸',
    '😊',
    '👸',
    '🦄',
    '🍇',
    '✨',
    '1️⃣',
    '🙃',
    '💅',
  ];

  List<bool> selected = List.filled(9, false);
  final int totalSelectable = 4;
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Instancia del reproductor de audio

  bool isSelectable(String emoji) {
    return emoji == '🦄' || emoji == '🍇' || emoji == '1️⃣' || emoji == '💅';
  }

  int getSelectedCount() {
    return selected.where((s) => s).length;
  }

  bool allSelected() {
    return getSelectedCount() == totalSelectable;
  }

  // Función para reproducir el audio
  Future<void> playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalU/SELECCIONA LAS IMAGE.m4a'),
      );
    } catch (e) {
      print("Error al reproducir el audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Liberar recursos del reproductor
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar con X y progreso
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UescribePage()),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: getSelectedCount() / totalSelectable,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Título con ícono de bocina y audio
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: playAudio,
                    child: Icon(
                      Icons.volume_up,
                      size: 30,
                      color: const Color.fromARGB(255, 17, 17, 16),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Selecciona las imágenes que empiecen con la letra U',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Letra U grande
            Text(
              'U',
              style: TextStyle(
                fontSize: 100,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Grid de emojis
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (isSelectable(emojis[index])) {
                        setState(() {
                          selected[index] = !selected[index];
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            selected[index]
                                ? Colors.green.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelectable(emojis[index])
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emojis[index],
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Botón de flecha derecha cuando se seleccionan todos
            if (allSelected())
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => unepla()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
