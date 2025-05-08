import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for audio playback
import 'unirimag.dart'; // Importa el archivo unirimag.dart
import 'selectimagen.dart'; // Importa selectimagen.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quitar el debug banner
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  // Lista de mapas para definir las imágenes y su estado
  List<Map<String, dynamic>> gridItems = [
    {'path': 'assets/avion.jpg', 'hasSmiley': false, 'name': 'avion.jpg'},
    {'path': 'assets/luna.jpg', 'hasSmiley': false, 'name': 'luna.jpg'},
    {'path': 'assets/rosa.jpg', 'hasSmiley': false, 'name': 'rosa.jpg'},
    {
      'path': 'assets/ventilador.jpg',
      'hasSmiley': false,
      'name': 'ventilador.jpg',
    },
    {'path': 'assets/pez.jpg', 'hasSmiley': false, 'name': 'pez.jpg'},
    {'path': 'assets/arl.jpg', 'hasSmiley': false, 'name': 'arbol.jpg'},
    {'path': 'assets/abejita.jpg', 'hasSmiley': false, 'name': 'abejita.jpg'},
    {'path': 'assets/bate.jpg', 'hasSmiley': false, 'name': 'bate.jpg'},
    {'path': 'assets/vaca.jpg', 'hasSmiley': false, 'name': 'vaca.jpg'},
  ];

  final AudioPlayer _audioPlayer = AudioPlayer(); // Added for audio playback

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose audio player
    super.dispose();
  }

  void _toggleSmiley(int index) {
    String imageName = gridItems[index]['name'] ?? '';
    if (!imageName.toLowerCase().startsWith('a')) {
      return; // No permite añadir carita feliz si no empieza con "a"
    }
    setState(() {
      gridItems[index]['hasSmiley'] = !gridItems[index]['hasSmiley'];
    });
  }

  // Verificar si la lección está completa (todas las imágenes que empiezan con "A" tienen carita)
  bool get _isLessonComplete {
    return gridItems.every((item) {
      String imageName = item['name'].toLowerCase();
      if (imageName.startsWith('a')) {
        return item['hasSmiley'] == true;
      }
      return true; // Ignorar imágenes que no empiezan con "A"
    });
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
                      // Navegar hacia selectimagen.dart al presionar "X"
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectImagenScreen(),
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
                          value: 0.7,
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
            // Texto centrado con ícono de audio antes del texto
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.black, size: 24),
                    onPressed: () async {
                      await _audioPlayer.play(
                        AssetSource('audios/VocalA/Di el nombre de cada.m4a'),
                      ); // Play audio
                    },
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Selecciona las imágenes que empiecen con la letra A',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            // Cuadrícula 3x3
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                  shrinkWrap: true,
                  children: List.generate(gridItems.length, (index) {
                    return _buildImageContainer(index);
                  }),
                ),
              ),
            ),
            // Botón de navegación (solo aparece si la lección está completa)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  _isLessonComplete
                      ? IconButton(
                        onPressed: () {
                          // Navegar hacia unirimag.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnirimagScreen(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                      )
                      : SizedBox.shrink(), // No mostrar nada si la lección no está completa
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(int index) {
    String imagePath = gridItems[index]['path'];
    bool hasSmiley = gridItems[index]['hasSmiley'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: Center(
                  child: Text('Error', style: TextStyle(color: Colors.red)),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () => _toggleSmiley(index),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child:
                hasSmiley
                    ? Icon(
                      Icons.sentiment_satisfied,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 28,
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
