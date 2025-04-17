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
    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08), // 8% del alto
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: size.width * 0.09, // Escala según el ancho (antes 37)
            ),
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
                minHeight:
                    size.height * 0.015, // Escala según el alto (antes 10)
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              size.width * 0.04,
            ), // 4% del ancho (antes 16.0)
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02), // Antes 10
                Center(
                  child: Image.asset(
                    'assets/nombre.jpg',
                    width: size.width * 0.8, // 80% del ancho (antes 320)
                    height: size.height * 0.35, // 35% del alto (antes 300)
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: size.height * 0.01), // Antes 5
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.black,
                    size: size.width * 0.08, // Escala según el ancho (antes 30)
                  ),
                  onPressed: () async {
                    try {
                      await player.play(AssetSource('audios/dinombre.mp3'));
                    } catch (e) {
                      print("Error al reproducir audio: $e");
                    }
                  },
                ),
                SizedBox(height: size.height * 0.015), // Antes 8
                Text(
                  "¿Cuál es tu nombre?",
                  style: TextStyle(
                    fontSize:
                        size.width * 0.06, // Escala según el ancho (antes 24)
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.03), // Antes 20
                TextField(
                  decoration: InputDecoration(
                    hintText: "Tu nombre es...",
                    suffixIcon: Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: size.width * 0.06, // Escala según el ancho
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        size.width * 0.03,
                      ), // Escala según el ancho (antes 10)
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04), // Antes 30
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical:
                          size.height * 0.02, // Escala según el alto (antes 16)
                      horizontal:
                          size.width * 0.05, // Escala según el ancho (antes 20)
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        size.width * 0.03,
                      ), // Escala según el ancho (antes 10)
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Resga()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Continuar",
                        style: TextStyle(
                          fontSize:
                              size.width *
                              0.045, // Escala según el ancho (antes 18)
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02), // Antes 8
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: size.width * 0.06, // Escala según el ancho
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03), // Antes 20
              ],
            ),
          ),
        ),
      ),
    );
  }
}
