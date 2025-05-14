import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'registro.dart';
import 'resnum.dart';

// Constantes para breakpoints
const mobileBreakpoint = 'MOBILE';
const tabletBreakpoint = 'TABLET';
const desktopBreakpoint = 'DESKTOP';

// Constantes para valores responsivos
class ResponsiveSizes {
  static ResponsiveValue<double> padding(BuildContext context) =>
      ResponsiveValue<double>(
        context,
        defaultValue: 16.0,
        conditionalValues: const [
          Condition.largerThan(name: tabletBreakpoint, value: 32.0),
          Condition.largerThan(name: desktopBreakpoint, value: 64.0),
        ],
      );

  static ResponsiveValue<double> spacing(BuildContext context) =>
      ResponsiveValue<double>(
        context,
        defaultValue: 30.0,
        conditionalValues: const [
          Condition.largerThan(name: tabletBreakpoint, value: 40.0),
          Condition.largerThan(name: desktopBreakpoint, value: 50.0),
        ],
      );

  static ResponsiveValue<double> fontSizeTitle(BuildContext context) =>
      ResponsiveValue<double>(
        context,
        defaultValue: 40.0,
        conditionalValues: const [
          Condition.largerThan(name: tabletBreakpoint, value: 48.0),
          Condition.largerThan(name: desktopBreakpoint, value: 56.0),
        ],
      );

  static ResponsiveValue<double> fontSizeX(BuildContext context) =>
      ResponsiveValue<double>(
        context,
        defaultValue: 46.0,
        conditionalValues: const [
          Condition.largerThan(name: tabletBreakpoint, value: 54.0),
          Condition.largerThan(name: desktopBreakpoint, value: 62.0),
        ],
      );

  static ResponsiveValue<double> buttonPaddingHorizontal(
    BuildContext context,
  ) => ResponsiveValue<double>(
    context,
    defaultValue: 60.0,
    conditionalValues: const [
      Condition.largerThan(name: tabletBreakpoint, value: 80.0),
      Condition.largerThan(name: desktopBreakpoint, value: 100.0),
    ],
  );

  static ResponsiveValue<double> buttonPaddingVertical(BuildContext context) =>
      ResponsiveValue<double>(
        context,
        defaultValue: 20.0,
        conditionalValues: const [
          Condition.largerThan(name: tabletBreakpoint, value: 25.0),
          Condition.largerThan(name: desktopBreakpoint, value: 30.0),
        ],
      );
}

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
              const Breakpoint(start: 0, end: 360, name: mobileBreakpoint),
              const Breakpoint(start: 361, end: 600, name: tabletBreakpoint),
              const Breakpoint(start: 601, end: 1200, name: desktopBreakpoint),
              const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
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
  bool isPlaying = false;

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
    setState(() => isPlaying = false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Future<void> _playAudio() async {
    if (isPlaying) {
      await player.stop();
      setState(() => isPlaying = false);
    } else {
      try {
        await player.play(AssetSource('audios/Regis.mp3'));
        setState(() => isPlaying = true);
      } catch (e) {
        print("Error al reproducir el audio: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSizes.padding(context).value,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: ResponsiveSizes.spacing(context).value),
                _buildTitle(context),
                SizedBox(height: ResponsiveSizes.spacing(context).value),
                _buildImage(context),
                SizedBox(height: ResponsiveSizes.spacing(context).value),
                _buildAudioButton(context),
                SizedBox(height: ResponsiveSizes.spacing(context).value * 0.5),
                _buildButtons(context),
                SizedBox(height: ResponsiveSizes.spacing(context).value),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'LETRA',
          style: TextStyle(
            fontSize: ResponsiveSizes.fontSizeTitle(context).value,
            fontWeight: FontWeight.w900,
            color: Colors.blue,
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(width: ResponsiveSizes.spacing(context).value * 0.5),
        Text(
          'X',
          style: TextStyle(
            fontSize: ResponsiveSizes.fontSizeX(context).value,
            fontWeight: FontWeight.w900,
            color: Colors.red,
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(width: ResponsiveSizes.spacing(context).value * 0.5),
        Text(
          'LETRA',
          style: TextStyle(
            fontSize: ResponsiveSizes.fontSizeTitle(context).value,
            fontWeight: FontWeight.w900,
            color: Colors.blue,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: ResponsiveScaledBox(
        width:
            ResponsiveValue<double>(
              context,
              defaultValue: 300,
              conditionalValues: const [
                Condition.largerThan(name: tabletBreakpoint, value: 400),
                Condition.largerThan(name: desktopBreakpoint, value: 500),
              ],
            ).value,
        child: Image.asset(
          'assets/registro.jpg',
          fit: BoxFit.contain,
          errorBuilder:
              (context, error, stackTrace) => const Icon(Icons.error, size: 50),
        ),
      ),
    );
  }

  Widget _buildAudioButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        isPlaying ? Icons.volume_off : Icons.volume_up,
        color: Colors.black,
        size:
            ResponsiveValue<double>(
              context,
              defaultValue: 36.0,
              conditionalValues: const [
                Condition.largerThan(name: tabletBreakpoint, value: 42.0),
                Condition.largerThan(name: desktopBreakpoint, value: 48.0),
              ],
            ).value,
      ),
      onPressed: _playAudio,
    );
  }

  Widget _buildButtons(BuildContext context) {
    return ResponsiveRowColumn(
      rowMainAxisAlignment: MainAxisAlignment.center,
      columnSpacing: ResponsiveSizes.spacing(context).value * 0.5,
      rowSpacing: ResponsiveSizes.spacing(context).value * 0.5,
      layout:
          ResponsiveBreakpoints.of(context).isMobile
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
      children: [
        ResponsiveRowColumnItem(
          child: _buildButton(context, 'Registrate', const PantallaInicio()),
        ),
        ResponsiveRowColumnItem(
          child: _buildButton(
            context,
            'Inicia Sesión',
            const ResnumScreen(nombre: '', edad: ''),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget screen) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToScreen(context, screen),
      label: Text(
        label,
        style: TextStyle(
          fontSize:
              ResponsiveValue<double>(
                context,
                defaultValue: 22.0,
                conditionalValues: const [
                  Condition.largerThan(name: tabletBreakpoint, value: 26.0),
                  Condition.largerThan(name: desktopBreakpoint, value: 30.0),
                ],
              ).value,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE23B),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSizes.buttonPaddingHorizontal(context).value,
          vertical: ResponsiveSizes.buttonPaddingVertical(context).value,
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
                Condition.largerThan(name: tabletBreakpoint, value: 28.0),
                Condition.largerThan(name: desktopBreakpoint, value: 32.0),
              ],
            ).value,
      ),
    );
  }
}
