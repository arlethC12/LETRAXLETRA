import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for audio playback
import 'caritaselet.dart'; // Importar el archivo de la nueva pantalla
import 'compalabra.dart'; // Importar el archivo de la pantalla anterior

void main() {
  runApp(SelectImagenScreen());
}

class SelectImagenScreen extends StatelessWidget {
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
  String? selectedImage;
  final String correctImage = 'abeja.jpg';
  final AudioPlayer _audioPlayer = AudioPlayer(); // Added for audio playback

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose audio player
    super.dispose();
  }

  void _onImageTap(String imageName) {
    setState(() {
      selectedImage = imageName;
    });
  }

  Color _getBorderColor(String imageName) {
    if (selectedImage == null) return Colors.transparent;
    if (imageName == selectedImage) {
      return imageName == correctImage ? Colors.green : Colors.red;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Barra de progreso con "X", más ancha y con bordes circulares
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Volver a la pantalla compalabra.dart
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompalabraScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.close, color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      height: 10, // Barra más ancha
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          7.5,
                        ), // Bordes circulares
                        child: LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Título, ícono de bocina y texto "abeja"
            Column(
              children: [
                Text(
                  'Selecciona la imagen correcta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up, color: Colors.black),
                      onPressed: () async {
                        await _audioPlayer.play(
                          AssetSource(
                            'audios/VocalA/Sonido Zumbido de Abeja (mp3cut.net).mp3',
                          ),
                        ); // Play audio
                      },
                    ),
                    SizedBox(width: 8),
                    Text('abeja', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            // Cuadrícula de imágenes más pequeñas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 32.0,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildImageContainer('dino.jpg'),
                    _buildImageContainer('unicor.jpg'),
                    _buildImageContainer('mariposa.jpg'),
                    _buildImageContainer('abeja.jpg'),
                  ],
                ),
              ),
            ),
            // Texto "Correcto" y botón de navegación (solo aparece si es correcto)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (selectedImage == correctImage)
                    Text(
                      'Correcto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  if (selectedImage == correctImage)
                    SizedBox(
                      height: 55,
                    ), // Espacio para mover "Correcto" más arriba
                  if (selectedImage == correctImage)
                    IconButton(
                      onPressed: () {
                        // Navegar a la pantalla CaritaSelect cuando se presiona la flecha
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 36,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(String imageName) {
    return GestureDetector(
      onTap: () => _onImageTap(imageName),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _getBorderColor(imageName), width: 3),
        ),
        child: Image.asset(
          'assets/$imageName',
          fit: BoxFit.contain,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
