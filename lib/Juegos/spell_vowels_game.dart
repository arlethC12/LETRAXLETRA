import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'base_game.dart';

class SpellVowelsGame extends BaseGame {
  SpellVowelsGame({required super.onComplete});

  @override
  _SpellVowelsGameState createState() => _SpellVowelsGameState();
}

class _SpellVowelsGameState extends State<SpellVowelsGame>
    with SingleTickerProviderStateMixin {
  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  String currentVowel = '';
  String userInput = '';
  bool correct = false;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late TextEditingController _inputController;
  int correctCount = 0;
  final int goal = 5;
  bool gameWon = false;
  bool gameOver = false;
  int timeLeft = gameTime;
  Timer? _gameTimer;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _confettiController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(_confettiController);
    _newQuestion();
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
    _confettiController.dispose();
    _inputController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _newQuestion() {
    setState(() {
      currentVowel = vowels[Random().nextInt(vowels.length)];
      userInput = '';
      correct = false;
      _inputController.clear();
    });
  }

  void _checkAnswer() {
    if (userInput.toUpperCase() == currentVowel) {
      setState(() {
        correct = true;
        correctCount++;
        if (correctCount >= goal) {
          gameWon = true;
          _gameTimer?.cancel();
          widget.onComplete();
        }
      });
      _inputController.clear();
      userInput = '';
      _confettiController.forward().then((_) {
        _confettiController.reverse();
        if (!gameWon) {
          _newQuestion();
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
  }

  void _restart() {
    setState(() {
      correctCount = 0;
      gameWon = false;
      gameOver = false;
      timeLeft = gameTime;
      correct = false;
      userInput = '';
      _inputController.clear();
    });
    _gameTimer?.cancel();
    _startTimer();
    _newQuestion();
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          title: Text('🅰️ Deletrea las Vocales'),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
          child: Text(
            '¡Tiempo agotado! Correctas: $correctCount',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
      );
    }
    if (gameWon) {
      return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          title: Text('🅰️ Deletrea las Vocales'),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
          child: Text(
            '¡Juego completado! 🎉',
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('🅰️ Deletrea las Vocales'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$timeLeft s', style: TextStyle(fontSize: 18)),
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: _restart),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: correct ? _scaleAnimation.value : 1.0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Deletrea esta vocal: 🎯',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.pink),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentVowel,
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.pink,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                vowelEmojis[currentVowel] ?? '',
                                style: TextStyle(fontSize: 32),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
                ],
              ),
              child: TextField(
                controller: _inputController,
                onChanged: (value) => userInput = value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.pink),
                decoration: InputDecoration(
                  hintText: 'Escribe la vocal aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.edit, color: Colors.pink),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: StadiumBorder(),
              ),
              child: Text('¡Verificar! 🚀', style: TextStyle(fontSize: 18)),
            ),
            if (correct)
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '¡Excelente! 🎉',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Text('Progreso: $correctCount / $goal'),
          ],
        ),
      ),
    );
  }
}
