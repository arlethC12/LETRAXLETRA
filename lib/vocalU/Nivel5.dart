import 'package:flutter/material.dart';
import 'dart:math';
import 'package:letra_x_letra/vocalA/cargajaguar.dart'; // Ajusta esta ruta si es necesario

class Nivel5Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelCompleteScreen(),
    );
  }
}

class LevelCompleteScreen extends StatefulWidget {
  @override
  _LevelCompleteScreenState createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _starController1;
  late AnimationController _starController2;
  late AnimationController _starController3;
  late Animation<Color?> _starColorAnim1;
  late Animation<Color?> _starColorAnim2;
  late Animation<Color?> _starColorAnim3;
  late Animation<double> _serpentineAnim;
  late AnimationController _serpentineController;

  List<SerpentineParticle> _serpentineParticles = [];

  @override
  void initState() {
    super.initState();

    _starController1 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _starColorAnim1 = ColorTween(
      begin: Colors.grey,
      end: Colors.yellow,
    ).animate(_starController1);

    _starController2 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _starColorAnim2 = ColorTween(
      begin: Colors.grey,
      end: Colors.yellow,
    ).animate(_starController2);

    _starController3 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _starColorAnim3 = ColorTween(
      begin: Colors.grey,
      end: Colors.yellow,
    ).animate(_starController3);

    _serpentineController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _serpentineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _serpentineController, curve: Curves.linear),
    );

    _starController1.forward().then((_) {
      _starController2.forward().then((_) {
        _starController3.forward().then((_) {
          _generateSerpentines();
          _serpentineController.forward();
        });
      });
    });
  }

  void _generateSerpentines() {
    final random = Random();
    for (int i = 0; i < 10; i++) {
      _serpentineParticles.add(
        SerpentineParticle(
          x: random.nextDouble() * 300 - 150,
          y: -50,
          speed: random.nextDouble() * 2 + 1,
          color:
              [Colors.red, Colors.blue, Colors.green, Colors.yellow][random
                  .nextInt(4)],
          length: random.nextDouble() * 20 + 20,
        ),
      );
    }
  }

  @override
  void dispose() {
    _starController1.dispose();
    _starController2.dispose();
    _starController3.dispose();
    _serpentineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _serpentineAnim,
            builder: (context, child) {
              double animationValue = _serpentineAnim.value;
              return CustomPaint(
                painter: SerpentinePainter(
                  _serpentineParticles,
                  animationValue,
                ),
                size: Size(double.infinity, double.infinity),
              );
            },
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedStar(_starColorAnim1),
                      const SizedBox(width: 10),
                      _buildAnimatedStar(_starColorAnim2),
                      const SizedBox(width: 10),
                      _buildAnimatedStar(_starColorAnim3),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomPaint(
                    painter: BannerPainter(),
                    child: Container(
                      width: 260,
                      height: 80,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'NIVEL 5',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Completado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/niveltiger.jpg', width: 260, height: 260),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  MyApp(), // Ajusta si tu siguiente nivel tiene otra clase
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Siguiente nivel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStar(Animation<Color?> animation) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.star, color: Colors.black, size: 50),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Icon(Icons.star, color: animation.value, size: 46);
          },
        ),
      ],
    );
  }
}

class SerpentineParticle {
  double x;
  double y;
  double speed;
  Color color;
  double length;

  SerpentineParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.color,
    required this.length,
  });
}

class SerpentinePainter extends CustomPainter {
  final List<SerpentineParticle> particles;
  final double animationValue;

  SerpentinePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    for (var particle in particles) {
      particle.y += particle.speed;
      if (particle.y < size.height * animationValue) {
        final paint =
            Paint()
              ..color = particle.color
              ..strokeWidth = 3
              ..style = PaintingStyle.stroke;
        final path =
            Path()
              ..moveTo(particle.x, particle.y)
              ..quadraticBezierTo(
                particle.x + 10 * sin(particle.y / 20),
                particle.y + particle.length / 2,
                particle.x,
                particle.y + particle.length,
              );
        canvas.drawPath(path, paint);

        final sparklePaint = Paint()..color = Colors.white.withOpacity(0.8);
        for (int i = 0; i < 3; i++) {
          double sparkleX = particle.x + random.nextDouble() * 20 - 10;
          double sparkleY = particle.y + random.nextDouble() * particle.length;
          canvas.drawCircle(Offset(sparkleX, sparkleY), 2, sparklePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill;
    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final path = Path();
    path.moveTo(20, 0);
    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, size.height - 20);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 20,
      size.height,
    );
    path.lineTo(20, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 20);
    path.lineTo(0, 20);
    path.quadraticBezierTo(0, 0, 20, 0);

    final leftWing =
        Path()
          ..moveTo(0, 20)
          ..lineTo(-20, 40)
          ..lineTo(0, 60)
          ..close();

    final rightWing =
        Path()
          ..moveTo(size.width, 20)
          ..lineTo(size.width + 20, 40)
          ..lineTo(size.width, 60)
          ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(leftWing, paint);
    canvas.drawPath(leftWing, borderPaint);
    canvas.drawPath(rightWing, paint);
    canvas.drawPath(rightWing, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
