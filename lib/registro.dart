import 'package:flutter/material.dart'; // Importa el paquete Flutter para construir la UI
import 'resga.dart'; // Importa la pantalla Resga (ajusta la ruta según sea necesario)

void main() {
  runApp(const MiApp()); // Inicia la aplicación ejecutando MiApp
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          const PantallaInicio(), // Define PantallaInicio como la pantalla principal
      debugShowCheckedModeBanner: false, // Oculta la etiqueta "Debug"
    );
  }
}

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ajusta la altura del AppBar
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 37, // Flecha de regreso
            ),
            onPressed: () {
              Navigator.pop(context); // Regresa a la pantalla anterior
            },
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LinearProgressIndicator(
                value: 0.5, // Representa el progreso (50%)
                backgroundColor:
                    Colors.grey.shade300, // Color del fondo de la barra
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.yellow,
                ), // Color amarillo para el progreso
                minHeight: 10, // Altura de la barra de progreso
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Sin sombra
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margen alrededor del contenido
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch, // Alinea los elementos al ancho completo
          children: [
            const Spacer(), // Espacio flexible para centrar los elementos
            Center(
              child: Image.asset(
                'assets/nombre.jpg', // Imagen ubicada en la carpeta assets
                width: 320,
                height: 320,
              ),
            ),
            const SizedBox(height: 10), // Espacio entre elementos
            Center(
              child: Icon(
                Icons.volume_up, // Ícono de bocina
                color: Colors.black,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "¿Cuál es tu nombre?", // Pregunta para el usuario
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Tu nombre es...", // Texto de sugerencia en el campo
                suffixIcon: const Icon(
                  Icons.mic, // Ícono de micrófono para entrada por voz
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Bordes redondeados para el campo
                ),
              ),
            ),
            const Spacer(), // Espacio flexible para centrar los elementos
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Color de fondo amarillo
                foregroundColor: Colors.black, // Texto en color negro
                padding: const EdgeInsets.symmetric(
                  vertical: 16, // Altura del botón
                  horizontal: 30, // Anchura del botón
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Resga(), // Navega a la pantalla Resga
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "CONTINUAR", // Texto del botón
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 7), // Espacio entre el texto y el ícono
                  Icon(Icons.arrow_forward, size: 24), // Ícono de flecha
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
