import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:letra_x_letra/niveles.dart';
import 'package:letra_x_letra/Juegos/juego.dart';
import 'package:letra_x_letra/voces.dart';
import 'main.dart';

class Escritura extends StatefulWidget {
  final String characterImagePath;
  final String username;
  final String token;

  const Escritura({
    Key? key,
    required this.characterImagePath,
    required this.username,
    this.token = '',
  }) : super(key: key);

  @override
  State<Escritura> createState() => _EscrituraState();
}

class _EscrituraState extends State<Escritura> {
  List<Offset?> _points = [];
  int _currentWordIndex = 0;

  // Lista de palabras para practicar
  final List<String> _palabras = [
    'abeja',
    'ratón',
    'casa',
    'sol',
    'luna',
    'perro',
    'gato',
    'árbol',
    'flor',
    'libro',
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;

    final String palabraActual = _palabras[_currentWordIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          isMobile
              ? 60
              : isTablet
              ? 70
              : 80,
        ),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      _showProfileMenu(context, details.globalPosition);
                    },
                    child: CircleAvatar(
                      radius:
                          isMobile
                              ? 22
                              : isTablet
                              ? 28
                              : 32,
                      backgroundImage: AssetImage(
                        widget.characterImagePath.isNotEmpty &&
                                widget.characterImagePath.contains('assets/')
                            ? widget.characterImagePath
                            : 'assets/default.jpg',
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Título + palabra a escribir
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              children: [
                Text(
                  'Escribe la palabra:',
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 32 : 48,
                    vertical: isMobile ? 16 : 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Text(
                    palabraActual.toUpperCase(),
                    style: TextStyle(
                      fontSize: isMobile ? 36 : 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pizarra para escribir
          Expanded(
            child: Container(
              margin: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[800]!, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _points.add(details.localPosition);
                    });
                  },
                  onPanEnd: (details) {
                    _points.add(null); // Separar trazos
                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _PizarraPainter(_points),
                  ),
                ),
              ),
            ),
          ),

          // Botones: Borrar y Siguiente
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 30,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _points.clear();
                    });
                  },
                  icon: Icon(Icons.refresh, size: isMobile ? 20 : 24),
                  label: Text(
                    'Borrar',
                    style: TextStyle(fontSize: isMobile ? 16 : 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 28,
                      vertical: isMobile ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _points.clear();
                      _currentWordIndex =
                          (_currentWordIndex + 1) % _palabras.length;
                    });
                  },
                  icon: Icon(Icons.arrow_forward, size: isMobile ? 20 : 24),
                  label: Text(
                    'Siguiente',
                    style: TextStyle(fontSize: isMobile ? 16 : 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 28,
                      vertical: isMobile ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        currentIndex: 3, // Nota = Escritura
        items: [
          _buildNavItem('assets/boca.jpg', isMobile, isTablet),
          _buildNavItem('assets/micro.jpg', isMobile, isTablet),
          _buildNavItem('assets/home.jpg', isMobile, isTablet),
          _buildNavItem('assets/nota.jpg', isMobile, isTablet),
          _buildNavItem('assets/juego.png', isMobile, isTablet),
        ],
        onTap: (index) {
          if (index == 3) {
            // Recargar esta pantalla
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Escritura(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          } else if (index == 2) {
            // Home → Niveles
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Niveles(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    ),
              ),
            );
          } else if (index == 0) {
            // Boca → Voces
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Voces(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          } else if (index == 1 || index == 4) {
            // Micro o Juego → Juego
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Juego(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          }
        },
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    String asset,
    bool isMobile,
    bool isTablet,
  ) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        asset,
        height:
            isMobile
                ? 30
                : isTablet
                ? 35
                : 40,
        fit: BoxFit.contain,
      ),
      label: '',
    );
  }

  void _showProfileMenu(BuildContext context, Offset position) {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit_profile',
          child: Text('Editar Perfil'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Cerrar Sesión'),
        ),
      ],
    ).then((value) {
      if (value == 'logout') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          (route) => false,
        );
      }
    });
  }
}

// Clase para dibujar en la pizarra
class _PizarraPainter extends CustomPainter {
  final List<Offset?> points;

  _PizarraPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue[800]!
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PizarraPainter oldDelegate) => true;
}
