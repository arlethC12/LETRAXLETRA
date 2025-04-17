import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'registro.dart';
import 'resnum.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    // Define a scaling factor for font sizes and other elements
    final double fontScaleFactor =
        screenSize.width / 400; // Base width of 400 for scaling
    final double spacingScaleFactor =
        screenSize.height / 800; // Base height of 800 for spacing

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'LETRA',
                  style: TextStyle(
                    fontSize: 40 * fontScaleFactor, // Responsive font size
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10 * fontScaleFactor),
                Text(
                  'X',
                  style: TextStyle(
                    fontSize: 46 * fontScaleFactor,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10 * fontScaleFactor),
                Text(
                  'LETRA',
                  style: TextStyle(
                    fontSize: 40 * fontScaleFactor,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            SizedBox(height: 30 * spacingScaleFactor),
            // Use FractionallySizedBox to make the image responsive
            FractionallySizedBox(
              widthFactor: 0.7, // 70% of screen width
              child: Image.asset(
                'assets/registro.jpg',
                fit: BoxFit.contain, // Ensure the image scales properly
              ),
            ),
            SizedBox(height: 30 * spacingScaleFactor),
            IconButton(
              icon: Icon(
                Icons.volume_up,
                color: Colors.black,
                size: 36 * fontScaleFactor, // Responsive icon size
              ),
              onPressed: () async {
                try {
                  await player.play(AssetSource('audios/Regis.mp3'));
                } catch (e) {
                  print("Error al reproducir el audio: $e");
                }
              },
            ),
            SizedBox(height: 20 * spacingScaleFactor),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaInicio()),
                );
              },
              label: Text(
                'Registrate',
                style: TextStyle(
                  fontSize: 22 * fontScaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE23B),
                padding: EdgeInsets.symmetric(
                  horizontal: 60 * fontScaleFactor,
                  vertical: 20 * spacingScaleFactor,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 24 * fontScaleFactor,
              ),
            ),
            SizedBox(height: 20 * spacingScaleFactor),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              label: Text(
                'Inicia Sesíon',
                style: TextStyle(
                  fontSize: 22 * fontScaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE23B),
                padding: EdgeInsets.symmetric(
                  horizontal: 50 * fontScaleFactor,
                  vertical: 20 * spacingScaleFactor,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 24 * fontScaleFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
