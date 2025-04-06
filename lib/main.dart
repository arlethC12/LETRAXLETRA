import 'package:flutter/material.dart'; // Importa el paquete Flutter para UI
import 'registro.dart'; // Importa la pantalla de registro

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
    return Scaffold(
      backgroundColor: Colors.white, // Fondo de la pantalla en blanco
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra los elementos verticalmente
          children: <Widget>[
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra los textos horizontalmente
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
                const SizedBox(width: 10), // Espacio entre textos
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
            const SizedBox(height: 30), // Espacio entre elementos
            // Imagen central
            Image.asset('assets/registro.jpg', width: 285, height: 285),
            const SizedBox(height: 30),

            // Ícono de bocina
            IconButton(
              icon: Icon(Icons.volume_up, color: Colors.black, size: 36),
              onPressed: () {
                // Implementa funcionalidad de audio aquí
              },
            ),
            const SizedBox(height: 20),

            // Botón "Regístrate"
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaInicio(),
                  ), // Navega a la pantalla de inicio
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
                backgroundColor: const Color(0xFFFFE23B), // Color amarillo
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Botón "Inicia Sesión"
            ElevatedButton.icon(
              onPressed: () {
                // Implementa navegación para "Inicia Sesión"
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
                backgroundColor: const Color(0xFFFFE23B), // Color amarillo
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
