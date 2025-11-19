import 'package:flutter/material.dart';
import 'package:letra_x_letra/modulo1exam/leccion6.dart'; // ← Lección 6
import 'package:letra_x_letra/modulo1exam/logro.dart'; // ← Pantalla de Logro

void main() => runApp(const Leccion7());

class Leccion7 extends StatelessWidget {
  const Leccion7({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AnimalesScreen(),
    );
  }
}

class AnimalesScreen extends StatefulWidget {
  const AnimalesScreen({super.key});

  @override
  State<AnimalesScreen> createState() => _AnimalesScreenState();
}

class _AnimalesScreenState extends State<AnimalesScreen> {
  final List<Map<String, dynamic>> animales = [
    {
      'nombre': 'Abeja',
      'imagen': 'assets/abeja.jpg',
      'vocal': true,
      'seleccionado': false,
    },
    {
      'nombre': 'Loro',
      'imagen': 'assets/luna.jpg',
      'vocal': false,
      'seleccionado': false,
    },
    {
      'nombre': 'Urraca',
      'imagen': 'assets/unicor.jpg',
      'vocal': true,
      'seleccionado': false,
    },
    {
      'nombre': 'Tigre',
      'imagen': 'assets/tiger.png',
      'vocal': false,
      'seleccionado': false,
    },
    {
      'nombre': 'Oso',
      'imagen': 'assets/oso.jpg',
      'vocal': true,
      'seleccionado': false,
    },
    {
      'nombre': 'Jirafa',
      'imagen': 'assets/pez.jpg',
      'vocal': false,
      'seleccionado': false,
    },
    {
      'nombre': 'Escorpión',
      'imagen': 'assets/elote.jpg',
      'vocal': true,
      'seleccionado': false,
    },
    {
      'nombre': 'Lobo',
      'imagen': 'assets/lobo.jpg',
      'vocal': false,
      'seleccionado': false,
    },
    {
      'nombre': 'Iguana',
      'imagen': 'assets/iguana.jpg',
      'vocal': true,
      'seleccionado': false,
    },
  ];

  // ← Verifica si todos los animales con vocal están seleccionados
  bool get _isComplete {
    int correctos =
        animales.where((a) => a['vocal'] && a['seleccionado']).length;
    int totalVocales = animales.where((a) => a['vocal']).length;
    return correctos == totalVocales;
  }

  @override
  Widget build(BuildContext context) {
    int correctos =
        animales.where((a) => a['vocal'] && a['seleccionado']).length;
    int totalVocales = animales.where((a) => a['vocal']).length;
    double progreso = totalVocales > 0 ? correctos / totalVocales : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // ← NAVEGAR A LECCIÓN 6
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Leccion6()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // === Barra de progreso naranja ===
          Container(
            height: 6,
            color: const Color(0xFFFFF3E0),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progreso,
              child: Container(color: Colors.orange),
            ),
          ),

          const SizedBox(height: 20),

          // === Instrucción ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.volume_up, color: Colors.black, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Encuentra el animal que empieza con las vocales',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // === Cuadrícula de animales ===
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1,
              ),
              itemCount: animales.length,
              itemBuilder: (context, index) {
                final animal = animales[index];
                final seleccionado = animal['seleccionado'];
                final esVocal = animal['vocal'];

                return GestureDetector(
                  onTap: () {
                    if (esVocal && !seleccionado) {
                      setState(() {
                        animal['seleccionado'] = true;
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Imagen
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(animal['imagen']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Círculo rojo si está seleccionado
                      if (seleccionado)
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 4),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // === Botón siguiente → Solo si está completo ===
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  _isComplete
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Logro()),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                disabledBackgroundColor: Colors.orange[200],
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
