import 'package:flutter/material.dart';
import 'pvocales.dart'; // Importando el archivo pvocales.dart

class Niveles extends StatelessWidget {
  final String characterImagePath;
  final String username;

  Niveles({required this.characterImagePath, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        characterImagePath: characterImagePath,
        username: username,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String characterImagePath;
  final String username;

  HomeScreen({required this.characterImagePath, required this.username});

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08), // 8% del alto
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: size.width * 0.05, // Escala según el ancho
                backgroundImage: AssetImage(characterImagePath),
              ),
              SizedBox(width: size.width * 0.03),
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.045, // Escala según el ancho
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.05), // 5% del ancho
          child: Column(
            children: [
              buildGradeCard(
                context,
                "Primer Grado",
                "COMENZAR",
                "assets/grado1.png",
                false,
                size.width * 0.35, // Aumentado de 0.3 a 0.35
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
              SizedBox(height: size.height * 0.02),
              buildGradeCard(
                context,
                "Segundo Grado",
                "",
                "assets/grado2.png",
                true,
                size.width * 0.35, // Aumentado de 0.3 a 0.35
                null,
              ),
              SizedBox(height: size.height * 0.02),
              buildGradeCard(
                context,
                "Tercer Grado",
                "",
                "assets/grado3.png",
                true,
                size.width * 0.35, // Aumentado de 0.3 a 0.35
                null,
              ),
              SizedBox(height: size.height * 0.02),
              buildGradeCard(
                context,
                "Cuarto Grado",
                "",
                "assets/grado4.png",
                true,
                size.width * 0.35, // Aumentado de 0.3 a 0.35
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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/boca.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/micro.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nota.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/juego.png', height: size.height * 0.05),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget buildGradeCard(
    BuildContext context,
    String title,
    String actionText,
    String imagePath,
    bool isLocked,
    double imageSize,
    VoidCallback? onTap,
  ) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        height: size.height * 0.20, // Aumentado de 0.18 a 0.20
        decoration: BoxDecoration(
          color: Color(0xFFFFC107),
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.volume_up,
                color: Colors.black,
                size: size.width * 0.08, // Aumentado de 0.07 a 0.08
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
                      fontSize: size.width * 0.09, // Aumentado de 0.07 a 0.09
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Center(
                    child:
                        isLocked
                            ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.03,
                                ),
                              ),
                              child: Image.asset(
                                'assets/candado.png',
                                height: size.height * 0.06,
                              ),
                            )
                            : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.06,
                                vertical: size.height * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.03,
                                ),
                              ),
                              child: Text(
                                actionText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
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
