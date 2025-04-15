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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(characterImagePath),
              ),
              SizedBox(width: 10),
              Text(
                username,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildGradeCard(
              context,
              "Primer Grado",
              "COMENZAR",
              "assets/grado1.png",
              false,
              125.0,
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
            SizedBox(height: 12),
            buildGradeCard(
              context,
              "Segundo Grado",
              "",
              "assets/grado2.png",
              true,
              125.0,
              null,
            ),
            SizedBox(height: 12),
            buildGradeCard(
              context,
              "Tercer Grado",
              "",
              "assets/grado3.png",
              true,
              125.0,
              null,
            ),
            SizedBox(height: 12),
            buildGradeCard(
              context,
              "Cuarto Grado",
              "",
              "assets/grado4.png",
              true,
              125.0,
              null,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/boca.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/micro.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nota.jpg', height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/juego.png', height: 35),
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
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Color(0xFFFFC107),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.volume_up, color: Colors.black),
              onPressed: () {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 29,
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
                                horizontal: 20,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/candado.png',
                                height: 40,
                              ),
                            )
                            : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                actionText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                height: imageSize,
                width: imageSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
