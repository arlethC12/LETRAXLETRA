import 'package:flutter/material.dart';
import 'resnum.dart'; // Importa el archivo resnum.dart para la navegación.

void main() {
  runApp(const Resga()); // Inicia la aplicación ejecutando la clase Resga.
}

class Resga extends StatelessWidget {
  const Resga({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Elimina el banner de depuración en la esquina superior derecha.
      home: Scaffold(
        backgroundColor:
            Colors.white, // Establece el fondo blanco de la aplicación.
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            60,
          ), // Ajusta la altura del AppBar a 60 píxeles.
          child: AppBar(
            backgroundColor:
                Colors.transparent, // Hace que el AppBar sea transparente.
            elevation: 0, // Elimina la sombra del AppBar.
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 37, // Ajusta el tamaño de la flecha de retroceso.
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                ); // Regresa a la pantalla anterior cuando se presiona el botón.
              },
            ),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(
                  value:
                      0.75, // Indica un progreso del 75% en la barra de progreso.
                  backgroundColor:
                      Colors
                          .grey
                          .shade300, // Establece el color de fondo de la barra de progreso.
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.yellow,
                  ), // Establece el color amarillo para la barra de progreso.
                  minHeight:
                      10, // Ajusta la altura de la barra de progreso a 10 píxeles.
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ), // Agrega un margen interno de 16 píxeles alrededor del contenido.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(), // Agrega un espacio flexible para centrar los elementos.
              Image.asset(
                'assets/añojaguar.jpg', // Imagen del jaguar, asegurarse de que el archivo esté en la carpeta assets.
                height: 250, // Ajusta la altura de la imagen a 250 píxeles.
              ),
              const SizedBox(
                height: 20,
              ), // Agrega un espacio entre la imagen y el ícono.
              const Icon(
                Icons.volume_up,
                size: 30,
                color: Colors.black,
              ), // Ícono de bocina para reproducción de audio.
              const SizedBox(height: 20), // Espacio entre el ícono y el texto.
              const Text(
                '¿Cuántos años tienes?', // Texto que pregunta la edad del usuario.
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ), // Aplica un estilo negrita y tamaño de fuente 24.
              ),
              const SizedBox(
                height: 10,
              ), // Agrega un espacio entre el texto y el campo de entrada.
              TextField(
                decoration: InputDecoration(
                  hintText:
                      '6', // Texto de ejemplo dentro del campo de entrada.
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ), // Bordes redondeados para el campo de entrada.
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  suffixIcon: const Icon(
                    Icons.mic,
                    color: Colors.black,
                  ), // Ícono de micrófono agregado al campo de entrada.
                ),
                keyboardType:
                    TextInputType
                        .number, // Define el teclado numérico para la entrada de datos.
              ),
              const SizedBox(
                height: 40,
              ), // Espacio entre el campo de entrada y el botón.
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyHomePage(), // Navega a la pantalla definida en resnum.dart.
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors
                          .yellow, // Establece el fondo del botón en color amarillo.
                  foregroundColor:
                      Colors.black, // Establece el color del texto en negro.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Bordes redondeados para el botón.
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Continuar", // Texto del botón.
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 9,
                    ), // Espacio entre el texto y el ícono de flecha.
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: Colors.black,
                    ), // Ícono de flecha hacia adelante.
                  ],
                ),
              ),
              const Spacer(), // Agrega espacio al final para centrar los elementos.
            ],
          ),
        ),
      ),
    );
  }
}
