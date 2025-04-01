import 'package:flutter/material.dart';
import 'avatar.dart'; // Importación del archivo avatar.dart

void main() {
  runApp(MyApp()); // Inicia la aplicación.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de depuración.
      home: MyHomePage(), // Establece la pantalla principal.
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          60,
        ), // Define la altura del AppBar.
        child: AppBar(
          backgroundColor: Colors.white, // Fondo blanco.
          elevation: 0, // Elimina la sombra del AppBar.
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black, // Color de la flecha de retroceso.
              size: 30, // Tamaño ajustado.
            ),
            onPressed: () {
              Navigator.pop(context); // Regresa a la pantalla anterior.
            },
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(
              top: 85.0,
            ), // Ajusta la posición vertical.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: 0.97, // Indica el progreso del formulario.
                  backgroundColor:
                      Colors.grey[300], // Color de fondo de la barra.
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.yellow,
                  ), // Color del progreso.
                  minHeight: 10, // Altura de la barra de progreso.
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset('assets/num.jpg', height: 300), // Imagen decorativa.
            SizedBox(height: 10),
            Icon(
              Icons.volume_up,
              size: 40,
              color: Colors.black,
            ), // Ícono de bocina para indicaciones de audio.
            SizedBox(height: 10),
            Text(
              'Ingresa tu número telefónico:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ), // Texto de instrucción.
            SizedBox(height: 10),
            Container(
              width: 300, // Ajusta el ancho del campo de texto.
              child: TextField(
                decoration: InputDecoration(
                  prefixText: '+52', // Prefijo para números de México.
                  prefixIcon: Icon(Icons.mic), // Ícono de micrófono.
                  border: OutlineInputBorder(), // Establece un borde visible.
                  labelText: 'Número', // Texto de referencia en el campo.
                ),
                keyboardType:
                    TextInputType.phone, // Configura el teclado numérico.
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharacterSelectionScreen(),
                  ),
                ); // Redirige a la pantalla de selección de avatar.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Fondo amarillo.
                foregroundColor: Colors.black, // Texto negro.
                padding: const EdgeInsets.symmetric(
                  vertical: 20, // Altura del botón.
                  horizontal: 40, // Anchura del botón.
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ), // Bordes redondeados.
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'CONTINUAR',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8), // Espaciado entre texto y flecha.
                  Icon(Icons.arrow_forward, size: 24), // Flecha de avance.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
