import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:letra_x_letra/vocalU/videoletraU.dart';
import 'package:letra_x_letra/Juegos/juego.dart';
import 'dart:async';
import 'vocalA/vocala.dart';
import 'vocalE/aprendevocale.dart';
import 'vocalI/videovocalI.dart';
import 'vocalO/videovocalO.dart';
import 'niveles.dart';
import 'Continuara.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VowelsScreen extends StatefulWidget {
  final String characterImagePath;
  final String username;
  final String token;

  const VowelsScreen({
    Key? key,
    required this.characterImagePath,
    required this.username,
    required this.token,
  }) : super(key: key);

  @override
  _VowelsScreenState createState() => _VowelsScreenState();
}

class _VowelsScreenState extends State<VowelsScreen>
    with SingleTickerProviderStateMixin {
  late Map<String, double> _sizes;
  double _baseSize = 0;
  double _enlargedSize = 0;

  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  int _currentFootprintIndex = 0;
  late Timer _timer;

  String _subjectName = "Cargando...";
  int? _subjectId;
  Map<String, dynamic> _lessonDetails = {};
  Map<String, int> _lessonStars = {};
  bool _isLoading = true;
  String? _errorMessage;

  static const Map<String, String> lessonToImageMap = {
    'Vocal A': 'assets/vocalA.jpg',
    'Vocal E': 'assets/vocalE.jpg',
    'Vocal I': 'assets/vocalI.jpg',
    'Vocal O': 'assets/vocalO.jpg',
    'Vocal U': 'assets/vocalU.jpg',
    'Vocales': 'assets/vocales.jpg',
  };

  final List<String> _lessonPaths = lessonToImageMap.values.toList();

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
    print(
      'VowelsScreen: Initialized with - characterImagePath: ${widget.characterImagePath}, username: ${widget.username}, token: ${widget.token}',
    );

    _sizes = {for (var path in _lessonPaths) path: _baseSize};

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

    _fetchSubject();
    _fetchLessons();
    _lessonStars = {for (var path in _lessonPaths) path: 0};
  }

  Future<void> _fetchSubject() async {
    const maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final response = await http
            .get(
              Uri.parse('http://192.168.1.38:3000/materias/1'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${widget.token}',
              },
            )
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException(
                  'La solicitud a la materia excedió el tiempo de espera',
                );
              },
            );

        print(
          'VowelsScreen: Fetch subject response - Status: ${response.statusCode}, Body: ${response.body}',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            if (data is Map<String, dynamic> &&
                data['cve_materia'] != null &&
                data['nombre_materia'] != null) {
              _subjectId = data['cve_materia'];
              _subjectName = data['nombre_materia'];
              _isLoading = false;
              _errorMessage = null;
            } else {
              _subjectId = null;
              _subjectName = "Cargando...";
              _isLoading = false;
              _errorMessage = 'Formato de respuesta inesperado';
              print('VowelsScreen: Unexpected response format - $data');
            }
            print(
              'VowelsScreen: Subject fetched successfully - $_subjectId: $_subjectName',
            );
          });
          return;
        } else if (response.statusCode == 403) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Acceso denegado. Verifica tu autenticación.';
          });
          return;
        } else if (response.statusCode == 404) {
          print('VowelsScreen: Subject not found (404) - ${response.body}');
          setState(() {
            _isLoading = false;
            _errorMessage = 'Materia no encontrada';
          });
          return;
        } else {
          print(
            'VowelsScreen: API Error - Status Code ${response.statusCode}, Body: ${response.body}',
          );
          attempt++;
          if (attempt == maxRetries) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Error al conectar con el servidor';
            });
          }
          await Future.delayed(Duration(seconds: 2));
        }
      } catch (e) {
        print('VowelsScreen: Exception fetching subject - $e');
        attempt++;
        if (attempt == maxRetries) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error de conexión: $e';
          });
        }
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  Future<void> _fetchLessons() async {
    const maxRetries = 3;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      for (var title in lessonToImageMap.keys) {
        final path = lessonToImageMap[title]!;
        final encodedTitle = Uri.encodeComponent(title);
        print('VowelsScreen: Fetching lesson with name: $title');

        int attempt = 0;
        bool success = false;

        while (attempt < maxRetries && !success) {
          try {
            final response = await http
                .get(
                  Uri.parse(
                    'http://10.33.25.63:3000/lecciones/nombre/$encodedTitle',
                  ),
                  headers: {'Content-Type': 'application/json'},
                )
                .timeout(Duration(seconds: 10));

            print(
              'VowelsScreen: Fetch lesson response for $title - Status: ${response.statusCode}, Body: ${response.body}',
            );

            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              if (data is Map<String, dynamic> &&
                  data['cve_leccion'] != null &&
                  data['titulo_leccion'] != null) {
                setState(() {
                  _lessonDetails[path] = {
                    'cve_leccion': data['cve_leccion'] as int,
                    'titulo_leccion': data['titulo_leccion'] as String,
                  };
                });
                success = true;
                print(
                  'VowelsScreen: Lesson fetched - $path: ${_lessonDetails[path]}',
                );
              } else {
                print(
                  'VowelsScreen: Invalid response format for $title - $data',
                );
                setState(() {
                  _lessonDetails[path] = {
                    'cve_leccion': 0,
                    'titulo_leccion': title,
                  };
                });
                success = true;
              }
            } else if (response.statusCode == 404) {
              print(
                'VowelsScreen: Lesson not found for $title - ${response.body}',
              );
              setState(() {
                _lessonDetails[path] = {
                  'cve_leccion': 0,
                  'titulo_leccion': title,
                };
              });
              success = true;
            } else {
              print(
                'VowelsScreen: API Error for $title - Status Code ${response.statusCode}, Body: ${response.body}',
              );
              attempt++;
              if (attempt == maxRetries) {
                setState(() {
                  _lessonDetails[path] = {
                    'cve_leccion': 0,
                    'titulo_leccion': title,
                  };
                });
                success = true;
              }
              await Future.delayed(Duration(seconds: 2));
            }
          } catch (e) {
            print('VowelsScreen: Exception fetching lesson $title - $e');
            attempt++;
            if (attempt == maxRetries) {
              setState(() {
                _lessonDetails[path] = {
                  'cve_leccion': 0,
                  'titulo_leccion': title,
                };
              });
              success = true;
            }
            await Future.delayed(Duration(seconds: 2));
          }
        }
      }
    } catch (e) {
      print('VowelsScreen: General exception fetching lessons - $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al conectar con el servidor: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateLessonProgress(String path, int stars) {
    setState(() {
      _lessonStars[path] = stars.clamp(0, 5);
      print(
        'VowelsScreen: Lesson progress updated locally - $path, $stars stars',
      );
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
                  backgroundImage: AssetImage(
                    widget.characterImagePath.isNotEmpty
                        ? widget.characterImagePath
                        : 'assets/caminajaguar.jpg',
                  ),
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
                  widget.username.isNotEmpty ? widget.username : 'invitado',
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
              icon: GestureDetector(
                onTap: () {
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
                },
                child: Image.asset(
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
              ),
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
            } else if (index == 0 || index == 1 || index == 3) {
              print(
                'VowelsScreen: Navigating to Continuara with - characterImagePath: ${widget.characterImagePath}, username: ${widget.username}',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Continuara(
                        characterImagePath: widget.characterImagePath,
                        username: widget.username,
                      ),
                ),
              );
            } else if (index == 4) {
              print(
                'VowelsScreen: Navigating to Juego with - characterImagePath: ${widget.characterImagePath}, username: ${widget.username}, token: ${widget.token}',
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
                  defaultValue: size.width * 0.02,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 10.0),
                    Condition.equals(name: TABLET, value: 15.0),
                    Condition.equals(name: DESKTOP, value: 20.0),
                  ],
                ).value,
          ),
          margin: EdgeInsets.symmetric(
            horizontal:
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.width * 0.03,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 15.0),
                    Condition.equals(name: TABLET, value: 20.0),
                    Condition.equals(name: DESKTOP, value: 30.0),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoading)
                      Text(
                        "Cargando...",
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.06,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 20.0),
                                  Condition.equals(name: TABLET, value: 22.0),
                                  Condition.equals(name: DESKTOP, value: 24.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    else if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.06,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 20.0),
                                  Condition.equals(name: TABLET, value: 22.0),
                                  Condition.equals(name: DESKTOP, value: 24.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    else if (_subjectId != null && _subjectName.isNotEmpty)
                      Text(
                        "$_subjectId: $_subjectName",
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.06,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 20.0),
                                  Condition.equals(name: TABLET, value: 22.0),
                                  Condition.equals(name: DESKTOP, value: 24.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        "Sin datos",
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.06,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 20.0),
                                  Condition.equals(name: TABLET, value: 22.0),
                                  Condition.equals(name: DESKTOP, value: 24.0),
                                ],
                              ).value,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      "Vocales",
                      style: TextStyle(
                        fontSize:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: size.width * 0.045,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 16.0),
                                Condition.equals(name: TABLET, value: 18.0),
                                Condition.equals(name: DESKTOP, value: 20.0),
                              ],
                            ).value,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.08,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 40.0),
                        Condition.equals(name: TABLET, value: 50.0),
                        Condition.equals(name: DESKTOP, value: 60.0),
                      ],
                    ).value,
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.08,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 40.0),
                        Condition.equals(name: TABLET, value: 50.0),
                        Condition.equals(name: DESKTOP, value: 60.0),
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
        "position": Offset(size.width * 0.05, size.height * 0.18),
      },
      {
        "path": "assets/vocalE.jpg",
        "position": Offset(size.width * 0.70, size.height * 0.34),
      },
      {
        "path": "assets/vocalI.jpg",
        "position": Offset(size.width * 0.05, size.height * 0.45),
      },
      {
        "path": "assets/vocalO.jpg",
        "position": Offset(size.width * 0.70, size.height * 0.58),
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
            final lessonDetail =
                _lessonDetails[path] ??
                {
                  'titulo_leccion':
                      lessonToImageMap.entries
                          .firstWhere((entry) => entry.value == path)
                          .key,
                  'cve_leccion': 0,
                };
            final lessonName =
                lessonDetail['titulo_leccion'] as String? ?? 'Sin nombre';
            final lessonId = lessonDetail['cve_leccion'] as int? ?? 0;
            final stars = _lessonStars[path] ?? 0;

            return Positioned(
              left: (element["position"] as Offset).dx,
              top: (element["position"] as Offset).dy,
              child: GestureDetector(
                onTap: () async {
                  _onVowelPressed(path);
                  print(
                    'VowelsScreen: Navigating to vowel page for $path with - characterImagePath: ${widget.characterImagePath}, username: ${widget.username}, lessonId: $lessonId',
                  );

                  if (lessonId != 0) {
                    _updateLessonProgress(path, 3);
                  }

                  Widget? targetPage;
                  if (path == "assets/vocalA.jpg") {
                    targetPage = VocalAPage(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    );
                  } else if (path == "assets/vocalE.jpg") {
                    targetPage = VocalEPage(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    );
                  } else if (path == "assets/vocalI.jpg") {
                    targetPage = VocalIPage(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    );
                  } else if (path == "assets/vocalO.jpg") {
                    targetPage = VocalOPage(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    );
                  } else if (path == "assets/vocalU.jpg") {
                    targetPage = VocalUPage(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    );
                  } else if (path == "assets/vocales.jpg") {
                    targetPage = Continuara(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    );
                  }

                  if (targetPage != null) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => targetPage!),
                    );
                    if (result != null && result is int && lessonId != 0) {
                      _updateLessonProgress(path, result);
                    }
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
                    SizedBox(height: 5),
                    Text(
                      lessonName,
                      style: TextStyle(
                        fontSize:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: size.width * 0.035,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 14.0),
                                Condition.equals(name: TABLET, value: 16.0),
                                Condition.equals(name: DESKTOP, value: 18.0),
                              ],
                            ).value,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (lessonId != 0)
                      Text(
                        'ID: $lessonId',
                        style: TextStyle(
                          fontSize:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: size.width * 0.03,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 12.0),
                                  Condition.equals(name: TABLET, value: 14.0),
                                  Condition.equals(name: DESKTOP, value: 16.0),
                                ],
                              ).value,
                          color: Colors.grey,
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
                          color:
                              index < stars
                                  ? Color.fromARGB(255, 253, 232, 38)
                                  : Colors.grey,
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
