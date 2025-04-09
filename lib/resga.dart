import 'package:flutter/material.dart';
import 'resnum.dart'; // Importa el archivo resnum.dart para la navegación.

void main() {
  runApp(const Resga());
}

class Resga extends StatelessWidget {
  const Resga({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina el banner de depuración.
      home: Scaffold(
        backgroundColor: Colors.white, // Fondo blanco de la app.
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), // Altura del AppBar.
          child: AppBar(
            backgroundColor: Colors.transparent, // Fondo transparente.
            elevation: 0, // Sin sombra.
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 37, // Tamaño del ícono.
              ),
              onPressed: () {
                Navigator.pop(context); // Navega hacia atrás.
              },
            ),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(
                  value: 0.75, // Progreso del 75%.
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.yellow,
                  ),
                  minHeight: 10, // Altura de la barra de progreso.
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ), // Agrega espacio superior para la imagen.
                Image.asset(
                  'assets/añojaguar.jpg',
                  height: 250, // Altura de la imagen.
                ),
                const SizedBox(height: 20),
                const Icon(Icons.volume_up, size: 30, color: Colors.black),
                const SizedBox(height: 20),
                const Text(
                  '¿Cuántos años tienes?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Continuar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 9),
                      Icon(Icons.arrow_forward, size: 24, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
