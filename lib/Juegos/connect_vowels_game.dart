import 'package:flutter/material.dart';
import 'dart:async';
import 'base_game.dart';

class ConnectVowelsGame extends BaseGame {
  ConnectVowelsGame({required super.onComplete});

  @override
  _ConnectVowelsGameState createState() => _ConnectVowelsGameState();
}

class _ConnectVowelsGameState extends State<ConnectVowelsGame>
    with SingleTickerProviderStateMixin {
  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  // Updated initial images to match vowels with examples
  final List<String> initialImages = ['🌳', '🐘', '⛪', '👂', '🦄'];
  // Updated alternative images with different representations
  final List<String> alternativeImages = ['🌳', '🐘', '⛪', '👂', '🦄'];
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];
  late List<int> imageIndices;
  String? selectedVowel;
  String? selectedImage;
  int matches = 0;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  bool gameOver = false;
  bool gameWon = false;
  int timeLeft = gameTime;
  Timer? _gameTimer;
  late List<bool> isMatched; // Track matched items

  @override
  void initState() {
    super.initState();
    imageIndices = List.generate(5, (i) => i)..shuffle();
    isMatched = List.filled(5, false); // Initialize match tracking
    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset(-0.05, 0),
      end: Offset(0.05, 0),
    ).animate(_shakeController);
    _startTimer();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          gameOver = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _restart() {
    setState(() {
      imageIndices = List.generate(5, (i) => i)..shuffle();
      isMatched = List.filled(5, false);
      selectedVowel = null;
      selectedImage = null;
      matches = 0;
      gameOver = false;
      gameWon = false;
      timeLeft = gameTime;
    });
    _gameTimer?.cancel();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('🔗 Une las Vocales'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text(
            '¡Tiempo agotado! Matches: $matches',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
      );
    }
    if (gameWon) {
      return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('🔗 Une las Vocales'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text(
            '¡Juego terminado! Todas unidas 🌟',
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('🔗 Une las Vocales'),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$timeLeft s', style: TextStyle(fontSize: 18)),
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: _restart),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '¡Une la vocal con su amigo! 🐾',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
          Expanded(
            child: SlideTransition(
              position: _shakeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children:
                        vowels.asMap().entries.map((entry) {
                          int index = entry.key;
                          String v = entry.value;
                          if (isMatched[index])
                            return SizedBox.shrink(); // Hide if matched
                          return GestureDetector(
                            onTap: () => setState(() => selectedVowel = v),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color:
                                    selectedVowel == v
                                        ? Colors.blue
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: colors[index],
                                  width: 3,
                                ),
                              ),
                              child: Text(
                                v,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: colors[index],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 40),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children:
                        imageIndices.asMap().entries.map((entry) {
                          int index = entry.key;
                          if (isMatched[index])
                            return SizedBox.shrink(); // Hide if matched
                          String img = initialImages[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedImage = img);
                              _checkMatch(index);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color:
                                    selectedImage == img
                                        ? Colors.blue
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: colors[index],
                                  width: 3,
                                ),
                              ),
                              child: Text(img, style: TextStyle(fontSize: 32)),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          if (matches == 5)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Text(
                '¡Juego terminado! Todas unidas! 🌟',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          LinearProgressIndicator(
            value: matches / 5,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    );
  }

  void _checkMatch(int imageIndex) {
    if (selectedVowel != null && selectedImage != null) {
      int vowelIndex = vowels.indexOf(selectedVowel!);
      if (initialImages[vowelIndex] == selectedImage) {
        _shakeController.forward().then((_) => _shakeController.reverse());
        setState(() {
          matches++;
          isMatched[vowelIndex] = true; // Mark as matched
          imageIndices[imageIndex] = -1; // Temporarily mark as used
          if (matches == 5) {
            gameWon = true;
            _gameTimer?.cancel();
            widget.onComplete();
          } else {
            // Replace with new figure
            imageIndices[imageIndex] = vowelIndex; // Reuse index with new image
            initialImages[vowelIndex] = alternativeImages[vowelIndex];
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Inténtalo de nuevo! 😊'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      setState(() {
        selectedVowel = null;
        selectedImage = null;
      });
    }
  }
}
