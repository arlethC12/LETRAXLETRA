import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'pvocales.dart';
import 'main.dart';
import 'Continuara.dart';

class Niveles extends StatelessWidget {
  final String characterImagePath;
  final String username;

  const Niveles({
    Key? key,
    required this.characterImagePath,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      characterImagePath: characterImagePath,
      username: username,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String characterImagePath;
  final String username;

  const HomeScreen({
    Key? key,
    required this.characterImagePath,
    required this.username,
  }) : super(key: key);

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
      await _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        _navigateToMain(context);
        return;
      }

      final response = await http.post(
        Uri.parse('YOUR_API_BASE_URL/usuario/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await prefs.remove('auth_token');
        _navigateToMain(context);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al cerrar sesión')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error del servidor')));
      }
    }
  }

  void _navigateToMain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
      (route) => false,
    );
  }

  void _showProfileMenu(BuildContext context, Offset position) {
    final RenderBox? overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox?;
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
    ).then((String? value) async {
      if (value == 'edit_profile') {
        // Add navigation logic here
      } else if (value == 'logout') {
        await _handleLogout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;
    final scale =
        isMobile
            ? 1.0
            : isTablet
            ? 1.2
            : 1.5;
    final padding =
        size.width *
        (isMobile
            ? 0.05
            : isTablet
            ? 0.06
            : 0.07);
    final spacing =
        size.height *
        (isMobile
            ? 0.02
            : isTablet
            ? 0.03
            : 0.04);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          isMobile
              ? 50.0
              : isTablet
              ? 60.0
              : 70.0,
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
                    onTapDown: (TapDownDetails details) {
                      _showProfileMenu(context, details.globalPosition);
                    },
                    child: CircleAvatar(
                      radius:
                          isMobile
                              ? 20.0
                              : isTablet
                              ? 25.0
                              : 30.0,
                      backgroundImage: AssetImage(
                        characterImagePath.isNotEmpty &&
                                characterImagePath.contains('assets/')
                            ? characterImagePath
                            : 'assets/default.jpg',
                      ),
                    ),
                  ),
                  SizedBox(
                    width:
                        isMobile
                            ? 8.0
                            : isTablet
                            ? 10.0
                            : 12.0,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          isMobile
                              ? 15.0
                              : isTablet
                              ? 16.0
                              : 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              buildGradeCard(
                context,
                "Primer Grado",
                "COMENZAR",
                "assets/grado1.png",
                false,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VowelsScreen(
                            characterImagePath: characterImagePath,
                            username: username,
                            token: '',
                          ),
                    ),
                  );
                },
              ),
              SizedBox(height: spacing),
              buildGradeCard(
                context,
                "Segundo Grado",
                "",
                "assets/grado2.png",
                true,
                null,
              ),
              SizedBox(height: spacing),
              buildGradeCard(
                context,
                "Tercer Grado",
                "",
                "assets/grado3.png",
                true,
                null,
              ),
              SizedBox(height: spacing),
              buildGradeCard(
                context,
                "Cuarto Grado",
                "",
                "assets/grado4.png",
                true,
                null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/boca.jpg',
              height:
                  isMobile
                      ? 30.0
                      : isTablet
                      ? 30.0
                      : 35.0,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/micro.jpg',
              height:
                  isMobile
                      ? 30.0
                      : isTablet
                      ? 30.0
                      : 35.0,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.jpg',
              height:
                  isMobile
                      ? 30.0
                      : isTablet
                      ? 30.0
                      : 35.0,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/nota.jpg',
              height:
                  isMobile
                      ? 30.0
                      : isTablet
                      ? 30.0
                      : 35.0,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/juego.png',
              height:
                  isMobile
                      ? 30.0
                      : isTablet
                      ? 30.0
                      : 35.0,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Niveles(
                      characterImagePath: characterImagePath,
                      username: username,
                    ),
              ),
            );
          } else if (index == 0 || index == 1 || index == 3 || index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Continuara(
                      characterImagePath: characterImagePath,
                      username: username,
                    ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildGradeCard(
    BuildContext context,
    String title,
    String actionText,
    String imagePath,
    bool isLocked,
    VoidCallback? onTap,
  ) {
    final responsive = ResponsiveBreakpoints.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;
    final imageSize =
        size.width *
        (isMobile
            ? 0.35
            : isTablet
            ? 0.4
            : 0.45);

    return GestureDetector(
      onTap:
          isLocked
              ? () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Nivel Bloqueado'),
                        content: Text(
                          'Completa el nivel anterior para desbloquear $title.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                );
              }
              : onTap,
      child: Container(
        height:
            isMobile
                ? 160.0
                : isTablet
                ? 180.0
                : 200.0,
        decoration: BoxDecoration(
          color: const Color(0xFFFFC107),
          borderRadius: BorderRadius.circular(
            isMobile
                ? 10.0
                : isTablet
                ? 15.0
                : 20.0,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.volume_up,
                color: Colors.black,
                size:
                    isMobile
                        ? 25.0
                        : isTablet
                        ? 30.0
                        : 35.0,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:
                          isMobile
                              ? 20.0
                              : isTablet
                              ? 24.0
                              : 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height:
                        isMobile
                            ? 5.0
                            : isTablet
                            ? 8.0
                            : 10.0,
                  ),
                  Center(
                    child: Container(
                      width:
                          isMobile
                              ? 120.0
                              : isTablet
                              ? 150.0
                              : 180.0,
                      height:
                          isMobile
                              ? 40.0
                              : isTablet
                              ? 50.0
                              : 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          isMobile
                              ? 20.0
                              : isTablet
                              ? 25.0
                              : 30.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child:
                            isLocked
                                ? Image.asset(
                                  'assets/candado.png',
                                  height:
                                      isMobile
                                          ? 30.0
                                          : isTablet
                                          ? 35.0
                                          : 40.0,
                                  fit: BoxFit.contain,
                                )
                                : Text(
                                  actionText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize:
                                        isMobile
                                            ? 14.0
                                            : isTablet
                                            ? 16.0
                                            : 18.0,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                isMobile
                    ? 5.0
                    : isTablet
                    ? 8.0
                    : 10.0,
              ),
              child: Image.asset(
                imagePath,
                height: imageSize,
                width: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
