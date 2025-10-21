import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:confetti/confetti.dart'
    as confetti; // Add this package for confetti effect
import 'base_game.dart';

class OrderVowelsGame extends BaseGame {
  OrderVowelsGame({required super.onComplete});

  @override
  _OrderVowelsGameState createState() => _OrderVowelsGameState();
}

class _OrderVowelsGameState extends State<OrderVowelsGame>
    with SingleTickerProviderStateMixin {
  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> consonants = [
    'B',
    'C',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];
  late List<List<String>> grid;
  late List<int> selectedIndices;
  bool gameWon = false;
  bool gameOver = false;
  int timeLeft = gameTime;
  Timer? _gameTimer;
  int currentStep = 0; // Track progress through A, E, I, O, U
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  late confetti.ConfettiController _confettiController;
  String? feedbackMessage; // Store feedback message instantly

  @override
  void initState() {
    super.initState();
    _initializeGrid();
    selectedIndices = [];
    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset(-0.05, 0),
      end: Offset(0.05, 0),
    ).animate(_shakeController);
    _confettiController = confetti.ConfettiController(
      duration: Duration(seconds: 1),
    );
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

  void _initializeGrid() {
    grid = List.generate(5, (i) => List.filled(5, ''));
    // Place each vowel at least once
    List<int> availableIndices = List.generate(25, (i) => i)..shuffle();
    for (int i = 0; i < 5; i++) {
      int index = availableIndices.removeAt(0);
      int row = index ~/ 5;
      int col = index % 5;
      grid[row][col] = vowels[i];
    }
    // Fill remaining cells with random consonants
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if (grid[i][j].isEmpty) {
          grid[i][j] = consonants[Random().nextInt(consonants.length)];
        }
      }
    }
    // Optional shuffle within rows to mix further
    for (var row in grid) row.shuffle();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _confettiController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _restart() {
    setState(() {
      _initializeGrid();
      selectedIndices.clear();
      currentStep = 0;
      gameWon = false;
      gameOver = false;
      timeLeft = gameTime;
      feedbackMessage = null; // Clear feedback on restart
    });
    _gameTimer?.cancel();
    _startTimer();
  }

  void _tapCell(int row, int col) {
    int index = row * 5 + col;
    if (selectedIndices.contains(index)) return; // Prevent re-selection

    String letter = grid[row][col];
    if (vowels.contains(letter) && letter == vowels[currentStep]) {
      setState(() {
        selectedIndices.add(index);
        currentStep++;
        feedbackMessage = '¡Genial! $letter ✨';
        if (currentStep == vowels.length) {
          gameWon = true;
          _confettiController.play();
          _gameTimer?.cancel();
          widget.onComplete();
        }
      });
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
      setState(() {
        feedbackMessage = '¡Oops! Busca ${vowels[currentStep]}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        backgroundColor: Color(0xFFFFF8DC), // Light jungle yellow
        appBar: AppBar(
          title: Text('📝 Ordena las Vocales'),
          backgroundColor: Color(0xFF8B4513), // Saddle Brown
        ),
        body: Center(
          child: Text(
            '¡Tiempo agotado! 🌴',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFFDAA520),
            ), // Goldenrod
          ),
        ),
      );
    }
    if (gameWon) {
      return Scaffold(
        backgroundColor: Color(0xFFFFF8DC), // Light jungle yellow
        appBar: AppBar(
          title: Text('📝 Ordena las Vocales'),
          backgroundColor: Color(0xFF8B4513), // Saddle Brown
        ),
        body: Stack(
          children: [
            Center(
              child: Text(
                '¡Victoria Jungla! 🌟',
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFFDAA520),
                ), // Goldenrod
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: confetti.ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: confetti.BlastDirectionality.explosive,
                colors: [Colors.yellow, Colors.green, Colors.orange],
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color(0xFFFFF8DC), // Light jungle yellow
      appBar: AppBar(
        title: Text('📝 Ordena las Vocales'),
        backgroundColor: Color(0xFF8B4513), // Saddle Brown
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$timeLeft s',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _restart,
            color: Colors.white,
          ),
        ],
      ),
      body: SlideTransition(
        position: _shakeAnimation,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '¡Explora la jungla y toca las vocales en orden: ${vowels.join(' → ')}! 🐾',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513), // Saddle Brown
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/jungle.jpg',
                    ), // Ensure this asset exists
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Center(
                  // Center the grid within the container
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ), // Increased horizontal padding to center
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing:
                          10, // Increased spacing for better separation
                      mainAxisSpacing:
                          10, // Increased spacing for better separation
                      childAspectRatio: 1.0, // Ensure square cells
                    ),
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      int row = index ~/ 5;
                      int col = index % 5;
                      bool isSelected = selectedIndices.contains(index);
                      return GestureDetector(
                        onTap: () => _tapCell(row, col),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Color(0xFF98FB98)
                                    : Color(
                                      0xFFFFE4B5,
                                    ), // Pale green or moccasin
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFF8B4513),
                              width: 2,
                            ), // Saddle Brown border
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            // Ensure text is centered within the cell
                            child: Padding(
                              padding: EdgeInsets.all(
                                8,
                              ), // Add padding to center text
                              child: Text(
                                grid[row][col],
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected
                                          ? Color(0xFF228B22)
                                          : Color(
                                            0xFF8B4513,
                                          ), // Forest green or Saddle Brown
                                ),
                                textAlign:
                                    TextAlign.center, // Explicitly center text
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (feedbackMessage != null) // Show feedback instantly
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  feedbackMessage!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        feedbackMessage!.contains('Genial')
                            ? Colors.green
                            : Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Progreso: ${selectedIndices.length}/5',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
