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
      home: JaguarWalkingScreen(characterImagePath: 'assets/caminajaguar.jpg'),
    );
  }
}

class JaguarWalkingScreen extends StatefulWidget {
  final String characterImagePath;

  const JaguarWalkingScreen({Key? key, required this.characterImagePath})
    : super(key: key);

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
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _controller.addListener(() {
      if (mounted && _animation.value != null) {
        setState(() {
          final progress = _animation.value / MediaQuery.of(context).size.width;
          _currentFootprintIndex = (progress * 10).floor();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screenWidth = MediaQuery.of(context).size.width;
    _animation = Tween<double>(
      begin: 0,
      end: screenWidth - 150,
    ).animate(_controller);

    _controller.forward();
    // Redirigir después de que la animación termine
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reemplaza la pantalla actual con la nueva
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => VowelsScreen(
                  characterImagePath: widget.characterImagePath,
                  username: 'invitado', // Cambia esto por el nombre del usuario
                ),
          ),
        );
      }
    });
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
          Container(color: Colors.white),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.25),
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
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value,
                top: size.height * 0.45,
                child: SizedBox(
                  width: 150,
                  child: Image.asset(
                    widget.characterImagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: size.height * 0.59,
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
                            : Colors.grey.shade400,
                    size: size.width * 0.05,
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
