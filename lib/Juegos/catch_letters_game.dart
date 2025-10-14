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

  @override
  void initState() {
    super.initState();
    try {
      _fallController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3),
      )..repeat();
      _catchAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      );
      _spawnTimer = Timer.periodic(
        Duration(milliseconds: 1500),
        (_) => _spawnLetter(),
      );
      _fallController.addListener(() {
        if (mounted) setState(() {});
      });
    } catch (e) {
      print('Initialization error: $e');
    }
    _startTimer();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          timeLeft--;
          if (timeLeft <= 0) {
            timer.cancel();
            gameOver = true;
            _spawnTimer.cancel();
            _fallController.stop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fallController.dispose();
    _spawnTimer.cancel();
    _gameTimer?.cancel();
    _catchAnimationController.dispose();
    super.dispose();
  }

  void _spawnLetter() {
    if (fallingLetters.length < 5 && !gameOver && !gameWon && mounted) {
      fallingLetters.add(
        Letter(
          letter: letters[random.nextInt(letters.length)],
          x: random.nextDouble(),
          animation: _fallController,
        ),
      );
    }
  }

  void _restart() {
    if (mounted) {
      setState(() {
        fallingLetters = [];
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
        Duration(milliseconds: 1500),
        (_) => _spawnLetter(),
      );
    }
  }

  void _updateJaguarPosition(DragUpdateDetails details) {
    if (mounted) {
      setState(() {
        jaguarX += details.delta.dx / MediaQuery.of(context).size.width;
        jaguarX = jaguarX.clamp(0.0, 1.0);
      });
    }
  }

  void _checkCatch() {
    if (mounted) {
      fallingLetters.removeWhere((letter) {
        if (letter.x > jaguarX - 0.1 &&
            letter.x < jaguarX + 0.1 &&
            letter.animation.value > 0.9) {
          _catchAnimationController.forward(from: 0).then((_) {
            if (mounted) _catchAnimationController.reverse();
          });
          setState(() => score++);
          if (score >= goal) {
            gameWon = true;
            widget.onComplete();
            _spawnTimer.cancel();
            _fallController.stop();
            _gameTimer?.cancel();
          }
          return true;
        }
        return letter.animation.value > 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkCatch();
    if (gameOver || gameWon) {
      return Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: Text('🕸️ Atrapa las Letras con el Jaguar'),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Text(
            gameWon
                ? '¡Ganaste! Puntos: $score 🎉'
                : '¡Tiempo agotado! Puntos: $score',
            style: TextStyle(
              fontSize: 24,
              color: gameWon ? Colors.green : Colors.red,
            ),
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
          ...fallingLetters.map(
            (letter) => Positioned(
              left: letter.x * MediaQuery.of(context).size.width,
              top: letter.animation.value * MediaQuery.of(context).size.height,
              child: AnimatedBuilder(
                animation: letter.animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: 1 - letter.animation.value * 0.5,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
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
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 50,
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
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Puntos: $score 🐆',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            right: 20,
            child: Text(
              '¡Arrastra al jaguar para atrapar! 🎣',
              style: TextStyle(fontSize: 16, color: Colors.purple[800]),
            ),
          ),
        ],
      ),
    );
  }
}
