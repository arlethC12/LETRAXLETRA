import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'registro.dart';
import 'resnum.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 360, name: 'MOBILE'),
              const Breakpoint(start: 361, end: 600, name: 'TABLET'),
              const Breakpoint(start: 601, end: 1200, name: 'DESKTOP'),
            ],
          ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  void _navigateToScreen(BuildContext context, Widget screen) async {
    await player.stop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: 16.0,
                    conditionalValues: const [
                      Condition.largerThan(name: 'TABLET', value: 32.0),
                      Condition.largerThan(name: 'DESKTOP', value: 64.0),
                    ],
                  ).value,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: 30.0,
                        conditionalValues: const [
                          Condition.largerThan(name: 'TABLET', value: 40.0),
                          Condition.largerThan(name: 'DESKTOP', value: 50.0),
                        ],
                      ).value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'LETRA',
                      style: TextStyle(
                        fontSize:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: 40.0,
                              conditionalValues: const [
                                Condition.largerThan(
                                  name: 'TABLET',
                                  value: 48.0,
                                ),
                                Condition.largerThan(
                                  name: 'DESKTOP',
                                  value: 56.0,
                                ),
                              ],
                            ).value,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(
                      width:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: 10.0,
                            conditionalValues: const [
                              Condition.largerThan(name: 'TABLET', value: 15.0),
                              Condition.largerThan(
                                name: 'DESKTOP',
                                value: 20.0,
                              ),
                            ],
                          ).value,
                    ),
                    Text(
                      'X',
                      style: TextStyle(
                        fontSize:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: 46.0,
                              conditionalValues: const [
                                Condition.largerThan(
                                  name: 'TABLET',
                                  value: 54.0,
                                ),
                                Condition.largerThan(
                                  name: 'DESKTOP',
                                  value: 62.0,
                                ),
                              ],
                            ).value,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(
                      width:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: 10.0,
                            conditionalValues: const [
                              Condition.largerThan(name: 'TABLET', value: 15.0),
                              Condition.largerThan(
                                name: 'DESKTOP',
                                value: 20.0,
                              ),
                            ],
                          ).value,
                    ),
                    Text(
                      'LETRA',
                      style: TextStyle(
                        fontSize:
                            ResponsiveValue<double>(
                              context,
                              defaultValue: 40.0,
                              conditionalValues: const [
                                Condition.largerThan(
                                  name: 'TABLET',
                                  value: 48.0,
                                ),
                                Condition.largerThan(
                                  name: 'DESKTOP',
                                  value: 56.0,
                                ),
                              ],
                            ).value,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: 30.0,
                        conditionalValues: const [
                          Condition.largerThan(name: 'TABLET', value: 40.0),
                          Condition.largerThan(name: 'DESKTOP', value: 50.0),
                        ],
                      ).value,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: FractionallySizedBox(
                    widthFactor:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: 0.7,
                          conditionalValues: const [
                            Condition.largerThan(name: 'TABLET', value: 0.5),
                            Condition.largerThan(name: 'DESKTOP', value: 0.4),
                          ],
                        ).value,
                    child: Image.asset(
                      'assets/registro.jpg',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 50),
                    ),
                  ),
                ),
                SizedBox(
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: 30.0,
                        conditionalValues: const [
                          Condition.largerThan(name: 'TABLET', value: 40.0),
                          Condition.largerThan(name: 'DESKTOP', value: 50.0),
                        ],
                      ).value,
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.black,
                    size:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: 36.0,
                          conditionalValues: const [
                            Condition.largerThan(name: 'TABLET', value: 42.0),
                            Condition.largerThan(name: 'DESKTOP', value: 48.0),
                          ],
                        ).value,
                  ),
                  onPressed: () async {
                    try {
                      await player.play(AssetSource('audios/Regis.mp3'));
                    } catch (e) {
                      print("Error al reproducir el audio: $e");
                    }
                  },
                ),
                SizedBox(
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: 20.0,
                        conditionalValues: const [
                          Condition.largerThan(name: 'TABLET', value: 25.0),
                          Condition.largerThan(name: 'DESKTOP', value: 30.0),
                        ],
                      ).value,
                ),
                ResponsiveBreakpoints.of(context).breakpoint.name == 'TABLET' ||
                        ResponsiveBreakpoints.of(context).breakpoint.name ==
                            'DESKTOP'
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(
                          context,
                          'Registrate',
                          const PantallaInicio(),
                        ),
                        SizedBox(
                          width:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: 20.0,
                                conditionalValues: const [
                                  Condition.largerThan(
                                    name: 'TABLET',
                                    value: 30.0,
                                  ),
                                  Condition.largerThan(
                                    name: 'DESKTOP',
                                    value: 40.0,
                                  ),
                                ],
                              ).value,
                        ),
                        _buildButton(
                          context,
                          'Inicia Sesión',
                          ResnumScreen(nombre: '', edad: ''),
                        ),
                      ],
                    )
                    : Column(
                      children: [
                        _buildButton(
                          context,
                          'Registrate',
                          const PantallaInicio(),
                        ),
                        SizedBox(
                          height:
                              ResponsiveValue<double>(
                                context,
                                defaultValue: 18.0,
                                conditionalValues: const [
                                  Condition.largerThan(
                                    name: 'TABLET',
                                    value: 25.0,
                                  ),
                                  Condition.largerThan(
                                    name: 'DESKTOP',
                                    value: 30.0,
                                  ),
                                ],
                              ).value,
                        ),
                        _buildButton(
                          context,
                          'Inicia Sesión',
                          const ResnumScreen(nombre: '', edad: ''),
                        ),
                      ],
                    ),
                SizedBox(
                  height:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: 30.0,
                        conditionalValues: const [
                          Condition.largerThan(name: 'TABLET', value: 40.0),
                          Condition.largerThan(name: 'DESKTOP', value: 50.0),
                        ],
                      ).value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget screen) {
    return ElevatedButton.icon(
      onPressed: () {
        _navigateToScreen(context, screen);
      },
      label: Text(
        label,
        style: TextStyle(
          fontSize:
              ResponsiveValue<double>(
                context,
                defaultValue: 22.0,
                conditionalValues: const [
                  Condition.largerThan(name: 'TABLET', value: 26.0),
                  Condition.largerThan(name: 'DESKTOP', value: 30.0),
                ],
              ).value,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE23B),
        padding: EdgeInsets.symmetric(
          horizontal:
              ResponsiveValue<double>(
                context,
                defaultValue: 60.0,
                conditionalValues: const [
                  Condition.largerThan(name: 'TABLET', value: 80.0),
                  Condition.largerThan(name: 'DESKTOP', value: 100.0),
                ],
              ).value,
          vertical:
              ResponsiveValue<double>(
                context,
                defaultValue: 20.0,
                conditionalValues: const [
                  Condition.largerThan(name: 'TABLET', value: 25.0),
                  Condition.largerThan(name: 'DESKTOP', value: 30.0),
                ],
              ).value,
        ),
      ),
      icon: Icon(
        Icons.arrow_forward,
        color: Colors.black,
        size:
            ResponsiveValue<double>(
              context,
              defaultValue: 24.0,
              conditionalValues: const [
                Condition.largerThan(name: 'TABLET', value: 28.0),
                Condition.largerThan(name: 'DESKTOP', value: 32.0),
              ],
            ).value,
      ),
    );
  }
}
