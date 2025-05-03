import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:responsive_framework/responsive_framework.dart';
import 'avatar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 500, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
            ],
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

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
    // ignore: unused_local_variable
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // ignore: unused_local_variable
    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double padding =
        size.width * (isMobile ? 0.07 : (isTablet ? 0.08 : 0.09));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  onPressed: () {
                    _player.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterSelectionScreen(),
                      ),
                    );
                  },
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continuar',
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
                              defaultValue: 8.0,
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
      ),
    );
  }
}
