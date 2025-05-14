import 'package:flutter/material.dart';
import 'package:letra_x_letra/pvocales.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Map<String, String>>(
        future: _loadSavedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final characterImagePath =
                snapshot.data?['characterImagePath'] ??
                'assets/caminajaguar.jpg';
            final username = snapshot.data?['username'] ?? 'invitado';
            return JaguarWalkingScreen(
              characterImagePath: characterImagePath,
              username: username,
              vowelPath: null, // No vowel selected for initial load
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Map<String, String>> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'characterImagePath':
          prefs.getString('characterImagePath') ?? 'assets/caminajaguar.jpg',
      'username': prefs.getString('username') ?? 'invitado',
    };
  }
}

class JaguarWalkingScreen extends StatefulWidget {
  final String characterImagePath;
  final String username;
  final String? vowelPath;

  const JaguarWalkingScreen({
    Key? key,
    required this.characterImagePath,
    required this.username,
    this.vowelPath,
  }) : super(key: key);

  @override
  _JaguarWalkingScreenState createState() => _JaguarWalkingScreenState();
}

class _JaguarWalkingScreenState extends State<JaguarWalkingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentFootprintIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _controller.addListener(() {
      if (mounted && _animation.value != null) {
        setState(() {
          final progress = _animation.value / MediaQuery.of(context).size.width;
          _currentFootprintIndex = (progress * 10).floor();
        });
      }
    });

    _saveData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('characterImagePath', widget.characterImagePath);
    await prefs.setString('username', widget.username);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screenWidth = MediaQuery.of(context).size.width;
    _animation = Tween<double>(
      begin: 0,
      end: screenWidth - 150,
    ).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => VowelsScreen(
                  characterImagePath: widget.characterImagePath,
                  username: widget.username,
                  token: '',
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.25),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Letra ',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: 'X ',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: 'Letra',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value,
                top: size.height * 0.45,
                child: SizedBox(
                  width: 150,
                  child: Image.asset(
                    'assets/caminajaguar.jpg', // Use caminajaguar.jpg during animation
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: size.height * 0.59,
            left: size.width * 0.1,
            child: Row(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.pets,
                    color:
                        index < _currentFootprintIndex
                            ? Colors.black
                            : Colors.grey.shade400,
                    size: size.width * 0.05,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
