import 'dart:math';
import 'package:flutter/material.dart';
import 'spell_vowels_game.dart';
import 'connect_vowels_game.dart';
import 'order_vowels_game.dart';
import 'catch_letters_game.dart';

void main() {
  runApp(
    Juego(
      characterImagePath: 'assets/hojas.png',
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
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Comic Sans MS'),
      debugShowCheckedModeBanner: false,
      home: MiniGamesSection(
        characterImagePath: characterImagePath,
        username: username,
        token: token,
      ),
    );
  }
}

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
      backgroundColor: Colors.lightBlue[50],
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
          // Multiple small leaf images scattered as background
          for (int i = 0; i < 20; i++) // Adjust number for density
            Positioned(
              left: Random().nextDouble() * MediaQuery.of(context).size.width,
              top: Random().nextDouble() * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  widget.characterImagePath,
                  width: 50, // Small size for leaf effect
                  height: 50,
                  fit: BoxFit.cover,
                ),
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
