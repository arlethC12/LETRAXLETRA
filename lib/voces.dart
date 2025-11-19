import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'pvocales.dart';
import 'main.dart';
import 'package:letra_x_letra/Juegos/juego.dart';
import 'package:letra_x_letra/niveles.dart'; // Asegúrate de que esta ruta sea correcta

class Voces extends StatefulWidget {
  final String characterImagePath;
  final String username;
  final String token;

  const Voces({
    Key? key,
    required this.characterImagePath,
    required this.username,
    this.token = '',
  }) : super(key: key);

  @override
  State<Voces> createState() => _VocesState();
}

class _VocesState extends State<Voces> {
  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar Sesión'),
            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sí'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    }
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
        _handleLogout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;

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
          // Título "Vocales"
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Text(
              'Vocales',
              style: TextStyle(
                fontSize: isMobile ? 28 : 34,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Botones de vocales
          Expanded(
            child: Center(
              child: Wrap(
                spacing: isMobile ? 16 : 24,
                runSpacing: isMobile ? 20 : 28,
                alignment: WrapAlignment.center,
                children:
                    [
                      {'letra': 'Aa', 'color': Colors.yellow},
                      {'letra': 'Ee', 'color': Colors.yellow},
                      {'letra': 'Ii', 'color': Colors.yellow},
                      {'letra': 'Oo', 'color': Colors.yellow},
                      {'letra': 'Uu', 'color': Colors.yellow},
                    ].map((vocal) {
                      return ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('¡${vocal['letra']}!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vocal['color'] as Color?,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 32 : 40,
                            vertical: isMobile ? 24 : 30,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          vocal['letra'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 36 : 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
              ),
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
        currentIndex: 0, // Cambiado a 0 porque estamos en "Voces" (boca)
        items: [
          _buildNavItem('assets/boca.jpg', isMobile, isTablet),
          _buildNavItem('assets/micro.jpg', isMobile, isTablet),
          _buildNavItem('assets/home.jpg', isMobile, isTablet),
          _buildNavItem('assets/nota.jpg', isMobile, isTablet),
          _buildNavItem('assets/juego.png', isMobile, isTablet),
        ],
        onTap: (index) {
          // CORREGIDO: navegación correcta según ícono
          if (index == 0) {
            // Boca: recargar esta pantalla (opcional)
            Navigator.pushReplacement(
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
          } else if (index == 2) {
            // Casa: ir a Niveles (pantalla principal de grados)
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
          } else if (index == 1 || index == 3 || index == 4) {
            // Micrófono, Nota, Juego: ir a Juego
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
}
