// 👇👇👇 Importaciones al inicio
import 'package:flutter/material.dart';
import 'dart:async';
import 'niveles.dart'; // Asegúrate que Niveles reciba imagePath como parámetro

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CharacterSelectionScreen(),
    );
  }
}

// Pantalla de selección de personaje
class CharacterSelectionScreen extends StatelessWidget {
  final List<String> characterImages = [
    'assets/ajaguar.jpg',
    'assets/amono.jpg',
    'assets/aqueztal.jpg',
    'assets/atucan.jpg',
    'assets/apuma.jpg',
    'assets/aguacamaya.jpg',
    'assets/achita.jpg',
    'assets/aaguila.jpg',
    'assets/acocodrilo.jpg',
    'assets/atapir.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Elige tu personaje",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: SizedBox(
            height: 10.0,
            child: LinearProgressIndicator(
              value: 10,
              backgroundColor: Colors.grey[350],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 18.0,
            mainAxisSpacing: 18.0,
          ),
          itemCount: characterImages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            LoadingScreen(imagePath: characterImages[index]),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(characterImages[index]),
                radius: 60.0,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Pantalla de carga tras seleccionar un personaje
class LoadingScreen extends StatefulWidget {
  final String imagePath;

  LoadingScreen({required this.imagePath});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  final List<String> loadingImages = [
    'assets/car1.jpg',
    'assets/car2.jpg',
    'assets/car3.jpg',
    'assets/car4.jpg',
  ];
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _progress += 0.2;
        currentImageIndex = (currentImageIndex + 1) % loadingImages.length;
        if (_progress >= 1.0) {
          timer.cancel();
          _progress = 1.0;

          // ✅ PASAMOS LA IMAGEN SELECCIONADA A NIVELES
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Niveles(
                    characterImagePath: widget.imagePath,
                    username: 'Invitado', // o cualquier texto por defecto
                  ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 197, 36),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_progress < 1.0)
              Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            if (_progress >= 1.0)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "LETRA ",
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: "X",
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: " LETRA",
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.0),
            Image.asset(loadingImages[currentImageIndex], height: 200.0),
            SizedBox(height: 20.0),
            Container(
              width: 300.0,
              height: 25.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 175, 55),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            SizedBox(height: 35.0),
            Text(
              "Cargando...",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
