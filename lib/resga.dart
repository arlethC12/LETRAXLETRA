import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'resnum.dart';
import 'registro.dart';

void main() {
  runApp(const Resga());
}

class Resga extends StatelessWidget {
  const Resga({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ResponsiveScreen(),
    );
  }
}

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  final AudioPlayer _player = AudioPlayer();

  void _playAudio() async {
    await _player.play(AssetSource('audios/edad.mp3'));
  }

  void _stopAudio() async {
    await _player.stop(); // 👈 Detiene el audio
  }

  @override
  void dispose() {
    _player.dispose(); // 👈 Libera los recursos del reproductor
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
            onPressed: () {
              _stopAudio(); // 👈 Detén el audio antes de navegar
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PantallaInicio()),
              );
            },
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LinearProgressIndicator(
                value: 0.75,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                minHeight: 10,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Image.asset(
                'assets/añojaguar.jpg',
                height: screenHeight * 0.3,
                width: screenWidth * 0.8,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(
                  Icons.volume_up,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: _playAudio,
              ),
              const SizedBox(height: 20),
              Text(
                '¿Cuántos años tienes?',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: '6',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  suffixIcon: const Icon(Icons.mic, color: Colors.black),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _stopAudio(); // 👈 Detén el audio antes de navegar
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
