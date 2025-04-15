import 'package:flutter/material.dart';

class VowelsScreen extends StatefulWidget {
  final String characterImagePath;
  final String username;

  VowelsScreen({required this.characterImagePath, required this.username});

  @override
  _VowelsScreenState createState() => _VowelsScreenState();
}

class _VowelsScreenState extends State<VowelsScreen> {
  // Map para rastrear los tamaños dinámicos de las imágenes
  Map<String, double> _sizes = {
    "assets/vocalA.jpg": 90,
    "assets/vocalE.jpg": 90,
    "assets/vocalI.jpg": 90,
    "assets/vocalO.jpg": 90,
    "assets/vocalU.jpg": 90,
    "assets/vocales.jpg": 90,
  };

  void _onVowelPressed(String path) {
    setState(() {
      _sizes.keys.forEach((key) {
        _sizes[key] = key == path ? 120 : 90; // Ajusta tamaños
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 189, 162, 139),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.characterImagePath),
            ),
            SizedBox(width: 10),
            Text(
              widget.username,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Stack(
        children: [_buildVowelSectionTitle(), _buildImagesAndFootprints()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/boca.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/micro.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nota.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/juego.png', height: 35),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildVowelSectionTitle() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          color: const Color.fromARGB(
            238,
            235,
            179,
            27,
          ), // Fondo amarillo solo para el título y las vocales
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Unidad 1, Sección 1",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Vocales",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // Imagen del libro, ubicada en la esquina derecha
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/book.jpg",
                    ), // Ruta de la imagen del libro
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white, // Fondo blanco para el resto del contenido
          child: SizedBox(height: 20), // Espacio adicional si necesario
        ),
      ],
    );
  }

  Widget _buildImagesAndFootprints() {
    final List<Map<String, dynamic>> elements = [
      {"path": "assets/vocalA.jpg", "position": Offset(10, 130)},
      {"path": "assets/vocalE.jpg", "position": Offset(235, 210)},
      {"path": "assets/vocalI.jpg", "position": Offset(20, 300)},
      {"path": "assets/vocalO.jpg", "position": Offset(250, 390)},
      {"path": "assets/vocalU.jpg", "position": Offset(10, 460)},
      {"path": "assets/vocales.jpg", "position": Offset(250, 510)},
    ];

    final List<Offset> footprintPositions = [
      Offset(90, 170),
      Offset(143, 190),
      Offset(190, 200),
      Offset(220, 210),
      Offset(190, 240),
      Offset(140, 260),
      Offset(90, 280),
      Offset(95, 310),
      Offset(120, 350),
      Offset(180, 370),
      Offset(240, 390),
      Offset(210, 420),
      Offset(150, 440),
      Offset(100, 460),
      Offset(85, 490),
      Offset(120, 500),
      Offset(180, 510),
      Offset(240, 520),
    ];

    return Stack(
      children: [
        ...elements.map((element) {
          final path = element["path"] as String;
          return Positioned(
            left: (element["position"] as Offset).dx,
            top: (element["position"] as Offset).dy,
            child: GestureDetector(
              onTap: () => _onVowelPressed(path),
              child: Container(
                width: _sizes[path],
                height: _sizes[path],
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlueAccent,
                  image: DecorationImage(
                    image: AssetImage(path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        ...footprintPositions.map((position) {
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: Icon(Icons.pets, size: 25, color: Colors.black),
          );
        }).toList(),
      ],
    );
  }
}
