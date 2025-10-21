import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'base_game.dart';
import 'letter.dart';

class CatchLettersGame extends BaseGame {
  CatchLettersGame({required super.onComplete});

  @override
  _CatchLettersGameState createState() => _CatchLettersGameState();
}

class _CatchLettersGameState extends State<CatchLettersGame>
    with TickerProviderStateMixin {
  final List<String> letters = ['A', 'E', 'I', 'O', 'U'];
  final Random random = Random();
  List<Letter> fallingLetters = [];
  List<Map<String, dynamic>> caughtLetterPositions = [];
  double jaguarX = 0.5;
  int score = 0;
  final int goal = 10;
  late AnimationController _fallController;
  late Timer _spawnTimer;
  bool gameWon = false;
  bool gameOver = false;
  int timeLeft = gameTime;
  Timer? _gameTimer;
  late AnimationController _catchAnimationController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    try {
      _fallController =
          AnimationController(vsync: this, duration: Duration(seconds: 4))
            ..addListener(_checkCatch) // Check collisions on animation update
            ..repeat();
      _catchAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      );
      _bounceController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      )..repeat(reverse: true);
      _spawnTimer = Timer.periodic(
        Duration(milliseconds: 1200),
        (_) => _spawnLetter(),
      );
    } catch (e) {
      print('Initialization error: $e');
    }
    _startTimer();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          gameOver = true;
          _spawnTimer.cancel();
          _fallController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _fallController.dispose();
    _spawnTimer.cancel();
    _gameTimer?.cancel();
    _catchAnimationController.dispose();
    _bounceController.dispose();
    for (var pos in caughtLetterPositions) {
      pos['controller']?.dispose();
    }
    super.dispose();
  }

  void _spawnLetter() {
    if (fallingLetters.length < 6 && !gameOver && !gameWon) {
      setState(() {
        fallingLetters.add(
          Letter(
            letter: letters[random.nextInt(letters.length)],
            x: random.nextDouble(),
            animation: _fallController,
          ),
        );
      });
    }
  }

  void _restart() {
    setState(() {
      fallingLetters = [];
      caughtLetterPositions = [];
      jaguarX = 0.5;
      score = 0;
      gameWon = false;
      gameOver = false;
      timeLeft = gameTime;
    });
    _gameTimer?.cancel();
    _startTimer();
    _fallController.repeat();
    _spawnTimer = Timer.periodic(
      Duration(milliseconds: 1200),
      (_) => _spawnLetter(),
    );
  }

  void _updateJaguarPosition(DragUpdateDetails details) {
    setState(() {
      jaguarX += details.delta.dx / MediaQuery.of(context).size.width;
      jaguarX = jaguarX.clamp(0.0, 1.0);
    });
  }

  void _checkCatch() {
    if (!mounted) return; // Prevent updates if widget is disposed
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final jaguarWidth = 150 / screenWidth;
    final jaguarY = 0.85;
    final letterSize = 32 / screenWidth;

    setState(() {
      fallingLetters.removeWhere((letter) {
        double letterY = letter.animation.value * 0.85;
        double letterX = letter.x;

        bool isCaught =
            letterX > jaguarX - jaguarWidth / 2 - letterSize &&
            letterX < jaguarX + jaguarWidth / 2 + letterSize &&
            letterY >= jaguarY - 0.05 &&
            letterY <= jaguarY + 0.05;

        if (isCaught) {
          print('Caught letter ${letter.letter} at x: $letterX, y: $letterY');
          score++;

          // create controller variable so we can reference and dispose it later
          final AnimationController controller = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 500),
          );

          // add the position + controller to the list
          caughtLetterPositions.add({
            'x': letterX * screenWidth,
            'y': letterY * screenHeight,
            'controller': controller,
          });

          // start the animation and remove/ dispose the controller when done
          controller.forward().then((_) {
            setState(() {
              caughtLetterPositions.removeWhere(
                (p) => p['controller'] == controller,
              );
            });
            controller.dispose();
          });

          _catchAnimationController.forward(from: 0).then((_) {
            _catchAnimationController.reverse();
          });
          if (score >= goal) {
            gameWon = true;
            widget.onComplete();
            _spawnTimer.cancel();
            _fallController.stop();
            _gameTimer?.cancel();
          }
          return true;
        }
        return letterY > 0.9;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver || gameWon) {
      return Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: Text('🕸️ Atrapa las Letras con el Jaguar'),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                gameWon
                    ? '¡Ganaste! Letras atrapadas: $score 🎉'
                    : '¡Tiempo agotado! Letras atrapadas: $score',
                style: TextStyle(
                  fontSize: 24,
                  color: gameWon ? Colors.green : Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: _restart,
                child: Text('Jugar de nuevo'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('🕸️ Atrapa las Letras con el Jaguar'),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$timeLeft s', style: TextStyle(fontSize: 18)),
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: _restart),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green[200]!, Colors.purple[100]!],
              ),
            ),
          ),
          ...fallingLetters.map(
            (letter) => Positioned(
              left: letter.x * MediaQuery.of(context).size.width,
              top:
                  letter.animation.value *
                  0.85 *
                  MediaQuery.of(context).size.height,
              child: AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + sin(_bounceController.value * 2 * pi) * 0.1,
                    child: Opacity(
                      opacity: 1 - letter.animation.value * 0.5,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.4),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          letter.letter,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ...caughtLetterPositions.map(
            (pos) => Positioned(
              left: pos['x'],
              top: pos['y'],
              child: AnimatedBuilder(
                animation: pos['controller'],
                builder: (context, child) {
                  final value = (pos['controller'].value as double);
                  return Opacity(
                    opacity: 1.0 - value,
                    child: Transform.scale(
                      scale: 1.0 + value * 0.5,
                      child: Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: jaguarX * (MediaQuery.of(context).size.width - 150),
            child: GestureDetector(
              onHorizontalDragUpdate: _updateJaguarPosition,
              child: AnimatedBuilder(
                animation: _catchAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + _catchAnimationController.value * 0.2,
                    child: Opacity(
                      opacity: 1 - _catchAnimationController.value * 0.5,
                      child: Image.asset(
                        'assets/atrapaletra.png',
                        width: 150,
                        height: 150,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.pets,
                              size: 150,
                              color: Colors.orange,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: AnimatedBuilder(
              animation: _catchAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + _catchAnimationController.value * 0.1,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Letras atrapadas: $score',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 180,
            right: 20,
            child: Text(
              '¡Desliza al jaguar y atrapa! 🎉',
              style: TextStyle(
                fontSize: 18,
                color: Colors.purple[800],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
