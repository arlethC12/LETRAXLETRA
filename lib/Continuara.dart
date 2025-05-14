import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:letra_x_letra/niveles.dart'; // Importa el archivo niveles.dart

class Continuara extends StatelessWidget {
  final String characterImagePath;
  final String username;

  const Continuara({
    super.key,
    required this.characterImagePath,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkingOnItScreen(
        characterImagePath: characterImagePath,
        username: username,
      ),
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFC79345, <int, Color>{
          50: const Color.fromRGBO(199, 147, 69, .1),
          100: const Color.fromRGBO(223, 138, 12, 0.2),
          200: const Color.fromRGBO(199, 147, 69, .3),
          300: const Color.fromRGBO(199, 147, 69, .4),
          400: const Color.fromRGBO(199, 147, 69, .5),
          500: const Color.fromRGBO(199, 147, 69, .6),
          600: const Color.fromRGBO(199, 147, 69, .7),
          700: const Color.fromRGBO(236, 225, 208, 0.8),
          800: const Color.fromRGBO(199, 147, 69, .9),
          900: const Color.fromRGBO(199, 147, 69, 1),
        }),
      ),
    );
  }
}

class WorkingOnItScreen extends StatefulWidget {
  final String characterImagePath;
  final String username;

  const WorkingOnItScreen({
    super.key,
    required this.characterImagePath,
    required this.username,
  });

  @override
  State<WorkingOnItScreen> createState() => _WorkingOnItScreenState();
}

class _WorkingOnItScreenState extends State<WorkingOnItScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _imageAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);

    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('audios/continu.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop the audio when disposing the screen
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 245, 176, 72),
              Color.fromARGB(255, 199, 147, 69),
              Color.fromARGB(255, 150, 103, 40),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _imageAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _imageAnimation.value,
                    child: Transform.scale(
                      scale: 1.0 + _imageAnimation.value.abs(),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/jaguiprog.png',
                  width: 200,
                  height: 250,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _textAnimation.value,
                    child: child,
                  );
                },
                child: const Text(
                  'Estamos trabajando en ello',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 63, 14, 14),
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _textAnimation.value,
                    child: child,
                  );
                },
                child: const Text(
                  'Próximamente estará disponible',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(179, 5, 4, 4),
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  await _audioPlayer.stop(); // Stop the audio before navigating
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Niveles(
                            characterImagePath: widget.characterImagePath,
                            username: widget.username,
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text(
                  'Regresar a la pantalla de inicio',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 63, 14, 14),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
