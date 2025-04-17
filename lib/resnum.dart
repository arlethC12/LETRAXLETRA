import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 👈 Importa audioplayers
import 'avatar.dart'; // Importación del archivo avatar.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _player = AudioPlayer(); // 👈 Instancia del reproductor

  void _playAudio() async {
    await _player.play(
      AssetSource(
        'audios/telefono.mp3',
      ), // 👈 Asegúrate de tener este archivo en assets
    );
  }

  @override
  void dispose() {
    _player.stop(); // 👈 Detiene el audio al salir de la pantalla
    _player.dispose(); // 👈 Libera recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: LinearProgressIndicator(
            value: 0.97,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
            minHeight: 10,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Image.asset(
                  'assets/num.jpg',
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.8,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.02),
                IconButton(
                  icon: const Icon(
                    Icons.volume_up,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: _playAudio, // 👈 Reproduce el audio
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Ingresa tu número telefónico:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Container(
                  width: screenWidth * 0.85,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixText: '+52 ',
                      prefixIcon: const Icon(Icons.mic),
                      border: const OutlineInputBorder(),
                      labelText: 'Número',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
                ElevatedButton(
                  onPressed: () {
                    _player.stop(); // 👈 Detiene el audio antes de navegar
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
