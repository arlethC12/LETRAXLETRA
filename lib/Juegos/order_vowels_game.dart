import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'base_game.dart';

class OrderVowelsGame extends BaseGame {
  OrderVowelsGame({required super.onComplete});

  @override
  _OrderVowelsGameState createState() => _OrderVowelsGameState();
}

class _OrderVowelsGameState extends State<OrderVowelsGame>
    with SingleTickerProviderStateMixin {
  late List<String> vowels;
  final List<String> correctOrder = ['A', 'E', 'I', 'O', 'U'];
  late AnimationController _successController;
  late Animation<double> _rotateAnimation;
  bool gameWon = false;
  bool gameOver = false;
  int timeLeft = gameTime;
  Timer? _gameTimer;

  @override
  void initState() {
    super.initState();
    vowels = correctOrder.toList()..shuffle();
    _successController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_successController);
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
    _successController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _restart() {
    setState(() {
      vowels.shuffle();
      gameWon = false;
      gameOver = false;
      timeLeft = gameTime;
    });
    _gameTimer?.cancel();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          title: Text('📝 Ordena las Vocales'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Text(
            '¡Tiempo agotado!',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
      );
    }
    if (gameWon) {
      return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          title: Text('📝 Ordena las Vocales'),
          backgroundColor: Colors.orange,
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
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('📝 Ordena las Vocales'),
        backgroundColor: Colors.orange,
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
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '¡Arrastra para ordenar alfabéticamente! 🔄',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _rotateAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: gameWon ? _rotateAnimation.value : 0,
                    child: ReorderableListView(
                      shrinkWrap: true,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = vowels.removeAt(oldIndex);
                          vowels.insert(newIndex, item);
                        });
                      },
                      children:
                          vowels.asMap().entries.map((entry) {
                            String v = entry.value;
                            return ListTile(
                              key: ValueKey(v),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text(
                                  v,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text('Vocal $v'),
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _checkOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: StadiumBorder(),
                ),
                child: Text(
                  '¡Verificar Orden! ✅',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkOrder() {
    if (listEquals(vowels, correctOrder)) {
      setState(() {
        gameWon = true;
      });
      _successController.forward();
      widget.onComplete();
      _gameTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Perfecto! 🎊'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Casi! Intenta de nuevo 😄'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
