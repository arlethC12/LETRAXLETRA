import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; // For timers in animations

void main() {
  runApp(
    Juego(
      characterImagePath: 'assets/ajaguar.jpg', // Default for standalone
      username: 'Jugador',
      token: 'default_token',
    ),
  );
}

class Juego extends StatelessWidget {
  final String characterImagePath;
  final String username;
  final String token;

  const Juego({
    Key? key,
    required this.characterImagePath,
    required this.username,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aprendamos Jugando',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Comic Sans MS', // Fun font for kids
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: MiniGamesSection(
        characterImagePath: characterImagePath,
        username: username,
        token: token,
      ),
    );
  }
}

// Main section screen with mini-games grid
class MiniGamesSection extends StatefulWidget {
  final String characterImagePath;
  final String username;
  final String token;

  const MiniGamesSection({
    Key? key,
    required this.characterImagePath,
    required this.username,
    required this.token,
  }) : super(key: key);

  @override
  _MiniGamesSectionState createState() => _MiniGamesSectionState();
}

class _MiniGamesSectionState extends State<MiniGamesSection>
    with SingleTickerProviderStateMixin {
  int rewards = 0;
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addReward() {
    setState(() {
      rewards += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.star, color: Colors.yellow),
            SizedBox(width: 8),
            Text('¡Ganaste una estrella! Total: $rewards ✨'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Softer, kid-friendly background
      appBar: AppBar(
        title: Text('¡Hola, ${widget.username}! 🎮 Aprendamos Jugando'),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 24),
                      SizedBox(width: 4),
                      Text(
                        '$rewards',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background decoration for fun
          Positioned.fill(
            child: Image.asset(
              'assets/ajaguar.jpg', // Assume you have a fun jungle image; replace with your asset
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(0.3),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16.0),
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildAnimatedCard(
                title: '🅰️ Deletrea las Vocales',
                color: Colors.pinkAccent,
                icon: Icons.keyboard,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SpellVowelsGame(onComplete: addReward),
                      ),
                    ),
              ),
              _buildAnimatedCard(
                title: '🔗 Une las Vocales',
                color: Colors.green,
                icon: Icons.link,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ConnectVowelsGame(onComplete: addReward),
                      ),
                    ),
              ),
              _buildAnimatedCard(
                title: '📝 Ordena las Vocales',
                color: Colors.orange,
                icon: Icons.sort,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => OrderVowelsGame(onComplete: addReward),
                      ),
                    ),
              ),
              _buildAnimatedCard(
                title: '🕸️ Atrapa las Letras',
                color: Colors.purple,
                icon: Icons.touch_app,
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                CatchLettersGame(onComplete: addReward),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: color.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable game base with enhanced visuals
abstract class BaseGame extends StatefulWidget {
  final VoidCallback onComplete;
  BaseGame({required this.onComplete});
}

// Game 1: Deletrea las vocales - Enhanced with animations and fun feedback
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

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(_confettiController);
    _newQuestion();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _newQuestion() {
    setState(() {
      currentVowel = vowels[Random().nextInt(vowels.length)];
      userInput = '';
      correct = false;
    });
  }

  void _checkAnswer() {
    if (userInput.toUpperCase() == currentVowel) {
      setState(() {
        correct = true;
      });
      _confettiController.forward().then((_) => _confettiController.reverse());
      widget.onComplete();
      Future.delayed(Duration(seconds: 2), _newQuestion);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Inténtalo de nuevo! 😊'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('🅰️ Deletrea las Vocales'),
        backgroundColor: Colors.pinkAccent,
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
                    child: Text(
                      'Deletrea esta vocal: $currentVowel 🎯',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                      textAlign: TextAlign.center,
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
                onChanged: (value) => setState(() => userInput = value),
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
          ],
        ),
      ),
    );
  }
}

// Game 2: Une las vocales - Enhanced with colors and shake animation on match
class ConnectVowelsGame extends BaseGame {
  ConnectVowelsGame({required super.onComplete});

  @override
  _ConnectVowelsGameState createState() => _ConnectVowelsGameState();
}

class _ConnectVowelsGameState extends State<ConnectVowelsGame>
    with SingleTickerProviderStateMixin {
  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> images = ['🍎', '🐘', '🍦', '🍊', '🦄'];
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];
  String? selectedVowel;
  String? selectedImage;
  int matches = 0;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset(-0.05, 0),
      end: Offset(0.05, 0),
    ).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('🔗 Une las Vocales'),
        backgroundColor: Colors.green,
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        vowels.asMap().entries.map((entry) {
                          int index = entry.key;
                          String v = entry.value;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        images.asMap().entries.map((entry) {
                          int index = entry.key;
                          String img = entry.value;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedImage = img);
                              _checkMatch();
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
                '¡Todas unidas! 🌟',
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

  void _checkMatch() {
    if (selectedVowel != null && selectedImage != null) {
      int vowelIndex = vowels.indexOf(selectedVowel!);
      if (images[vowelIndex] == selectedImage) {
        _shakeController.forward().then((_) => _shakeController.reverse());
        setState(() {
          matches++;
          if (matches == 5) widget.onComplete();
        });
      }
      selectedVowel = null;
      selectedImage = null;
    }
  }
}

// Game 3: Ordena las vocales - Enhanced with drag animations and confetti
class OrderVowelsGame extends BaseGame {
  OrderVowelsGame({required super.onComplete});

  @override
  _OrderVowelsGameState createState() => _OrderVowelsGameState();
}

class _OrderVowelsGameState extends State<OrderVowelsGame>
    with SingleTickerProviderStateMixin {
  List<String> vowels = ['U', 'A', 'O', 'I', 'E']; // Shuffled
  final List<String> correctOrder = ['A', 'E', 'I', 'O', 'U'];
  late AnimationController _successController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_successController);
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('📝 Ordena las Vocales'),
        backgroundColor: Colors.orange,
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
                    angle: correct ? _rotateAnimation.value : 0,
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

  bool get correct => listEquals(vowels, correctOrder);

  void _checkOrder() {
    if (correct) {
      _successController.forward();
      widget.onComplete();
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

// New Game 4: Atrapa las Letras - Jaguar catching falling letters with a net
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
  double jaguarX = 0.5; // Jaguar position (0 to 1 normalized)
  int score = 0;
  late AnimationController _fallController;
  late Timer _spawnTimer;

  @override
  void initState() {
    super.initState();
    _fallController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
    _spawnTimer = Timer.periodic(
      Duration(milliseconds: 1500),
      (_) => _spawnLetter(),
    );
    _fallController.addListener(() {
      setState(() {}); // Update positions
    });
  }

  @override
  void dispose() {
    _fallController.dispose();
    _spawnTimer.cancel();
    super.dispose();
  }

  void _spawnLetter() {
    if (fallingLetters.length < 5) {
      // Limit falling letters
      fallingLetters.add(
        Letter(
          letter: letters[random.nextInt(letters.length)],
          x: random.nextDouble(),
          animation: _fallController,
        ),
      );
    }
  }

  void _updateJaguarPosition(DragUpdateDetails details) {
    setState(() {
      jaguarX += details.delta.dx / MediaQuery.of(context).size.width;
      jaguarX = jaguarX.clamp(0.0, 1.0);
    });
  }

  void _checkCatch() {
    fallingLetters.removeWhere((letter) {
      // Simple collision: if letter x is close to jaguar x and y is at bottom
      if (letter.x > jaguarX - 0.1 &&
          letter.x < jaguarX + 0.1 &&
          letter.animation.value > 0.9) {
        setState(() => score++);
        if (score >= 10) widget.onComplete(); // Win after 10 catches
        return true;
      }
      return letter.animation.value > 1.0; // Remove if fallen off screen
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkCatch(); // Check collisions every build
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('🕸️ Atrapa las Letras con el Jaguar'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          // Falling letters
          ...fallingLetters.map(
            (letter) => Positioned(
              left: letter.x * MediaQuery.of(context).size.width,
              top: letter.animation.value * MediaQuery.of(context).size.height,
              child: AnimatedBuilder(
                animation: letter.animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale:
                        1 - letter.animation.value * 0.5, // Shrink as falling
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 5),
                        ],
                      ),
                      child: Text(
                        letter.letter,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Jaguar with net at bottom
          Positioned(
            bottom: 50,
            left:
                jaguarX *
                (MediaQuery.of(context).size.width - 80), // 80 is jaguar width
            child: GestureDetector(
              onHorizontalDragUpdate: _updateJaguarPosition,
              child: Image.asset(
                'assets/ajaguar.jpg', // Assume you have a jaguar with net asset
                width: 80,
                height: 80,
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      Icons.pets,
                      size: 80,
                      color: Colors.orange,
                    ), // Fallback
              ),
            ),
          ),
          // Score
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
          // Instructions
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

class Letter {
  final String letter;
  final double x;
  final Animation<double> animation;

  Letter({required this.letter, required this.x, required this.animation});
}

// Helper extension for list equality
extension ListEquality on List<String> {
  bool listEquals(List<String> other) =>
      length == other.length && zip(other).every((e) => e.$1 == e.$2);
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<(T, T)> zip(Iterable<T> other) =>
      map((t) => (t, other.elementAt(index)));
}

int get index => 0; // Placeholder for zip; adjust if needed
