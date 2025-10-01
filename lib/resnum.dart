import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'avatar.dart';

void main() {
  runApp(
    const ResnumScreen(nombre: 'Juan', edad: '5'),
  ); // Example values, replace with actual navigation
}

class ResnumScreen extends StatelessWidget {
  final String nombre;
  final String edad;

  const ResnumScreen({super.key, required this.nombre, required this.edad});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(nombre: nombre, edad: edad),
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

class MyHomePage extends StatefulWidget {
  final String nombre;
  final String edad;

  const MyHomePage({super.key, required this.nombre, required this.edad});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isLoading = false;
  bool _isLoginMode = true;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _playAudio() async {
    await _player.play(AssetSource('audios/telefono.mp3'));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.38:3000/usuario/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'password': _controller.text.trim()}),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _player.stop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    CharacterSelectionScreen(nombre: userData['nombre']),
          ),
        );
      } else {
        final errorMessage =
            jsonDecode(response.body)['mensaje'] ?? 'Número no encontrado';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.38:3000/usuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': widget.nombre.trim(),
          'edad': widget.edad.trim(),
          'password': _controller.text.trim(),
          'cve_rol': 3,
          'cve_grado':
              int.tryParse(widget.edad.trim()) != null &&
                      int.parse(widget.edad.trim()) <= 6
                  ? int.parse(widget.edad.trim())
                  : 1,
        }),
      );

      if (response.statusCode == 200) {
        _player.stop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CharacterSelectionScreen(nombre: widget.nombre),
          ),
        );
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ??
            'Error al registrar el usuario';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    final double padding =
        size.width * (isMobile ? 0.07 : (isTablet ? 0.08 : 0.09));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isLoginMode ? 'Iniciar Sesión' : 'Registrarse',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size:
                ResponsiveValue<double>(
                  context,
                  defaultValue: 30.0,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 28.0),
                    Condition.equals(name: TABLET, value: 30.0),
                    Condition.equals(name: DESKTOP, value: 35.0),
                  ],
                ).value,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ResponsiveValue<double>(
              context,
              defaultValue: 10.0,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 9.0),
                Condition.equals(name: TABLET, value: 10.0),
                Condition.equals(name: DESKTOP, value: 12.0),
              ],
            ).value,
          ),
          child: LinearProgressIndicator(
            value: 0.97,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
            minHeight:
                ResponsiveValue<double>(
                  context,
                  defaultValue: 10.0,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 9.0),
                    Condition.equals(name: TABLET, value: 10.0),
                    Condition.equals(name: DESKTOP, value: 12.0),
                  ],
                ).value,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                SizedBox(height: spacing),
                Image.asset(
                  'assets/num.jpg',
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.height * 0.3,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 170.0),
                          Condition.equals(name: TABLET, value: 250.0),
                          Condition.equals(name: DESKTOP, value: 300.0),
                        ],
                      ).value,
                  width:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.8,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 200.0),
                          Condition.equals(name: TABLET, value: 400.0),
                          Condition.equals(name: DESKTOP, value: 500.0),
                        ],
                      ).value,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: spacing),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    size:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: 40.0,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 30.0),
                            Condition.equals(name: TABLET, value: 40.0),
                            Condition.equals(name: DESKTOP, value: 50.0),
                          ],
                        ).value,
                    color: Colors.black,
                  ),
                  onPressed: _playAudio,
                ),
                SizedBox(height: spacing * 0.75),
                Text(
                  'Ingresa tu número telefónico:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing * 0.75),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixText: '+52 ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveValue<double>(
                              context,
                              defaultValue: 8.0,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 6.0),
                                Condition.equals(name: TABLET, value: 8.0),
                                Condition.equals(name: DESKTOP, value: 10.0),
                              ],
                            ).value,
                          ),
                        ),
                        labelText: 'Número',
                        contentPadding: EdgeInsets.symmetric(
                          vertical:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: 15.0,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 10.0),
                                  Condition.equals(name: TABLET, value: 15.0),
                                  Condition.equals(name: DESKTOP, value: 20.0),
                                ],
                              ).value,
                          horizontal:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: 10.0,
                                conditionalValues: const [
                                  Condition.equals(name: MOBILE, value: 8.0),
                                  Condition.equals(name: TABLET, value: 10.0),
                                  Condition.equals(name: DESKTOP, value: 12.0),
                                ],
                              ).value,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: 24.0,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 20.0),
                                Condition.equals(name: TABLET, value: 24.0),
                                Condition.equals(name: DESKTOP, value: 28.0),
                              ],
                            ).value,
                        color: Colors.black,
                      ),
                      onPressed: _listen,
                    ),
                  ],
                ),
                SizedBox(height: spacing * 2),
                ElevatedButton(
                  onPressed:
                      _controller.text.trim().isEmpty || _isLoading
                          ? null
                          : _isLoginMode
                          ? _loginUser
                          : _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.height * 0.02,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 15.0),
                              Condition.equals(name: TABLET, value: 20.0),
                              Condition.equals(name: DESKTOP, value: 25.0),
                            ],
                          ).value,
                      horizontal:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.1,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 30.0),
                              Condition.equals(name: TABLET, value: 40.0),
                              Condition.equals(name: DESKTOP, value: 50.0),
                            ],
                          ).value,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveValue<double>(
                          context,
                          defaultValue: 20.0,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 15.0),
                            Condition.equals(name: TABLET, value: 20.0),
                            Condition.equals(name: DESKTOP, value: 25.0),
                          ],
                        ).value,
                      ),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isLoginMode ? 'Iniciar Sesión' : 'Registrarse',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveValue<double>(
                                        context,
                                        defaultValue: size.width * 0.045,
                                        conditionalValues: const [
                                          Condition.equals(
                                            name: MOBILE,
                                            value: 14.0,
                                          ),
                                          Condition.equals(
                                            name: TABLET,
                                            value: 16.0,
                                          ),
                                          Condition.equals(
                                            name: DESKTOP,
                                            value: 18.0,
                                          ),
                                        ],
                                      ).value,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width:
                                    ResponsiveValue<double>(
                                      context,
                                      defaultValue: 8.0,
                                      conditionalValues: const [
                                        Condition.equals(
                                          name: MOBILE,
                                          value: 6.0,
                                        ),
                                        Condition.equals(
                                          name: TABLET,
                                          value: 8.0,
                                        ),
                                        Condition.equals(
                                          name: DESKTOP,
                                          value: 10.0,
                                        ),
                                      ],
                                    ).value,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size:
                                    ResponsiveValue<double>(
                                      context,
                                      defaultValue: 24.0,
                                      conditionalValues: const [
                                        Condition.equals(
                                          name: MOBILE,
                                          value: 20.0,
                                        ),
                                        Condition.equals(
                                          name: TABLET,
                                          value: 24.0,
                                        ),
                                        Condition.equals(
                                          name: DESKTOP,
                                          value: 28.0,
                                        ),
                                      ],
                                    ).value,
                                color: Colors.black,
                              ),
                            ],
                          ),
                ),
                SizedBox(height: spacing),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(
                    _isLoginMode
                        ? '¿No tienes cuenta? Regístrate'
                        : '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(
                      fontSize:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.04,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 14.0),
                              Condition.equals(name: TABLET, value: 16.0),
                              Condition.equals(name: DESKTOP, value: 18.0),
                            ],
                          ).value,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
