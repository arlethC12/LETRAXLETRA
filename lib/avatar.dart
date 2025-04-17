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
    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.all(size.width * 0.04); // 4% del ancho

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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.05, // Escala según el ancho
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.03),
          child: SizedBox(
            height: size.height * 0.015,
            child: LinearProgressIndicator(
              value: 10,
              backgroundColor: Colors.grey[350],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calcular el número de columnas según el ancho
              int crossAxisCount = (constraints.maxWidth / 120).floor();
              if (crossAxisCount < 2) crossAxisCount = 2; // Mínimo 2 columnas

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: size.width * 0.04,
                  mainAxisSpacing: size.height * 0.02,
                  childAspectRatio: 1, // Relación de aspecto cuadrada
                ),
                itemCount: characterImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LoadingScreen(
                                imagePath: characterImages[index],
                              ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage(characterImages[index]),
                      radius: constraints.maxWidth / (crossAxisCount * 2.5),
                    ),
                  );
                },
              );
            },
          ),
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

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Niveles(
                    characterImagePath: widget.imagePath,
                    username: 'Invitado',
                  ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 197, 36),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_progress < 1.0)
                Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: size.width * 0.08, // Escala según el ancho
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
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: "X",
                        style: TextStyle(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: " LETRA",
                        style: TextStyle(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                loadingImages[currentImageIndex],
                height: size.height * 0.25, // 25% del alto de la pantalla
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                width: size.width * 0.7, // 70% del ancho
                height: size.height * 0.04,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 175, 55),
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                "Cargando...",
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
