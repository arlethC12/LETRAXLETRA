import 'package:flutter/material.dart';
import 'dart:math';
import 'nivellogrado.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  runApp(BurbujaAScreen());
}

class BurbujaAScreen extends StatelessWidget {
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
  int poppedAs = 0;
  int totalAs = 0;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // Letters with 'a's included
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
    // Positions (normalized between 0 and 1)
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

    // Create bubbles and count 'a's
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
      if (letters[i].toLowerCase() == 'a') {
        totalAs++;
      }
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void popBubble(int index) {
    if (bubbles[index].letter.toLowerCase() == 'a' &&
        bubbles[index].isVisible) {
      setState(() {
        bubbles[index].isVisible = false;
        poppedAs++;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Progress bar and close button
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: totalAs == 0 ? 0 : poppedAs / totalAs,
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
            // Instruction text with speaker icon (icon before text)
            Positioned(
              top: 60,
              left: 20,
              child: Row(
                children: [
                  Icon(Icons.volume_up, color: Colors.black, size: 24),
                  SizedBox(width: 8), // Space between icon and text
                  Text(
                    'Explota las burbujas de la letra a',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Bubbles
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
                          key: bubbles[i].key,
                          isPopping:
                              bubbles[i].letter.toLowerCase() == 'a' &&
                              !bubbles[i].isVisible,
                        ),
                      ),
                    );
                  },
                ),
            // Right arrow button
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NivelOgradoScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.orange,
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final bool isPopping;

  BubbleWidget({
    required this.letter,
    required this.borderColor,
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
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: widget.borderColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: Offset(-2, -2),
                  ),
                ],
                gradient: RadialGradient(
                  colors: [Colors.white, widget.borderColor.withOpacity(0.1)],
                  center: Alignment(-0.3, -0.3),
                  radius: 0.8,
                ),
              ),
              child: Center(
                child: Text(
                  widget.letter,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
