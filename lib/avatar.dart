import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'niveles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CharacterSelectionScreen(nombre: 'invitado'),
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
            ],
          ),
    );
  }
}

class CharacterSelectionScreen extends StatefulWidget {
  final String nombre;

  const CharacterSelectionScreen({super.key, required this.nombre});

  @override
  _CharacterSelectionScreenState createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final List<String> characterImages = [
    'assets/ajaguar.jpg',
    'assets/amono.jpg',
    'assets/aqueztal.jpg',
    'assets/atucan.jpg',
    'assets/apuma.jpg',
    'assets/aguacamaya.jpg',
    'assets/achita.jpg',
    'assets/aaguila.jpg',
    'assets/acocodrilo.jpg',
    'assets/atapir.jpg',
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  void _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(AssetSource('audios/avatar.mp3'));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double padding =
        size.width * (isMobile ? 0.04 : (isTablet ? 0.05 : 0.06));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size:
                ResponsiveValue<double>(
                  context,
                  defaultValue: 30.0,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 25.0),
                    Condition.equals(name: TABLET, value: 30.0),
                    Condition.equals(name: DESKTOP, value: 35.0),
                  ],
                ).value,
          ),
          onPressed: () {
            if (_isPlaying) {
              _audioPlayer.stop();
            }
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Elige tu personaje",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.width * 0.05,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 18.0),
                    Condition.equals(name: TABLET, value: 20.0),
                    Condition.equals(name: DESKTOP, value: 24.0),
                  ],
                ).value,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.volume_up,
              color: Colors.black,
              size:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: 30.0,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 25.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            onPressed: _toggleAudio,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ResponsiveValue<double>(
              context,
              defaultValue: size.height * 0.03,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 20.0),
                Condition.equals(name: TABLET, value: 25.0),
                Condition.equals(name: DESKTOP, value: 30.0),
              ],
            ).value,
          ),
          child: SizedBox(
            height:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.height * 0.015,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 8.0),
                    Condition.equals(name: TABLET, value: 10.0),
                    Condition.equals(name: DESKTOP, value: 12.0),
                  ],
                ).value,
            child: LinearProgressIndicator(
              value: 10,
              backgroundColor: Colors.grey[350],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount =
                  (constraints.maxWidth /
                          (isMobile ? 100 : (isTablet ? 120 : 140)))
                      .floor();
              if (crossAxisCount < 2) crossAxisCount = 2;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.04,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 15.0),
                          Condition.equals(name: TABLET, value: 15.0),
                          Condition.equals(name: DESKTOP, value: 20.0),
                        ],
                      ).value,
                  mainAxisSpacing:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.height * 0.02,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 15.0),
                          Condition.equals(name: TABLET, value: 15.0),
                          Condition.equals(name: DESKTOP, value: 20.0),
                        ],
                      ).value,
                  childAspectRatio: 1,
                ),
                itemCount: characterImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _audioPlayer.stop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LoadingScreen(
                                imagePath: characterImages[index],
                                nombre: widget.nombre,
                              ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage(characterImages[index]),
                      radius:
                          ResponsiveValue<double>(
                            context,
                            defaultValue:
                                constraints.maxWidth / (crossAxisCount * 4.0),
                            conditionalValues: [
                              Condition.equals(
                                name: MOBILE,
                                value:
                                    constraints.maxWidth /
                                    (crossAxisCount * 2.8),
                              ),
                              Condition.equals(
                                name: TABLET,
                                value:
                                    constraints.maxWidth /
                                    (crossAxisCount * 2.5),
                              ),
                              Condition.equals(
                                name: DESKTOP,
                                value:
                                    constraints.maxWidth /
                                    (crossAxisCount * 2.3),
                              ),
                            ],
                          ).value,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  final String imagePath;
  final String nombre;

  const LoadingScreen({
    super.key,
    required this.imagePath,
    required this.nombre,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  final List<String> loadingImages = [
    'assets/car1.jpg',
    'assets/car2.jpg',
    'assets/car3.jpg',
    'assets/car4.jpg',
  ];
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _progress += 0.2;
        currentImageIndex = (currentImageIndex + 1) % loadingImages.length;
        if (_progress >= 1.0) {
          timer.cancel();
          _progress = 1.0;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Niveles(
                    characterImagePath: widget.imagePath,
                    username: widget.nombre,
                  ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double spacing =
        size.height * (isMobile ? 0.03 : (isTablet ? 0.04 : 0.05));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 197, 36),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_progress < 1.0)
                Text(
                  "Bienvenid@, ${widget.nombre}",
                  style: TextStyle(
                    fontSize:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.width * 0.08,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 24.0),
                            Condition.equals(name: TABLET, value: 30.0),
                            Condition.equals(name: DESKTOP, value: 36.0),
                          ],
                        ).value,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              if (_progress >= 1.0)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "LETRA ",
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.08,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 24.0),
                                  Condition.equals(name: TABLET, value: 30.0),
                                  Condition.equals(name: DESKTOP, value: 36.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: "X",
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.08,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 24.0),
                                  Condition.equals(name: TABLET, value: 30.0),
                                  Condition.equals(name: DESKTOP, value: 36.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: " LETRA",
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.08,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 24.0),
                                  Condition.equals(name: TABLET, value: 30.0),
                                  Condition.equals(name: DESKTOP, value: 36.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: spacing),
              Image.asset(
                loadingImages[currentImageIndex],
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.25,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 150.0),
                        Condition.equals(name: TABLET, value: 200.0),
                        Condition.equals(name: DESKTOP, value: 250.0),
                      ],
                    ).value,
                fit: BoxFit.contain,
              ),
              SizedBox(height: spacing),
              Container(
                width:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.7,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 200.0),
                        Condition.equals(name: TABLET, value: 300.0),
                        Condition.equals(name: DESKTOP, value: 400.0),
                      ],
                    ).value,
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.04,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 20.0),
                        Condition.equals(name: TABLET, value: 30.0),
                        Condition.equals(name: DESKTOP, value: 40.0),
                      ],
                    ).value,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 175, 55),
                  borderRadius: BorderRadius.circular(
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.04,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 10.0),
                        Condition.equals(name: TABLET, value: 15.0),
                        Condition.equals(name: DESKTOP, value: 20.0),
                      ],
                    ).value,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.04,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 10.0),
                        Condition.equals(name: TABLET, value: 15.0),
                        Condition.equals(name: DESKTOP, value: 20.0),
                      ],
                    ).value,
                  ),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing * 1.5),
              Text(
                "Cargando...",
                style: TextStyle(
                  fontSize:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.06,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 16.0),
                          Condition.equals(name: TABLET, value: 20.0),
                          Condition.equals(name: DESKTOP, value: 24.0),
                        ],
                      ).value,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
