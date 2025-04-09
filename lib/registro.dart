import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'resga.dart';

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
    );
  }
}

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 37),
            onPressed: () {
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
                minHeight: 10,
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/nombre.jpg',
                  width: 320,
                  height: 300,
                ),
              ),
              const SizedBox(height: 5),
              IconButton(
                icon: const Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () async {
                  try {
                    await player.play(AssetSource('audios/dinombre.mp3'));
                  } catch (e) {
                    print("Error al reproducir audio: $e");
                  }
                },
              ),
              const SizedBox(height: 8),
              const Text(
                "¿Cuál es tu nombre?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "Tu nombre es...",
                  suffixIcon: const Icon(Icons.mic, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Color amarillo
                  foregroundColor: Colors.black, // Texto e ícono en negro
                  padding: const EdgeInsets.symmetric(
                    vertical: 16, // Altura del botón
                    horizontal: 20, // Espaciado interno
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Bordes redondeados
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Resga(),
                    ), // Navegar a otra pantalla
                  );
                },
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Ajusta el tamaño al contenido
                  children: const [
                    Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 18, // Tamaño del texto
                        fontWeight: FontWeight.bold, // Negritas
                      ),
                    ),
                    SizedBox(width: 8), // Espacio entre el texto y el icono
                    Icon(
                      Icons.arrow_forward, // Ícono de flecha
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
