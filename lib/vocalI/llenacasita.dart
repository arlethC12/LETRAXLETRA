import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String?> windows = List.filled(
    4,
    null,
  ); // 4 ventanas, inicialmente vacías
  int filledWindows = 0; // Contador de ventanas llenas
  double progress = 0.0; // Progreso de la barra (0 a 1)

  // Lista de emojis que comienzan con "I"
  List<String> validEmojis = ['💉', '🧲']; // Inyección y Imán

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
                        icon: Icon(Icons.close, color: Colors.yellow),
                        onPressed: () {
                          // Acción para cerrar
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Texto de instrucción
                Text(
                  'Selecciona la imagen que empiece con la letra I y ponla en la casa',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Casa con ventanas
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Techo de la casa
                    CustomPaint(size: Size(200, 100), painter: RoofPainter()),
                    // Cuerpo de la casa
                    Container(
                      margin: EdgeInsets.only(top: 50),
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
                          // Ventanas
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 60,
                              height: 60,
                              color:
                                  windows[0] == null
                                      ? Colors.white
                                      : Colors.grey[200],
                              child: Center(
                                child: Text(
                                  windows[0] ?? '',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              width: 60,
                              height: 60,
                              color:
                                  windows[1] == null
                                      ? Colors.white
                                      : Colors.grey[200],
                              child: Center(
                                child: Text(
                                  windows[1] ?? '',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            left: 20,
                            child: Container(
                              width: 60,
                              height: 60,
                              color:
                                  windows[2] == null
                                      ? Colors.white
                                      : Colors.grey[200],
                              child: Center(
                                child: Text(
                                  windows[2] ?? '',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            right: 20,
                            child: Container(
                              width: 60,
                              height: 60,
                              color:
                                  windows[3] == null
                                      ? Colors.white
                                      : Colors.grey[200],
                              child: Center(
                                child: Text(
                                  windows[3] ?? '',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
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
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () {
                  // Acción del botón
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

// Pintor para el tejado de la casa (Techo triangular)
class RoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color.fromARGB(255, 145, 70, 1)
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(5, size.height); // Punto inferior izquierdo
    path.lineTo(size.width / 5, 3); // Pico del triángulo (centro arriba)
    path.lineTo(size.width, size.height); // Punto inferior derecho
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
