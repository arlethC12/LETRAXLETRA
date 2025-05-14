import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Importa el paquete audioplayers
import 'package:letra_x_letra/vocalI/llenacasita.dart'; // Importa llenacasita.dart
import 'package:letra_x_letra/vocalI/Iescribe.dart'; // Importa Iescribe.dart

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: ColorPuzzleScreen()),
  );
}

class ColorPuzzleScreen extends StatefulWidget {
  @override
  _ColorPuzzleScreenState createState() => _ColorPuzzleScreenState();
}

class _ColorPuzzleScreenState extends State<ColorPuzzleScreen>
    with SingleTickerProviderStateMixin {
  Map<int, bool> painted = {};
  bool showNextButton = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Instancia de AudioPlayer

  // Ahora toda la estructura está bien: "I" en el centro, "i" en los costados
  final List<String> letters = [
    'i',
    'i',
    'i',
    'i',
    'i',
    'i',
    'I',
    'I',
    'I',
    'i',
    'i',
    'i',
    'I',
    'i',
    'i',
    'i',
    'I',
    'I',
    'I',
    'i',
    'i',
    'i',
    'i',
    'i',
    'i',
  ];

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera los recursos del reproductor
    super.dispose();
  }

  // Función para reproducir el audio
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalI/Colorea la letra I m (1).m4a'),
      );
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  void paintLetter(int index) {
    setState(() {
      painted[index] = true;

      if (painted.length == letters.length) {
        showNextButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: const Color.fromARGB(255, 5, 3, 1),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Regresa a Iescribe.dart
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[300],
                          color: Colors.orange,
                          value: painted.length / letters.length,
                          minHeight: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Texto de instrucciones con ícono de bocina
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: _playAudio, // Reproduce el audio al presionar
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Colorea la letra I mayúscula y la letra i minúscula según corresponda su color",
                      style: TextStyle(
                        fontSize: 14, // Reducido para mejor ajuste
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2, // Permite hasta 2 líneas
                      overflow:
                          TextOverflow.ellipsis, // Maneja el desbordamiento
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            // Colores de referencia
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'i',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Rompecabezas
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: letters.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      String letter = letters[index];
                      bool isPainted = painted[index] ?? false;

                      Color color;
                      if (!isPainted) {
                        color = Colors.white;
                      } else {
                        color = letter == 'I' ? Colors.green : Colors.orange;
                      }

                      return GestureDetector(
                        onTap: () => paintLetter(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: color,
                          ),
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Botón flecha derecha
            if (showNextButton)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    // Navegar a la pantalla de llenacasita.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LlenaCasitaScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
