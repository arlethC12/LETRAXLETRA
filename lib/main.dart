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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  void _navigateToScreen(BuildContext context, Widget screen) async {
    await player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double fontScaleFactor = screenSize.width / 400;
    final double spacingScaleFactor = screenSize.height / 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30 * spacingScaleFactor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'LETRA',
                      style: TextStyle(
                        fontSize: 40 * fontScaleFactor,
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: screenSize.height * 0.3,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Image.asset(
                      'assets/registro.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 30 * spacingScaleFactor),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.black,
                    size: 36 * fontScaleFactor,
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
                    _navigateToScreen(context, PantallaInicio());
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
                    _navigateToScreen(context, MyHomePage());
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
                SizedBox(height: 30 * spacingScaleFactor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
