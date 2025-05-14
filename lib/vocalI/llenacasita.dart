import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalI/pintai.dart'; // Importa pintai.dart
import 'package:letra_x_letra/vocalI/rompecabesa.dart'; // Importa rompecabesa.dart
import 'package:audioplayers/audioplayers.dart'; // Importa audioplayers

void main() {
  runApp(LlenaCasitaScreen());
}

class LlenaCasitaScreen extends StatelessWidget {
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
  List<String?> windows = List.filled(
    2,
    null,
  ); // 2 ventanas, inicialmente vacías
  int filledWindows = 0; // Contador de ventanas llenas
  double progress = 0.0; // Progreso de la barra (0 a 1)
  late AudioPlayer _audioPlayer; // Reproductor de audio

  // Lista de emojis que comienzan con "I"
  List<String> validEmojis = ['💉', '🧲', '⛪']; // Inyección, Imán, Iglesia

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Inicializa el reproductor de audio
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera recursos del reproductor
    super.dispose();
  }

  // Función para reproducir el audio
  Future<void> _playAudio() async {
    await _audioPlayer.play(
      AssetSource('audios/VocalI/Selecciona la imagen.m4a'),
    );
  }

  // Función para manejar cuando se selecciona un emoji
  void selectEmoji(String emoji) {
    if (!validEmojis.contains(emoji))
      return; // Solo emojis que comienzan con "I"

    setState(() {
      for (int i = 0; i < windows.length; i++) {
        if (windows[i] == null) {
          windows[i] = emoji;
          filledWindows++;
          progress = filledWindows / windows.length; // Actualizar progreso
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Barra de progreso y "X"
                Container(
                  padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ColorPuzzleScreen(),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              color: Colors.orange,
                              minHeight: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Ícono de bocina y texto de instrucción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up, color: Colors.black),
                        onPressed:
                            _playAudio, // Reproduce el audio al presionar
                      ),
                      Expanded(
                        child: Text(
                          'Toca imágenes con la letra I y colócalas en la casa',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 45),
                // Casa con ventanas
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -8,
                      child: CustomPaint(
                        size: Size(209, 50),
                        painter: RoofPainter(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 38),
                      width: 200,
                      height: 200,
                      color: Colors.purple[200],
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 10,
                            left: 80,
                            child: Container(
                              width: 40,
                              height: 60,
                              color: Colors.green,
                              child: Center(
                                child: Text(
                                  '💖',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: WindowPane(
                              emoji: windows[0],
                              isFilled: windows[0] != null,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: WindowPane(
                              emoji: windows[1],
                              isFilled: windows[1] != null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Emojis seleccionables
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    EmojiButton(emoji: '🦎', onTap: selectEmoji), // Camaleón
                    EmojiButton(emoji: '🪰', onTap: selectEmoji), // Mosca
                    EmojiButton(emoji: '⛪', onTap: selectEmoji), // Iglesia
                    EmojiButton(emoji: '🚗', onTap: selectEmoji), // Carro
                    EmojiButton(emoji: '🌸', onTap: selectEmoji), // Flor
                    EmojiButton(emoji: '💉', onTap: selectEmoji), // Inyección
                    EmojiButton(emoji: '🦄', onTap: selectEmoji), // Unicornio
                    EmojiButton(emoji: '🧲', onTap: selectEmoji), // Imán
                  ],
                ),
              ],
            ),
          ),
          // Botón naranja con flecha blanca
          if (filledWindows == windows.length)
            Positioned(
              bottom: 20.0,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RompecabesaScreen(),
                    ),
                  );
                },
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              ),
            ),
        ],
      ),
    );
  }
}

// Widget para los botones de emojis
class EmojiButton extends StatelessWidget {
  final String emoji;
  final Function(String) onTap;

  EmojiButton({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(emoji),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(emoji, style: TextStyle(fontSize: 30))),
      ),
    );
  }
}

// Widget para ventanas cuadradas
class WindowPane extends StatelessWidget {
  final String? emoji;
  final bool isFilled;

  WindowPane({this.emoji, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isFilled ? Colors.grey[200] : Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Center(child: Text(emoji ?? '', style: TextStyle(fontSize: 30))),
    );
  }
}

// Pintor para el tejado de la casa
class RoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color.fromARGB(255, 145, 70, 1) // Color marrón
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height); // Esquina inferior izquierda
    path.lineTo(size.width / 2, 0); // Pico central arriba
    path.lineTo(size.width, size.height); // Esquina inferior derecha
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
