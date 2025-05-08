import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'pvocales.dart';
import 'main.dart';

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

  // Show logout confirmation dialog and handle logout
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

  // Logout function to call the API and clear token
  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        // No token found, proceed to main screen
        _navigateToMain(context);
        return;
      }

      final response = await http.post(
        Uri.parse('YOUR_API_BASE_URL/usuario/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Clear token on successful logout
        await prefs.remove('auth_token');
        _navigateToMain(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al cerrar sesión')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error del servidor')));
    }
  }

  // Navigate to main screen
  void _navigateToMain(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  // Show popup menu for profile options
  void _showProfileMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
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
        // Navigate to edit profile screen
        // Add your navigation logic here
      } else if (value == 'logout') {
        await _handleLogout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final double padding =
        size.width * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.07));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveValue<double>(
            context,
            defaultValue: size.height * 0.08,
            conditionalValues: const [
              Condition.equals(name: MOBILE, value: 50.0),
              Condition.equals(name: TABLET, value: 60.0),
              Condition.equals(name: DESKTOP, value: 70.0),
            ],
          ).value,
        ),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
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
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.05,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 20.0),
                              Condition.equals(name: TABLET, value: 25.0),
                              Condition.equals(name: DESKTOP, value: 30.0),
                            ],
                          ).value,
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
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.width * 0.03,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 8.0),
                            Condition.equals(name: TABLET, value: 10.0),
                            Condition.equals(name: DESKTOP, value: 12.0),
                          ],
                        ).value,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.045,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 15.0),
                              Condition.equals(name: TABLET, value: 16.0),
                              Condition.equals(name: DESKTOP, value: 18.0),
                            ],
                          ).value,
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
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/micro.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/nota.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/juego.png',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
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
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final double imageSize =
        size.width * (isMobile ? 0.35 : (isTablet ? 0.4 : 0.45));

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
            ResponsiveValue<double>(
              context,
              defaultValue: size.height * 0.20,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 160.0),
                Condition.equals(name: TABLET, value: 180.0),
                Condition.equals(name: DESKTOP, value: 200.0),
              ],
            ).value,
        decoration: BoxDecoration(
          color: const Color(0xFFFFC107),
          borderRadius: BorderRadius.circular(
            ResponsiveValue<double>(
              context,
              defaultValue: size.width * 0.03,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 10.0),
                Condition.equals(name: TABLET, value: 15.0),
                Condition.equals(name: DESKTOP, value: 20.0),
              ],
            ).value,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.volume_up,
                color: Colors.black,
                size:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.08,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 25.0),
                        Condition.equals(name: TABLET, value: 30.0),
                        Condition.equals(name: DESKTOP, value: 35.0),
                      ],
                    ).value,
              ),
              onPressed: () {}, // Add audio playback if needed
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
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.09,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 20.0),
                              Condition.equals(name: TABLET, value: 24.0),
                              Condition.equals(name: DESKTOP, value: 28.0),
                            ],
                          ).value,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.height * 0.01,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 5.0),
                            Condition.equals(name: TABLET, value: 8.0),
                            Condition.equals(name: DESKTOP, value: 10.0),
                          ],
                        ).value,
                  ),
                  Center(
                    child: Container(
                      width:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.35,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 120.0),
                              Condition.equals(name: TABLET, value: 150.0),
                              Condition.equals(name: DESKTOP, value: 180.0),
                            ],
                          ).value,
                      height:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.height * 0.06,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 40.0),
                              Condition.equals(name: TABLET, value: 50.0),
                              Condition.equals(name: DESKTOP, value: 60.0),
                            ],
                          ).value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.5,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 20.0),
                              Condition.equals(name: TABLET, value: 25.0),
                              Condition.equals(name: DESKTOP, value: 30.0),
                            ],
                          ).value,
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
                                      ResponsiveValue<double>(
                                        context,
                                        defaultValue: size.height * 0.06,
                                        conditionalValues: const [
                                          Condition.equals(
                                            name: MOBILE,
                                            value: 30.0,
                                          ),
                                          Condition.equals(
                                            name: TABLET,
                                            value: 35.0,
                                          ),
                                          Condition.equals(
                                            name: DESKTOP,
                                            value: 40.0,
                                          ),
                                        ],
                                      ).value,
                                  fit: BoxFit.contain,
                                )
                                : Text(
                                  actionText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize:
                                        ResponsiveValue<double>(
                                          context,
                                          defaultValue: size.width * 0.04,
                                          conditionalValues: const [
                                            Condition.equals(
                                              name: MOBILE,
                                              value: 14.0,
                                            ),
                                            Condition.equals(
                                              name: TABLET,
                                              value: 16.0,
                                            ),
                                            Condition.equals(
                                              name: DESKTOP,
                                              value: 18.0,
                                            ),
                                          ],
                                        ).value,
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
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.width * 0.02,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 5.0),
                    Condition.equals(name: TABLET, value: 8.0),
                    Condition.equals(name: DESKTOP, value: 10.0),
                  ],
                ).value,
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
