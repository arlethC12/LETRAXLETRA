import 'package:flutter/material.dart'; // Importa el paquete Flutter para UI
import 'package:audioplayers/audioplayers.dart'; // Importa el paquete audioplayers
import 'registro.dart'; // Importa la pantalla de registro
import 'resnum.dart'; // Importa la pantalla resnum

void main() {
  runApp(const MyApp()); // Inicia la aplicación ejecutando MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "Debug"
      theme: ThemeData(
        brightness: Brightness.light, // Define un tema claro
        scaffoldBackgroundColor: Colors.white, // Color de fondo blanco
      ),
      home: const HomeScreen(), // Establece HomeScreen como pantalla principal
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer(); // Instancia el reproductor de audio

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra elementos
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra textos
              children: <Widget>[
                Text(
                  'LETRA',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'X',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'LETRA',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Image.asset('assets/registro.jpg', width: 285, height: 285),
            const SizedBox(height: 30),
            IconButton(
              icon: Icon(Icons.volume_up, color: Colors.black, size: 36),
              onPressed: () async {
                try {
                  await player.play(
                    AssetSource('audios/Regis.mp3'), // Ruta relativa al archivo
                  );
                } catch (e) {
                  print(
                    "Error al reproducir el audio: $e",
                  ); // Log para depurar errores
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaInicio()),
                );
              },
              label: const Text(
                'Registrate',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE23B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              label: const Text(
                'Inicia Sesíon',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE23B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
