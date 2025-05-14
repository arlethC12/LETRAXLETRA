import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para SystemChrome
import 'package:audioplayers/audioplayers.dart';
import 'package:letra_x_letra/vocalI/rompecabesa.dart'; // Importa rompecabesa.dart
import 'package:letra_x_letra/vocalI/BurbujaI.dart'; // Importa BurbujaI.dart

void main() {
  // Configurar la pantalla inmersiva antes de iniciar la app
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(PalabraScreen());
}

class PalabraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordCompletionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordCompletionScreen extends StatefulWidget {
  @override
  _WordCompletionScreenState createState() => _WordCompletionScreenState();
}

class _WordCompletionScreenState extends State<WordCompletionScreen> {
  String firstLetter = '';
  String secondLetter = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Función para reproducir el audio
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalI/completa la palabra .m4a'),
      ); // Asegúrate de que el archivo esté en assets
    } catch (e) {
      print("Error al reproducir el audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera los recursos del reproductor de audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SingleChildScrollView(
        child: Container(
          height: size.height, // Ocupa toda la altura de la pantalla
          width: size.width, // Ocupa todo el ancho de la pantalla
          padding: EdgeInsets.all(size.width * 0.04), // Padding responsivo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Espacio adicional para bajar la X y la barra de progreso
              SizedBox(
                height: size.height * 0.05,
              ), // Ajusta este valor según necesites
              // Barra superior con botón de cerrar y progreso
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, size: size.width * 0.08),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RompecabesaScreen(),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value:
                          (firstLetter.isNotEmpty && secondLetter.isNotEmpty)
                              ? 1.0
                              : 0.5,
                      minHeight: size.height * 0.015,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              // Ícono de bocina antes del texto
              IconButton(
                icon: Icon(Icons.volume_up, size: size.width * 0.08),
                onPressed: _playAudio, // Reproduce el audio al presionar
              ),
              // Instrucciones
              Text(
                'Completa la palabra seleccionando las letras de los recuadros',
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              // Emoji de iglesia
              Text('⛪', style: TextStyle(fontSize: size.width * 0.25)),
              SizedBox(height: size.height * 0.03),
              // Letras de la palabra
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLetterBox(firstLetter, size),
                  Text(
                    'gles',
                    style: TextStyle(
                      fontSize: size.width * 0.1,
                      color: const Color.fromARGB(157, 255, 153, 0),
                    ),
                  ),
                  _buildLetterBox(secondLetter, size),
                  Text(
                    'a',
                    style: TextStyle(
                      fontSize: size.width * 0.1,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.08),
              // Letras seleccionables
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectableLetter('I', true, size),
                  SizedBox(width: size.width * 0.05),
                  _buildSelectableLetter('i', false, size),
                ],
              ),
              Spacer(), // Empuja el botón hacia abajo
              // Botón de avanzar
              if (firstLetter == 'I' && secondLetter == 'i')
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BurbujaIScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 233, 144, 42),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(size.width * 0.05),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: size.width * 0.08,
                    color: Colors.white,
                  ),
                ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para las cajas de letras
  Widget _buildLetterBox(String letter, Size size) {
    return Container(
      width: size.width * 0.12,
      height: size.width * 0.12,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Center(
        child: Text(letter, style: TextStyle(fontSize: size.width * 0.1)),
      ),
    );
  }

  // Widget para las letras seleccionables
  Widget _buildSelectableLetter(String letter, bool isFirstLetter, Size size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isFirstLetter) {
            firstLetter = letter;
          } else {
            secondLetter = letter;
          }
        });
      },
      child: Container(
        width: size.width * 0.12,
        height: size.width * 0.12,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color:
              ((isFirstLetter && firstLetter == letter) ||
                      (!isFirstLetter && secondLetter == letter))
                  ? Colors.grey[600]
                  : const Color.fromARGB(255, 241, 178, 178),
        ),
        child: Center(
          child: Text(letter, style: TextStyle(fontSize: size.width * 0.1)),
        ),
      ),
    );
  }
}
