import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:letra_x_letra/niveles.dart';
import 'package:letra_x_letra/Juegos/juego.dart';
import 'package:letra_x_letra/voces.dart';
import 'package:letra_x_letra/escritura.dart';
import 'main.dart';

class ReconocimientoVoz extends StatefulWidget {
  final String characterImagePath;
  final String username;
  final String token;

  const ReconocimientoVoz({
    Key? key,
    required this.characterImagePath,
    required this.username,
    this.token = '',
  }) : super(key: key);

  @override
  State<ReconocimientoVoz> createState() => _ReconocimientoVozState();
}

class _ReconocimientoVozState extends State<ReconocimientoVoz> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';
  String _currentVowel = '';
  String _feedback = '';
  bool _isCorrect = false;
  Set<String> _completedVowels = {};

  final List<String> _vowels = ['A', 'E', 'I', 'O', 'U'];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening(String vowel) async {
    if (_isListening) return;

    setState(() {
      _currentVowel = vowel.toLowerCase();
      _feedback = 'Di la vocal: "$vowel"';
      _isCorrect = false;
    });

    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: _onSpeechResult,
        localeId: 'es_ES',
        listenFor: Duration(seconds: 6),
        pauseFor: Duration(seconds: 3),
      );
    } else {
      setState(() {
        _isListening = false;
        _feedback = 'Micrófono no disponible';
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords.toLowerCase().trim();
      _isListening = false;
    });

    // Palabras clave tolerantes por vocal
    Map<String, List<String>> vowelKeywords = {
      'a': ['a', 'ah', 'ha', 'á', 'aaa', 'la', 'ma', 'pa'],
      'e': ['e', 'eh', 'he', 'é', 'eee', 'le', 'me', 'pe'],
      'i': ['i', 'ih', 'hi', 'í', 'iii', 'y', 'li', 'mi', 'pi'],
      'o': ['o', 'oh', 'ho', 'ó', 'ooo', 'lo', 'mo', 'po'],
      'u': ['u', 'uh', 'hu', 'ú', 'uuu', 'lu', 'mu', 'pu'],
    };

    String target = _currentVowel;
    bool recognized = vowelKeywords[target]!.any(
      (keyword) => _lastWords.contains(keyword),
    );

    if (recognized && !_completedVowels.contains(target)) {
      setState(() {
        _feedback = '¡Perfecto! Dijiste: "$_currentVowel"';
        _isCorrect = true;
        _completedVowels.add(target);
      });
    } else {
      setState(() {
        _feedback = 'Inténtalo otra vez';
        _isCorrect = false;
      });
    }

    // Completado
    if (_completedVowels.length == _vowels.length) {
      Future.delayed(Duration(milliseconds: 800), () {
        setState(() {
          _feedback = '¡Felicidades! Completaste todas las vocales';
        });
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          isMobile
              ? 60
              : isTablet
              ? 70
              : 80,
        ),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      _showProfileMenu(context, details.globalPosition);
                    },
                    child: CircleAvatar(
                      radius:
                          isMobile
                              ? 22
                              : isTablet
                              ? 28
                              : 32,
                      backgroundImage: AssetImage(
                        widget.characterImagePath.isNotEmpty &&
                                widget.characterImagePath.contains('assets/')
                            ? widget.characterImagePath
                            : 'assets/default.jpg',
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Título
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Text(
              'Di la vocal',
              style: TextStyle(
                fontSize: isMobile ? 28 : 34,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Feedback
          Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 30),
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color:
                  _isCorrect
                      ? Colors.green[100]
                      : (_completedVowels.length == 5
                          ? Colors.purple[100]
                          : Colors.orange[100]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    _isCorrect
                        ? Colors.green
                        : (_completedVowels.length == 5
                            ? Colors.purple
                            : Colors.orange),
                width: 2,
              ),
            ),
            child: Text(
              _feedback.isEmpty
                  ? 'Presiona una vocal para practicar'
                  : _feedback,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color:
                    _isCorrect
                        ? Colors.green[800]
                        : (_completedVowels.length == 5
                            ? Colors.purple[800]
                            : Colors.orange[800]),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Botones de vocales
          Expanded(
            child: Center(
              child: Wrap(
                spacing: isMobile ? 16 : 24,
                runSpacing: isMobile ? 20 : 28,
                alignment: WrapAlignment.center,
                children:
                    _vowels.map((vocal) {
                      bool isCompleted = _completedVowels.contains(
                        vocal.toLowerCase(),
                      );
                      bool isEnabled = !isCompleted && !_isListening;

                      return ElevatedButton(
                        onPressed:
                            isEnabled ? () => _startListening(vocal) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isCompleted
                                  ? Colors.green
                                  : (vocal.toLowerCase() == _currentVowel
                                      ? Colors.orange[400]
                                      : Colors.yellow),
                          foregroundColor:
                              isCompleted ? Colors.white : Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 32 : 40,
                            vertical: isMobile ? 24 : 30,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: isCompleted ? 12 : 8,
                        ),
                        child: Text(
                          vocal,
                          style: TextStyle(
                            fontSize: isMobile ? 44 : 56,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),

      // Barra de navegación
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        currentIndex: 1,
        items: [
          _buildNavItem('assets/boca.jpg', isMobile, isTablet),
          _buildNavItem('assets/micro.jpg', isMobile, isTablet),
          _buildNavItem('assets/home.jpg', isMobile, isTablet),
          _buildNavItem('assets/nota.jpg', isMobile, isTablet),
          _buildNavItem('assets/juego.png', isMobile, isTablet),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ReconocimientoVoz(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (_) => Niveles(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                    ),
              ),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => Voces(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => Escritura(
                      characterImagePath: widget.characterImagePath,
                      username: widget.username,
                      token: widget.token,
                    ),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => Juego(
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

  BottomNavigationBarItem _buildNavItem(
    String asset,
    bool isMobile,
    bool isTablet,
  ) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        asset,
        height:
            isMobile
                ? 30
                : isTablet
                ? 35
                : 40,
        fit: BoxFit.contain,
      ),
      label: '',
    );
  }

  void _showProfileMenu(BuildContext context, Offset position) {
    final renderBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        renderBox.size.width - position.dx,
        renderBox.size.height - position.dy,
      ),
      items: const [
        PopupMenuItem(value: 'edit_profile', child: Text('Editar Perfil')),
        PopupMenuItem(value: 'logout', child: Text('Cerrar Sesión')),
      ],
    ).then((value) {
      if (value == 'logout') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyApp()),
          (r) => false,
        );
      }
    });
  }
}
