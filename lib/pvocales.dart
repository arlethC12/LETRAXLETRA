import 'package:flutter/material.dart';
import 'dart:async';

// Pantalla principal que muestra las vocales
class VowelsScreen extends StatefulWidget {
  final String characterImagePath; // Ruta de imagen del personaje elegido
  final String username; // Nombre de usuario

  VowelsScreen({required this.characterImagePath, required this.username});

  @override
  _VowelsScreenState createState() => _VowelsScreenState();
}

class _VowelsScreenState extends State<VowelsScreen>
    with SingleTickerProviderStateMixin {
  // Tamaños iniciales de cada imagen de vocal, ajustados dinámicamente
  late Map<String, double> _sizes;
  late double _baseSize; // Tamaño base para las imágenes de vocales
  late double _enlargedSize; // Tamaño al hacer clic

  late AnimationController _controller; // Controlador de animación
  late Animation<double> _glowAnimation; // Animación de brillo para huellas
  int _currentFootprintIndex = 0; // Índice actual de huella resaltada
  late Timer _timer; // Timer para animación de huellas

  // Cambia el tamaño de la vocal seleccionada al hacer clic
  void _onVowelPressed(String path) {
    setState(() {
      _sizes.keys.forEach((key) {
        _sizes[key] = key == path ? _enlargedSize : _baseSize;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Inicializar tamaños dinámicos (se ajustarán en build con MediaQuery)
    _baseSize = 0;
    _enlargedSize = 0;
    _sizes = {
      "assets/vocalA.jpg": _baseSize,
      "assets/vocalE.jpg": _baseSize,
      "assets/vocalI.jpg": _baseSize,
      "assets/vocalO.jpg": _baseSize,
      "assets/vocalU.jpg": _baseSize,
      "assets/vocales.jpg": _baseSize,
    };

    // Inicializa la animación del brillo de las huellas
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Temporizador que cambia la huella resaltada cada 300ms
    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          _currentFootprintIndex =
              (_currentFootprintIndex + 1) % footprintPositions.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  // Lista de posiciones (coordenadas) de las huellas, ajustadas dinámicamente
  List<Offset> footprintPositions = [];

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    // Ajustar tamaños de vocales según el ancho de la pantalla
    _baseSize = size.width * 0.22; // 22% del ancho
    _enlargedSize = size.width * 0.3; // 30% del ancho al hacer clic
    _sizes.updateAll(
      (key, value) => _sizes[key] == _enlargedSize ? _enlargedSize : _baseSize,
    );

    // Ajustar posiciones de las huellas dinámicamente
    footprintPositions = [
      Offset(size.width * 0.28, size.height * 0.20),
      Offset(size.width * 0.35, size.height * 0.22),
      Offset(size.width * 0.42, size.height * 0.25),
      Offset(size.width * 0.48, size.height * 0.28),
      Offset(size.width * 0.42, size.height * 0.32),
      Offset(size.width * 0.35, size.height * 0.35),
      Offset(size.width * 0.28, size.height * 0.38),
      Offset(size.width * 0.32, size.height * 0.42),
      Offset(size.width * 0.38, size.height * 0.46),
      Offset(size.width * 0.44, size.height * 0.50),
      Offset(size.width * 0.50, size.height * 0.54),
      Offset(size.width * 0.54, size.height * 0.58),
      Offset(size.width * 0.48, size.height * 0.62),
      Offset(size.width * 0.40, size.height * 0.66),
      Offset(size.width * 0.32, size.height * 0.70),
      Offset(size.width * 0.36, size.height * 0.74),
      Offset(size.width * 0.42, size.height * 0.78),
      Offset(size.width * 0.48, size.height * 0.82),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08), // 8% del alto
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: size.width * 0.05, // Escala según el ancho
                backgroundImage: AssetImage(widget.characterImagePath),
              ),
              SizedBox(width: size.width * 0.03),
              Text(
                widget.username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.045, // Escala según el ancho
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: size.width * 0.07, // Escala según el ancho
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(height: size.height * 0.03),
              _buildVowelSectionTitle(),
              _buildImagesAndFootprints(),
              Positioned(
                right: size.width * 0.05,
                top: size.height * 0.15,
                child: Image.asset(
                  'assets/tiger.png',
                  height: size.height * 0.18, // 18% del alto
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/boca.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/micro.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nota.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/juego.png', height: size.height * 0.05),
            label: '',
          ),
        ],
      ),
    );
  }

  // Construye el encabezado con el nombre de la unidad y sección
  Widget _buildVowelSectionTitle() {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.03),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.015,
            horizontal: size.width * 0.04,
          ),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          decoration: BoxDecoration(
            color: const Color.fromARGB(238, 235, 179, 27),
            borderRadius: BorderRadius.circular(size.width * 0.04),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Unidad 1, Sección 1",
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Vocales",
                    style: TextStyle(
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: size.width * 0.12,
                height: size.width * 0.12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/book.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: SizedBox(height: size.height * 0.03),
        ),
      ],
    );
  }

  // Construye las imágenes de las vocales y las huellas animadas
  Widget _buildImagesAndFootprints() {
    final size = MediaQuery.of(context).size;

    // Ajustar posiciones de las vocales para que coincidan con el diseño de la imagen
    final List<Map<String, dynamic>> elements = [
      {
        "path": "assets/vocalA.jpg",
        "position": Offset(size.width * 0.03, size.height * 0.18),
      },
      {
        "path": "assets/vocalE.jpg",
        "position": Offset(size.width * 0.65, size.height * 0.30),
      },
      {
        "path": "assets/vocalI.jpg",
        "position": Offset(size.width * 0.03, size.height * 0.38),
      },
      {
        "path": "assets/vocalO.jpg",
        "position": Offset(size.width * 0.65, size.height * 0.46),
      },
      {
        "path": "assets/vocalU.jpg",
        "position": Offset(size.width * 0.03, size.height * 0.54),
      },
      {
        "path": "assets/vocales.jpg",
        "position": Offset(size.width * 0.65, size.height * 0.60),
      },
    ];

    return SizedBox(
      height: size.height, // Asegurar que el Stack tenga suficiente altura
      child: Stack(
        children: [
          // Dibuja cada imagen de vocal
          ...elements.map((element) {
            final path = element["path"] as String;
            return Positioned(
              left: (element["position"] as Offset).dx,
              top: (element["position"] as Offset).dy,
              child: GestureDetector(
                onTap: () => _onVowelPressed(path),
                child: Column(
                  children: [
                    if (path == "assets/vocales.jpg")
                      Image.asset(
                        'assets/corona.png',
                        height: size.height * 0.04, // 4% del alto
                      ),
                    Container(
                      width: _sizes[path],
                      height: _sizes[path],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        color: Colors.lightBlueAccent,
                        image: DecorationImage(
                          image: AssetImage(path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: size.width * 0.04,
                          color: const Color.fromARGB(255, 253, 232, 38),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // Dibuja las huellas con efecto de animación
          ...footprintPositions.asMap().entries.map((entry) {
            final index = entry.key;
            final position = entry.value;
            return Positioned(
              left: position.dx,
              top: position.dy - (size.height * 0.04),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity:
                        _currentFootprintIndex == index
                            ? _glowAnimation.value
                            : 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(
                              _currentFootprintIndex == index ? 0.6 : 0,
                            ),
                            blurRadius: size.width * 0.03,
                            spreadRadius: size.width * 0.005,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.pets,
                        size: size.width * 0.06,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
