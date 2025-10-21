import 'dart:math';
import 'package:flutter/material.dart';
import 'package:letra_x_letra/niveles.dart';
import 'spell_vowels_game.dart';
import 'connect_vowels_game.dart';
import 'order_vowels_game.dart';
import 'catch_letters_game.dart';

void main() {
  runApp(
    Juego(
      characterImagePath: 'assets/tiger.png',
      username: 'Arleth',
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
        primarySwatch: Colors.green,
        fontFamily: 'Comic Sans MS',
      ),
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
        backgroundColor: Colors.green[700],
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/jungle.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Add jaguar paw print accents as a background effect
            for (int i = 0; i < 10; i++)
              Positioned(
                left: Random().nextDouble() * size.width,
                top: Random().nextDouble() * size.height * 0.7,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/huellas.png', // Ensure this asset exists
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(widget.characterImagePath),
                        radius: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.username,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Color.fromARGB(255, 189, 162, 139),
                  elevation: 0,
                  actions: [
                    Padding(
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
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedCircleCard(
                                    title: '🅰️ Deletrea las Vocales',
                                    color: const Color.fromARGB(255, 0, 145, 7),
                                    icon: Icons.keyboard,
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => SpellVowelsGame(
                                                  onComplete: addReward,
                                                ),
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedCircleCard(
                                    title: '🔗 Une las Vocales',
                                    color: const Color.fromARGB(255, 0, 145, 7),
                                    icon: Icons.link,
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ConnectVowelsGame(
                                                  onComplete: addReward,
                                                ),
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedCircleCard(
                                    title: '📝 Ordena las Vocales',
                                    color: const Color.fromARGB(255, 0, 145, 7),
                                    icon: Icons.sort,
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => OrderVowelsGame(
                                                  onComplete: addReward,
                                                ),
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedCircleCard(
                                    title: '🕸️ Atrapa las Letras',
                                    color: const Color.fromARGB(255, 0, 145, 7),
                                    icon: Icons.touch_app,
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => CatchLettersGame(
                                                  onComplete: addReward,
                                                ),
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/boca.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/micro.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.jpg', height: size.height * 0.05),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nota.jpg', height: size.height * 0.05),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            print(
              'VowelsScreen: Navigating to Niveles with - characterImagePath: ${widget.characterImagePath}, username: ${widget.username}',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Niveles(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    ),
              ),
            );
          } else {
            print(
              'VowelsScreen: Navigating to Juego with - characterImagePath: ${widget.characterImagePath}, username: ${widget.username}',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Juego(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAnimatedCircleCard({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: InkWell(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.green[800]!, width: 2),
            ),
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
      ),
    );
  }
}
