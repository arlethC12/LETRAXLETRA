import 'package:flutter/material.dart';
import 'dart:math';
import 'package:letra_x_letra/vocalI/Nivel3.dart';
import 'package:letra_x_letra/vocalI/palabra.dart';
import 'package:audioplayers/audioplayers.dart'; // Importa audioplayers

void main() {
  runApp(BurbujaIScreen());
}

class BurbujaIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BubbleScreen(), debugShowCheckedModeBanner: false);
  }
}

class BubbleScreen extends StatefulWidget {
  @override
  _BubbleScreenState createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen>
    with SingleTickerProviderStateMixin {
  List<Bubble> bubbles = [];
  int poppedIs = 0;
  int totalIs = 0;
  late AnimationController _floatController;
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Inicializa el reproductor de audio

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    List<String> letters = [
      'a',
      'i',
      'e',
      'a',
      'u',
      'a',
      'e',
      'o',
      'u',
      'a',
      'e',
      'i',
      'u',
      'o',
      'i',
      'o',
      'u',
    ];
    List<Offset> positions = [
      Offset(0.3, 0.1),
      Offset(0.7, 0.1),
      Offset(0.5, 0.15),
      Offset(0.2, 0.25),
      Offset(0.4, 0.25),
      Offset(0.6, 0.25),
      Offset(0.3, 0.35),
      Offset(0.5, 0.35),
      Offset(0.7, 0.35),
      Offset(0.2, 0.45),
      Offset(0.4, 0.45),
      Offset(0.6, 0.45),
      Offset(0.3, 0.55),
      Offset(0.5, 0.55),
      Offset(0.7, 0.55),
      Offset(0.4, 0.65),
      Offset(0.6, 0.65),
    ];

    for (int i = 0; i < letters.length; i++) {
      bubbles.add(
        Bubble(
          letter: letters[i],
          position: positions[i],
          isVisible: true,
          key: UniqueKey(),
          phase: Random().nextDouble() * 2 * pi,
        ),
      );
      if (letters[i].toLowerCase() == 'i') {
        totalIs++;
      }
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _audioPlayer.dispose(); // Libera el reproductor de audio
    super.dispose();
  }

  void popBubble(int index) {
    if (bubbles[index].letter.toLowerCase() == 'i' &&
        bubbles[index].isVisible) {
      setState(() {
        bubbles[index].isVisible = false;
        poppedIs++;
      });
    }
  }

  Color getBorderColor(String letter) {
    switch (letter.toLowerCase()) {
      case 'a':
        return Colors.red;
      case 'i':
        return Colors.blue;
      case 'o':
        return Colors.purple;
      case 'e':
        return Colors.green;
      case 'u':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Color getTextColor(String letter) {
    switch (letter.toLowerCase()) {
      case 'a':
        return Colors.red.shade700;
      case 'i':
        return Colors.blue.shade700;
      case 'o':
        return Colors.purple.shade700;
      case 'e':
        return Colors.green.shade700;
      case 'u':
        return Colors.orange.shade700;
      default:
        return Colors.black;
    }
  }

  // Función para reproducir el audio
  Future<void> playSound() async {
    await _audioPlayer.play(
      AssetSource('audios/VocalI/Explota las burbujas.m4a'),
    ); // Reproduce el audio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PalabraScreen(),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: totalIs == 0 ? 0 : poppedIs / totalIs,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color.fromARGB(255, 255, 186, 59),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.black, size: 24),
                    onPressed:
                        playSound, // Llama a la función para reproducir el audio
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Explota las burbujas de la letra i',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < bubbles.length; i++)
              if (bubbles[i].isVisible)
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    final double offset =
                        sin(
                          _floatController.value * 2 * pi + bubbles[i].phase,
                        ) *
                        10;
                    return Positioned(
                      left:
                          bubbles[i].position.dx *
                          MediaQuery.of(context).size.width,
                      top:
                          bubbles[i].position.dy *
                              MediaQuery.of(context).size.height +
                          80 +
                          offset,
                      child: GestureDetector(
                        onTap: () => popBubble(i),
                        child: BubbleWidget(
                          letter: bubbles[i].letter,
                          borderColor: getBorderColor(bubbles[i].letter),
                          textColor: getTextColor(bubbles[i].letter),
                          key: bubbles[i].key,
                          isPopping:
                              bubbles[i].letter.toLowerCase() == 'i' &&
                              !bubbles[i].isVisible,
                        ),
                      ),
                    );
                  },
                ),
            if (poppedIs == totalIs)
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Nivel3Screen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.orange,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Clases Bubble y BubbleWidget permanecen sin cambios
class Bubble {
  final String letter;
  final Offset position;
  bool isVisible;
  final Key key;
  final double phase;

  Bubble({
    required this.letter,
    required this.position,
    required this.isVisible,
    required this.key,
    required this.phase,
  });
}

class BubbleWidget extends StatefulWidget {
  final String letter;
  final Color borderColor;
  final Color textColor;
  final bool isPopping;

  BubbleWidget({
    required this.letter,
    required this.borderColor,
    required this.textColor,
    required this.isPopping,
    required Key key,
  }) : super(key: key);

  @override
  _BubbleWidgetState createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.2,
    ).animate(CurvedAnimation(parent: _popController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _popController, curve: Curves.easeOut));

    if (widget.isPopping) {
      _popController.forward();
    }
  }

  @override
  void didUpdateWidget(BubbleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPopping && !oldWidget.isPopping) {
      _popController.forward();
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _popController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.blue.withOpacity(0.3),
                    Colors.purple.withOpacity(0.3),
                  ],
                  stops: [0.0, 0.5, 1.0],
                  center: Alignment(-0.5, -0.5),
                  radius: 1.2,
                ),
                border: Border.all(
                  color: widget.borderColor.withOpacity(0.7),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(3, 3),
                  ),
                  if (widget.letter.toLowerCase() == 'i')
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.letter,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
