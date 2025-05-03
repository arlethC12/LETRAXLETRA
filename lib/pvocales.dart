import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:letra_x_letra/vocalU/videoletraU.dart';
import 'dart:async';
import 'vocalA/vocala.dart';
import 'vocalE/aprendevocale.dart';
import 'vocalI/videovocalI.dart';
import 'vocalO/videovocalO.dart';
import 'niveles.dart';

class VowelsScreen extends StatefulWidget {
  final String characterImagePath;
  final String username;

  VowelsScreen({required this.characterImagePath, required this.username});

  @override
  _VowelsScreenState createState() => _VowelsScreenState();
}

class _VowelsScreenState extends State<VowelsScreen>
    with SingleTickerProviderStateMixin {
  late Map<String, double> _sizes;
  late double _baseSize;
  late double _enlargedSize;

  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  int _currentFootprintIndex = 0;
  late Timer _timer;

  void _onVowelPressed(String path) {
    setState(() {
      _sizes.keys.forEach((key) {
        _sizes[key] = key == path ? _enlargedSize : _baseSize;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _baseSize = 0;
    _enlargedSize = 0;
    _sizes = {
      "assets/vocalA.jpg": _baseSize,
      "assets/vocalE.jpg": _baseSize,
      "assets/vocalI.jpg": _baseSize,
      "assets/vocalO.jpg": _baseSize,
      "assets/vocalU.jpg": _baseSize,
      "assets/vocales.jpg": _baseSize,
    };

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          _currentFootprintIndex =
              (_currentFootprintIndex + 1) % footprintPositions.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  List<Offset> footprintPositions = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);

    _baseSize =
        ResponsiveValue<double>(
          context,
          defaultValue: size.width * 0.18,
          conditionalValues: const [
            Condition.equals(name: MOBILE, value: 98.0),
            Condition.equals(name: TABLET, value: 130.0),
            Condition.equals(name: DESKTOP, value: 150.0),
          ],
        ).value;
    _enlargedSize =
        ResponsiveValue<double>(
          context,
          defaultValue: size.width * 0.25,
          conditionalValues: const [
            Condition.equals(name: MOBILE, value: 100.0),
            Condition.equals(name: TABLET, value: 160.0),
            Condition.equals(name: DESKTOP, value: 200.0),
          ],
        ).value;
    _sizes.updateAll(
      (key, value) => _sizes[key] == _enlargedSize ? _enlargedSize : _baseSize,
    );

    footprintPositions = [
      Offset(size.width * 0.35, size.height * 0.30),
      Offset(size.width * 0.40, size.height * 0.34),
      Offset(size.width * 0.45, size.height * 0.38),
      Offset(size.width * 0.50, size.height * 0.42),
      Offset(size.width * 0.45, size.height * 0.46),
      Offset(size.width * 0.40, size.height * 0.50),
      Offset(size.width * 0.35, size.height * 0.54),
      Offset(size.width * 0.40, size.height * 0.58),
      Offset(size.width * 0.45, size.height * 0.62),
      Offset(size.width * 0.50, size.height * 0.66),
      Offset(size.width * 0.45, size.height * 0.70),
      Offset(size.width * 0.40, size.height * 0.74),
      Offset(size.width * 0.35, size.height * 0.78),
      Offset(size.width * 0.40, size.height * 0.82),
      Offset(size.width * 0.45, size.height * 0.86),
      Offset(size.width * 0.50, size.height * 0.90),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            ResponsiveValue<double>(
              context,
              defaultValue: size.height * 0.08,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 60.0),
                Condition.equals(name: TABLET, value: 70.0),
                Condition.equals(name: DESKTOP, value: 80.0),
              ],
            ).value,
          ),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 189, 162, 139),
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.05,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 25.0),
                          Condition.equals(name: TABLET, value: 30.0),
                          Condition.equals(name: DESKTOP, value: 35.0),
                        ],
                      ).value,
                  backgroundImage: AssetImage(widget.characterImagePath),
                ),
                SizedBox(
                  width:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.03,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 10.0),
                          Condition.equals(name: TABLET, value: 12.0),
                          Condition.equals(name: DESKTOP, value: 15.0),
                        ],
                      ).value,
                ),
                Text(
                  widget.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.width * 0.045,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 18.0),
                            Condition.equals(name: TABLET, value: 20.0),
                            Condition.equals(name: DESKTOP, value: 22.0),
                          ],
                        ).value,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.07,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 30.0),
                        Condition.equals(name: TABLET, value: 35.0),
                        Condition.equals(name: DESKTOP, value: 40.0),
                      ],
                    ).value,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.height * 0.05,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 30.0),
                          Condition.equals(name: TABLET, value: 40.0),
                          Condition.equals(name: DESKTOP, value: 50.0),
                        ],
                      ).value,
                ),
                _buildVowelSectionTitle(),
                _buildImagesAndFootprints(),
                Positioned(
                  right:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.05,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 20.0),
                          Condition.equals(name: TABLET, value: 40.0),
                          Condition.equals(name: DESKTOP, value: 60.0),
                        ],
                      ).value,
                  top:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.height * 0.25,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 120.0),
                          Condition.equals(name: TABLET, value: 150.0),
                          Condition.equals(name: DESKTOP, value: 180.0),
                        ],
                      ).value,
                  child: Image.asset(
                    'assets/tiger.png',
                    height:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.height * 0.18,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 120.0),
                            Condition.equals(name: TABLET, value: 150.0),
                            Condition.equals(name: DESKTOP, value: 180.0),
                          ],
                        ).value,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
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
              icon: Image.asset(
                'assets/boca.jpg',
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.05,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 35.0),
                        Condition.equals(name: TABLET, value: 40.0),
                        Condition.equals(name: DESKTOP, value: 50.0),
                      ],
                    ).value,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/micro.jpg',
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.05,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 35.0),
                        Condition.equals(name: TABLET, value: 40.0),
                        Condition.equals(name: DESKTOP, value: 50.0),
                      ],
                    ).value,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/home.jpg',
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.05,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 35.0),
                        Condition.equals(name: TABLET, value: 40.0),
                        Condition.equals(name: DESKTOP, value: 50.0),
                      ],
                    ).value,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/nota.jpg',
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.05,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 35.0),
                        Condition.equals(name: TABLET, value: 40.0),
                        Condition.equals(name: DESKTOP, value: 50.0),
                      ],
                    ).value,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/juego.png',
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.05,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 35.0),
                        Condition.equals(name: TABLET, value: 40.0),
                        Condition.equals(name: DESKTOP, value: 50.0),
                      ],
                    ).value,
              ),
              label: '',
            ),
          ],
          onTap: (index) {
            if (index == 2) {
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
            }
          },
        ),
      ),
    );
  }

  Widget _buildVowelSectionTitle() {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height:
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
        Container(
          padding: EdgeInsets.symmetric(
            vertical:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.height * 0.015,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 10.0),
                    Condition.equals(name: TABLET, value: 12.0),
                    Condition.equals(name: DESKTOP, value: 15.0),
                  ],
                ).value,
            horizontal:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.width * 0.04,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 20.0),
                    Condition.equals(name: TABLET, value: 25.0),
                    Condition.equals(name: DESKTOP, value: 30.0),
                  ],
                ).value,
          ),
          margin: EdgeInsets.symmetric(
            horizontal:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.width * 0.05,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 25.0),
                    Condition.equals(name: TABLET, value: 30.0),
                    Condition.equals(name: DESKTOP, value: 50.0),
                  ],
                ).value,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(238, 235, 179, 27),
            borderRadius: BorderRadius.circular(
              ResponsiveValue<double>(
                context,
                defaultValue: size.width * 0.04,
                conditionalValues: const [
                  Condition.equals(name: MOBILE, value: 15.0),
                  Condition.equals(name: TABLET, value: 20.0),
                  Condition.equals(name: DESKTOP, value: 25.0),
                ],
              ).value,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Unidad 1, Sección 1",
                    style: TextStyle(
                      fontSize:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.045,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 18.0),
                              Condition.equals(name: TABLET, value: 20.0),
                              Condition.equals(name: DESKTOP, value: 22.0),
                            ],
                          ).value,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Vocales",
                    style: TextStyle(
                      fontSize:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.045,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 18.0),
                              Condition.equals(name: TABLET, value: 20.0),
                              Condition.equals(name: DESKTOP, value: 22.0),
                            ],
                          ).value,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.12,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 50.0),
                        Condition.equals(name: TABLET, value: 60.0),
                        Condition.equals(name: DESKTOP, value: 70.0),
                      ],
                    ).value,
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.12,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 50.0),
                        Condition.equals(name: TABLET, value: 60.0),
                        Condition.equals(name: DESKTOP, value: 70.0),
                      ],
                    ).value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/book.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: SizedBox(
            height:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.height * 0.03,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 10.0),
                    Condition.equals(name: TABLET, value: 25.0),
                    Condition.equals(name: DESKTOP, value: 30.0),
                  ],
                ).value,
          ),
        ),
      ],
    );
  }

  Widget _buildImagesAndFootprints() {
    final size = MediaQuery.of(context).size;

    final List<Map<String, dynamic>> elements = [
      {
        "path": "assets/vocalA.jpg",
        "position": Offset(size.width * 0.05, size.height * 0.20),
      },
      {
        "path": "assets/vocalE.jpg",
        "position": Offset(size.width * 0.70, size.height * 0.35),
      },
      {
        "path": "assets/vocalI.jpg",
        "position": Offset(size.width * 0.05, size.height * 0.45),
      },
      {
        "path": "assets/vocalO.jpg",
        "position": Offset(size.width * 0.70, size.height * 0.55),
      },
      {
        "path": "assets/vocalU.jpg",
        "position": Offset(size.width * 0.05, size.height * 0.70),
      },
      {
        "path": "assets/vocales.jpg",
        "position": Offset(size.width * 0.70, size.height * 0.80),
      },
    ];

    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          ...elements.map((element) {
            final path = element["path"] as String;
            return Positioned(
              left: (element["position"] as Offset).dx,
              top: (element["position"] as Offset).dy,
              child: GestureDetector(
                onTap: () {
                  _onVowelPressed(path);
                  if (path == "assets/vocalA.jpg") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VocalAPage()),
                    );
                  } else if (path == "assets/vocalE.jpg") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VocalEPage()),
                    );
                  } else if (path == "assets/vocalI.jpg") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VocalIPage()),
                    );
                  } else if (path == "assets/vocalO.jpg") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VocalOPage()),
                    );
                  } else if (path == "assets/vocalU.jpg") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VocalUPage()),
                    );
                  }
                },
                child: Column(
                  children: [
                    if (path == "assets/vocales.jpg")
                      Image.asset(
                        'assets/corona.png',
                        height:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: size.height * 0.04,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 30.0),
                                Condition.equals(name: TABLET, value: 40.0),
                                Condition.equals(name: DESKTOP, value: 50.0),
                              ],
                            ).value,
                      ),
                    Container(
                      width: _sizes[path],
                      height: _sizes[path],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.03,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 15.0),
                              Condition.equals(name: TABLET, value: 20.0),
                              Condition.equals(name: DESKTOP, value: 25.0),
                            ],
                          ).value,
                        ),
                        color: Colors.lightBlueAccent,
                        image: DecorationImage(
                          image: AssetImage(path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.height * 0.01,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 10.0),
                              Condition.equals(name: TABLET, value: 12.0),
                              Condition.equals(name: DESKTOP, value: 15.0),
                            ],
                          ).value,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.04,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 20.0),
                                  Condition.equals(name: TABLET, value: 25.0),
                                  Condition.equals(name: DESKTOP, value: 30.0),
                                ],
                              ).value,
                          color: const Color.fromARGB(255, 253, 232, 38),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          ...footprintPositions.asMap().entries.map((entry) {
            final index = entry.key;
            final position = entry.value;
            return Positioned(
              left: position.dx,
              top:
                  position.dy -
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.04,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 25.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity:
                        _currentFootprintIndex == index
                            ? _glowAnimation.value
                            : 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(
                              _currentFootprintIndex == index ? 0.6 : 0,
                            ),
                            blurRadius:
                                ResponsiveValue<double>(
                                  context,
                                  defaultValue: size.width * 0.03,
                                  conditionalValues: const [
                                    Condition.equals(name: MOBILE, value: 15.0),
                                    Condition.equals(name: TABLET, value: 20.0),
                                    Condition.equals(
                                      name: DESKTOP,
                                      value: 25.0,
                                    ),
                                  ],
                                ).value,
                            spreadRadius:
                                ResponsiveValue<double>(
                                  context,
                                  defaultValue: size.width * 0.005,
                                  conditionalValues: const [
                                    Condition.equals(name: MOBILE, value: 3.0),
                                    Condition.equals(name: TABLET, value: 4.0),
                                    Condition.equals(name: DESKTOP, value: 5.0),
                                  ],
                                ).value,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.pets,
                        size:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: size.width * 0.06,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 30.0),
                                Condition.equals(name: TABLET, value: 35.0),
                                Condition.equals(name: DESKTOP, value: 40.0),
                              ],
                            ).value,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
