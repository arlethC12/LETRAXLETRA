import 'package:flutter/material.dart';

void main() {
  // Inicia la aplicación Flutter
  runApp(Niveles());
}

class Niveles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Desactiva la barra de debug (etiqueta "DEBUG" en la esquina superior derecha)
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior de la aplicación (AppBar)
      appBar: AppBar(
        // Color beige para la barra superior
        backgroundColor: const Color.fromARGB(223, 235, 197, 117),
        title: Row(
          // Alinea los elementos al inicio (no necesitamos espacio entre ellos)
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Imagen personalizada del tigre en la barra superior
            Image.asset(
              'assets/ajaguar.jpg', // Reemplaza con tu imagen del tigre
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8), // Espacio entre la imagen y el texto
            // Texto "0II" que aparece en la barra superior
            const Text(
              '0II',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18, // Tamaño ajustado para que coincida con la imagen
              ),
            ),
          ],
        ),
        // Elimina la sombra del AppBar para que se vea más limpio
        elevation: 0,
      ),
      // Cuerpo principal de la pantalla
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ), // Margen ajustado
        child: Column(
          // Centra los botones verticalmente en la pantalla
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón para "Primer Grado"
            _buildGradeButton(
              context,
              'PRIMER GRADO', // Texto principal
              'COMENZAR', // Texto secundario
              'assets/ajaguar.jpg', // Imagen del tigre para este grado
              isLocked: false, // No está bloqueado
            ),
            const SizedBox(height: 8), // Espacio reducido entre botones
            // Botón para "Segundo Grado"
            _buildGradeButton(
              context,
              'SEGUNDO GRADO',
              '', // Sin texto secundario
              'assets/ajaguar.jpg', // Imagen del tigre para este grado
              isLocked: true, // Está bloqueado
            ),
            const SizedBox(height: 8),
            // Botón para "Tercer Grado"
            _buildGradeButton(
              context,
              'TERCER GRADO',
              '',
              'assets/ajaguar.jpg',
              isLocked: false,
            ),
            const SizedBox(height: 8),
            // Botón para "Cuarto Grado"
            _buildGradeButton(
              context,
              'CUARTO GRADO',
              '',
              'assets/ajaguar.jpg',
              isLocked: true,
            ),
          ],
        ),
      ),
      // Barra de navegación inferior con íconos
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Mantiene los íconos fijos
        backgroundColor: Colors.white, // Fondo blanco para la barra
        selectedItemColor: Colors.black, // Color de los íconos seleccionados
        unselectedItemColor:
            Colors.black, // Color de los íconos no seleccionados
        items: const [
          // Ícono para la boca (usaremos imágenes personalizadas)
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/ajaguar.jpg'), // Reemplaza con tu imagen
              size: 30,
            ),
            label: '',
          ),
          // Ícono para el micrófono
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          // Ícono para la casa
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          // Ícono para el lápiz
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          // Ícono para el joystick
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
        ],
      ),
    );
  }

  // Método para construir cada botón de grado (Primer, Segundo, etc.)
  Widget _buildGradeButton(
    BuildContext context,
    String mainText,
    String subText,
    String tigerImage, {
    required bool isLocked,
  }) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      height: 80, // Altura ajustada para que coincida con la imagen
      child: Stack(
        children: [
          // Botón principal con fondo amarillo
          Material(
            color: const Color(0xFFFFD700), // Color amarillo del botón
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
            child: InkWell(
              // Acción al presionar el botón (desactivada si está bloqueado)
              onTap:
                  isLocked
                      ? null // No hace nada si está bloqueado
                      : () {
                        // Aquí puedes agregar la lógica para cuando se presione el botón
                        // Por ejemplo, navegar a otra pantalla
                      },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ), // Margen interno horizontal
                child: Row(
                  // Alinea el texto y la imagen dentro del botón
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Columna para el texto (principal y secundario)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texto principal (por ejemplo, "PRIMER GRADO")
                        Text(
                          mainText,
                          style: const TextStyle(
                            fontSize: 22, // Tamaño ajustado
                            fontWeight: FontWeight.bold, // Texto en negrita
                            color: Colors.black, // Color del texto
                          ),
                        ),
                        // Texto secundario (por ejemplo, "COMENZAR")
                        if (subText.isNotEmpty)
                          Text(
                            subText,
                            style: const TextStyle(
                              fontSize: 16, // Tamaño más pequeño
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                    // Imagen del tigre personalizada para cada grado
                    Image.asset(
                      tigerImage, // Imagen específica para cada grado
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Si el botón está bloqueado, muestra un ícono de candado
          if (isLocked)
            Positioned(
              right: 16, // Posición del candado desde la derecha
              top: 0,
              bottom: 0,
              child: Center(
                child: Image.asset(
                  'assets/ajaguar.jpg', // Imagen personalizada del candado
                  width: 24, // Tamaño ajustado
                  height: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
