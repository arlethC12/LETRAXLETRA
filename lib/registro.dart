// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'resga.dart'; // Asegúrate de que este archivo existe

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PantallaInicio(),
      debugShowCheckedModeBanner: false,
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 460, name: MOBILE),
              const Breakpoint(start: 461, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
            ],
          ),
    );
  }
}

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  late AudioPlayer player;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Estado: $val'),
        onError: (val) => print('Error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult:
              (val) => setState(() {
                _text = val.recognizedWords;
                _controller.text = _text;
              }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _navigateToNextScreen(String nombre) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Resga(nombre: nombre)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double padding =
        size.width * (isMobile ? 0.04 : (isTablet ? 0.05 : 0.06));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          size.height * (isMobile ? 0.06 : (isTablet ? 0.08 : 0.1)),
        ),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24 * scaleFactor,
            ),
            onPressed: () async {
              await player.stop();
              _speech.stop();
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                minHeight:
                    size.height * (isMobile ? 0.01 : (isTablet ? 0.015 : 0.02)),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: spacing),
              Center(
                child: Image.asset(
                  'assets/nombre.jpg',
                  width: size.width * (isMobile ? 0.7 : (isTablet ? 0.6 : 0.5)),
                  height:
                      size.height * (isMobile ? 0.3 : (isTablet ? 0.35 : 0.4)),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: spacing * 0.5),
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 38 * scaleFactor,
                ),
                onPressed: () async {
                  try {
                    await player.play(AssetSource('audios/dinombre.mp3'));
                  } catch (e) {
                    print("Error al reproducir audio: $e");
                  }
                },
              ),
              SizedBox(height: spacing),
              Text(
                "¿Cuál es tu nombre?",
                style: TextStyle(
                  fontSize: 25 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing * 1.5),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Tu nombre es...",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.black,
                      size: 24 * scaleFactor,
                    ),
                    onPressed: _listen,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                ),
              ),
              SizedBox(height: spacing * 2),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    vertical: 12 * scaleFactor,
                    horizontal: 24 * scaleFactor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                ),
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          final nombre = _controller.text.trim();
                          if (nombre.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, ingresa tu nombre'),
                              ),
                            );
                            return;
                          }
                          _navigateToNextScreen(nombre);
                        },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 18 * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 24 * scaleFactor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }
}

// Aquí se añade la clase ResponsiveScreen con el parámetro `nombre`
class ResponsiveScreen extends StatelessWidget {
  final String nombre;

  const ResponsiveScreen({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla Responsive')),
      body: Center(
        child: Text('Hola $nombre', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
