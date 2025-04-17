import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'resga.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PantallaInicio(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State {
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: size.width * 0.09,
            ),
            onPressed: () async {
              await player.stop(); // Detener el audio antes de retroceder
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                minHeight: size.height * 0.015,
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Center(
                  child: Image.asset(
                    'assets/nombre.jpg',
                    width: size.width * 0.8,
                    height: size.height * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.black,
                    size: size.width * 0.08,
                  ),
                  onPressed: () async {
                    try {
                      await player.play(AssetSource('audios/dinombre.mp3'));
                    } catch (e) {
                      print("Error al reproducir audio: $e");
                    }
                  },
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  "¿Cuál es tu nombre?",
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Tu nombre es...",
                    suffixIcon: Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: size.width * 0.06,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.03),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                      horizontal: size.width * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.03),
                    ),
                  ),
                  onPressed: () {
                    _navigateToScreen(context, ResponsiveScreen());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Continuar",
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: size.width * 0.06,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
