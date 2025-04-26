import 'package:flutter/material.dart';
import 'package:letra_x_letra/pvocales.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JaguarWalkingScreen(),
    );
  }
}

class JaguarWalkingScreen extends StatefulWidget {
  @override
  _JaguarWalkingScreenState createState() => _JaguarWalkingScreenState();
}

class _JaguarWalkingScreenState extends State<JaguarWalkingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentFootprintIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // Animación lenta
      vsync: this,
    );

    // Listener para actualizar las huellas durante la animación
    _controller.addListener(() {
      setState(() {
        final progress =
            _animation.value /
            MediaQuery.of(context).size.width; // Progresión dinámica de huellas
        _currentFootprintIndex = (progress * 10).floor();
      });
    });

    // Navegar al finalizar la animación
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VowelsScreen(
                  characterImagePath: 'assets/caminajaguar.jpg',
                  username: 'UsuarioEjemplo',
                ),
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Configuración correcta de la animación con MediaQuery
    _animation = Tween<double>(
      begin: 0,
      end: MediaQuery.of(context).size.width - 150, // Movimiento horizontal
    ).animate(_controller);

    // Iniciar la animación después de configurar MediaQuery
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo blanco
          Container(color: Colors.white),
          // Texto centrado "Letra x Letra"
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: size.height * 0.25,
              ), // Subir el texto
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Letra ',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: 'X ',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: 'Letra',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Jaguar animado
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value,
                top: size.height * 0.45, // Centrado verticalmente
                child: SizedBox(
                  width: 150,
                  child: Image.asset(
                    'assets/caminajaguar.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          // Huellas progresivas detrás del jaguar
          Positioned(
            top: size.height * 0.59, // Debajo del jaguar
            left: size.width * 0.1,
            child: Row(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.pets,
                    color:
                        index < _currentFootprintIndex
                            ? Colors.black
                            : Colors.grey.shade400, // Huellas dinámicas
                    size: size.width * 0.05, // Tamaño proporcional
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
