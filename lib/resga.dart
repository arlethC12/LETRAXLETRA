import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:responsive_framework/responsive_framework.dart';
import 'resnum.dart';
import 'registro.dart';

void main() {
  runApp(const Resga());
}

class Resga extends StatelessWidget {
  const Resga({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ResponsiveScreen(),
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

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _controller = TextEditingController();

  // Reconocimiento de voz
  late stt.SpeechToText _speech;
  bool _isListening = false;

  // Mapa de palabras a números
  final Map<String, String> _wordToNumber = {
    'uno': '1',
    'dos': '2',
    'tres': '3',
    'cuatro': '4',
    'cinco': '5',
    'seis': '6',
    'siete': '7',
    'ocho': '8',
    'nueve': '9',
    'diez': '10',
    // Puedes agregar más si lo deseas
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _playAudio() async {
    await _player.play(AssetSource('audios/edad.mp3'));
  }

  void _stopAudio() async {
    await _player.stop();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Status: $val'),
        onError: (val) => print('Error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              String recognizedWords = val.recognizedWords.toLowerCase();
              _controller.text =
                  _wordToNumber[recognizedWords] ?? recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    // ignore: unused_local_variable
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // ignore: unused_local_variable
    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double padding =
        size.width * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.07));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveValue<double>(
            context,
            defaultValue: 60.0,
            conditionalValues: const [
              Condition.equals(name: MOBILE, value: 50.0),
              Condition.equals(name: TABLET, value: 60.0),
              Condition.equals(name: DESKTOP, value: 70.0),
            ],
          ).value,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
              _stopAudio();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PantallaInicio()),
              );
            },
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LinearProgressIndicator(
                value: 0.75,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                minHeight:
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
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: spacing),
              Image.asset(
                'assets/añojaguar.jpg',
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.height * 0.6,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 220.0),
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
                        defaultValue: 30.0,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 25.0),
                          Condition.equals(name: TABLET, value: 30.0),
                          Condition.equals(name: DESKTOP, value: 35.0),
                        ],
                      ).value,
                  color: Colors.black,
                ),
                onPressed: _playAudio,
              ),
              SizedBox(height: spacing),
              Text(
                '¿Cuántos años tienes?',
                style: TextStyle(
                  fontSize:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.08,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 18.0),
                          Condition.equals(name: TABLET, value: 20.0),
                          Condition.equals(name: DESKTOP, value: 24.0),
                        ],
                      ).value,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing * 0.5),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Tu edad es...',
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
                  suffixIcon: IconButton(
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
                      color:
                          _isListening
                              ? const Color.fromARGB(255, 5, 7, 8)
                              : Colors.black,
                    ),
                    onPressed: _listen,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: spacing * 2),
              ElevatedButton(
                onPressed: () {
                  _stopAudio();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.width * 0.06,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 20.0),
                            Condition.equals(name: TABLET, value: 30.0),
                            Condition.equals(name: DESKTOP, value: 40.0),
                          ],
                        ).value,
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
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
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
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: size.width * 0.045,
                              conditionalValues: const [
                                Condition.equals(name: MOBILE, value: 14.0),
                                Condition.equals(name: TABLET, value: 16.0),
                                Condition.equals(name: DESKTOP, value: 18.0),
                              ],
                            ).value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: 9.0,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 6.0),
                              Condition.equals(name: TABLET, value: 8.0),
                              Condition.equals(name: DESKTOP, value: 10.0),
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
                              Condition.equals(name: MOBILE, value: 20.0),
                              Condition.equals(name: TABLET, value: 24.0),
                              Condition.equals(name: DESKTOP, value: 28.0),
                            ],
                          ).value,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
