import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for audio playback
import 'selectimagen.dart'; // Importa selectimagen.dart

class CompalabraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LessonScreen(); // Ya no usamos MaterialApp aquí
  }
}

class LessonScreen extends StatefulWidget {
  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  String? selectedLetter;
  bool isCorrect = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Added for audio playback

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose audio player
    super.dispose();
  }

  void checkAnswer(String letter) {
    setState(() {
      if (letter == 'a') {
        isCorrect = true;
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
                // Barra de progreso con bordes circulares y color naranja
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black, size: 30),
                        onPressed: () {
                          Navigator.pop(context); // Regresa a EscribaScreen
                        },
                      ),
                      Expanded(
                        child: Container(
                          height: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // Bordes circulares
                            child: LinearProgressIndicator(
                              value: 0.3,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange, // Color naranja
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Instrucción con la bocina
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up, size: 30),
                        onPressed: () async {
                          await _audioPlayer.play(
                            AssetSource(
                              'audios/VocalA/Arrastre la letra y .m4a',
                            ),
                          ); // Play audio
                        },
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Arrastra la letra y completa la oración',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Imagen
                Image.asset(
                  'assets/arbol.jpg',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error loading image');
                  },
                ),
                SizedBox(height: 40),
                // Palabra con espacio para completar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DragTarget<String>(
                      onAccept: (letter) {
                        checkAnswer(letter);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  candidateData.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child:
                                isCorrect
                                    ? Text(
                                      'á',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Color.fromARGB(
                                          255,
                                          117,
                                          211,
                                          109,
                                        ),
                                      ),
                                    )
                                    : Text(
                                      '_',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
                        );
                      },
                    ),
                    Text(
                      'r',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(195, 116, 108, 66),
                      ),
                    ),
                    Text(
                      'b',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 243, 82, 33),
                      ),
                    ),
                    Text(
                      'o',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 32, 61, 223),
                      ),
                    ),
                    Text(
                      'l',
                      style: TextStyle(fontSize: 40, color: Color(0xFFFF9800)),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Letras arrastrables
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...[
                      {'letter': 'e', 'color': Color(0xFF4FC3F7)},
                      {'letter': 'i', 'color': Color(0xFFFFEB3B)},
                      {'letter': 'a', 'color': Color(0xFFAED581)},
                      {'letter': 'o', 'color': Color(0xFFFFB74D)},
                      {'letter': 'u', 'color': Color(0xFF42A5F5)},
                    ].map((item) {
                      String letter = item['letter'] as String;
                      Color color = item['color'] as Color;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Draggable<String>(
                          data: letter,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                Spacer(),
                // Botón de flecha con color naranja
                if (isCorrect)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navega a SelectImagenScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectImagenScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Color naranja
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
