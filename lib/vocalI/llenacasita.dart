import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalI/pintai.dart'; // Importa pintai.dart (contiene ColorPuzzleScreen)
import 'package:letra_x_letra/vocalI/rompecabesa.dart'; // Importa rompecabesa.dart

void main() {
  runApp(LlenaCasitaScreen());
}

class LlenaCasitaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove DEBUG label
      home: GameScreen(),
    );
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

  // Lista de emojis que comienzan con "I"
  List<String> validEmojis = ['💉', '🧲', '⛪']; // Inyección, Imán y Iglesia

  // Función para manejar cuando se selecciona un emoji
  void selectEmoji(String emoji) {
    if (!validEmojis.contains(emoji))
      return; // Solo emojis que comienzan con "I"

    setState(() {
      // Buscar la primera ventana vacía
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
          // Fondo de la pantalla
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
                        icon: Icon(
                          Icons.close,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        onPressed: () {
                          // Navegar a la pantalla de pintai.dart
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
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // Bordes circulares
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              color: Colors.orange, // Color naranja
                              minHeight: 10, // Altura de la barra
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40), // Más espacio para bajar la casa
                // Texto de instrucción
                Text(
                  'Selecciona la imagen que empiece con la letra I y ponla en la casa',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 45), // Más espacio para bajar la casa
                // Casa con ventanas
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Techo de la casa
                    Positioned(
                      top: -8,
                      child: CustomPaint(
                        size: Size(209, 50),
                        painter: RoofPainter(),
                      ),
                    ),
                    // Cuerpo de la casa
                    Container(
                      margin: EdgeInsets.only(top: 38),
                      width: 200,
                      height: 200,
                      color: Colors.purple[200],
                      child: Stack(
                        children: [
                          // Puerta con corazón
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
                          // Ventanas cuadradas
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
          // Botón naranja con flecha blanca (aparece al llenar todas las ventanas)
          if (filledWindows == windows.length)
            Positioned(
              bottom: 20.0, // Valor corregido
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () {
                  // Navegar a la pantalla de rompecabesa.dart
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
      child: Center(
        child: Text(
          emoji ?? '',
          style: TextStyle(fontSize: 30), // Tamaño más grande para emojis
        ),
      ),
    );
  }
}

// Pintor para el tejado de la casa (Techo triangular)
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
